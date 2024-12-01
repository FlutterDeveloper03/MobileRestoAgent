import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/Exception.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:shared_preferences/shared_preferences.dart';

// === === === === === === === === STATES === === === === === === === ===

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewFormState extends LoginState {}

class LoadingState extends LoginState {}

class UnsuccessfulState extends LoginState {
  final String text;
  UnsuccessfulState(this.text);
}

class SuccessfulState extends LoginState {
  final String waiterName;
  SuccessfulState({required this.waiterName});
}

// === === === === === === === === Events === === === === === === === ===

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitEvent extends LoginEvent {
  final String name;
  final String password;
  SubmitEvent({required this.name, required this.password});

  @override
  List<Object> get props => [name, password];
}

// === === === === === === === === BLoC === === === === === === === ===

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(NewFormState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    String serverAddress = "";
    String serverPort = "";
    String dbUName = "";
    String dbUPass = "";
    String dbName = "";
    final _sharedPref = await SharedPreferences.getInstance();
    int selectedDbConnectionType = _sharedPref.getInt(SharedPrefKeys.selectedDbConnectionType) ?? 0;
    if (selectedDbConnectionType == 0) {
      serverAddress = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[0] ?? SharedPrefKeys.defaultUrl.split(":")[0];
      serverPort = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[1] ?? SharedPrefKeys.defaultUrl.split(":")[1];
      dbUName = _sharedPref.getString(SharedPrefKeys.DbUName) ?? SharedPrefKeys.defaultDbUName;
      dbUPass = _sharedPref.getString(SharedPrefKeys.DbUPass) ?? '';
      dbName = _sharedPref.getString(SharedPrefKeys.DbName) ?? SharedPrefKeys.defaultDbName;
    }
    String baseUrl = _sharedPref.getString(SharedPrefKeys.baseUrl) ??
        SharedPrefKeys.defaultUrl;
    if (event is SubmitEvent) {
      yield LoadingState();
      try {
        if (event.name.isEmpty && event.password.isEmpty) {
          yield UnsuccessfulState('name_and_password_fields_are_empty');
        } else if (event.name.isEmpty) {
          yield UnsuccessfulState('name_field_is_empty');
        } else if (event.password.isEmpty) {
          yield UnsuccessfulState('password_field_is_empty');
        } else if (event.name.contains(RegExp(r"'")) ||
            event.password.contains(RegExp(r"'"))) {
          yield UnsuccessfulState('only_numbers_and_letters');
        } else {
          TblMgSalesman? salesman = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass)
              .loginUser(event.name, event.password);
          if (salesman!=null){
            await _sharedPref.setString(
              SharedPrefKeys.salesman,
              jsonEncode(salesman.toMap()),
            );
            yield SuccessfulState(waiterName: salesman.salesmanName);
          } else {
            yield UnsuccessfulState('user_not_found');
          }

        }
      } on UserNotFounException catch (e) {
        print('Print user_not_found:$e');
        yield UnsuccessfulState('user_not_found');
      } catch (e) {
        yield UnsuccessfulState('unkown_error');
      }
    }
  }
}
