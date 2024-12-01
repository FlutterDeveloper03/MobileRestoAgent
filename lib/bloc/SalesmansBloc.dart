import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:shared_preferences/shared_preferences.dart';


//region events
abstract class SalesmansEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSalesmansEvent extends SalesmansEvent {}
//endregion events

//region States
abstract class SalesmansState extends Equatable {
  @override
  List<Object> get props => [];
}

class SalesmansEmptyState extends SalesmansState {}
class SalesmansInitialState extends SalesmansState {}

class LoadingSalesmansState extends SalesmansState {}

class ErrorLoadSalesmansState extends SalesmansState {}

class SalesmansLoadedState extends SalesmansState {
  final List<TblMgSalesman> salesmans;

  SalesmansLoadedState({required this.salesmans});

  @override
  List<Object> get props => [salesmans];
}

//endregion States

//region Bloc
class SalesmansBloc extends Bloc<SalesmansEvent, SalesmansState> {
  SalesmansBloc() : super(SalesmansInitialState());
  FromHive hive = FromHive();
  List<TblMgSalesman> salesmans = [];

  Stream<SalesmansState> mapEventToState(SalesmansEvent event) async* {
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
    String baseUrl = _sharedPref.getString(SharedPrefKeys.baseUrl) ?? SharedPrefKeys.defaultUrl;
    if (event is LoadSalesmansEvent) {
      yield LoadingSalesmansState();
      try {
        salesmans = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).getSalesmans();
        if (salesmans.isNotEmpty) {
          hive.putSalesmans(salesmans.map((e) => e.toMap()).toList());
        }
      } catch (e) {
        print('PrintError: error in TableBloc while loading tables: $e');
      }
      if (salesmans.isEmpty) {
        try {
          salesmans = await hive.getSalesmans();
        } catch (e) {
          print('PrintError=>> error on getting tables from hive');
        }
      }
      yield SalesmansLoadedState(salesmans: salesmans);
    }
  }
}
//endregion Bloc
