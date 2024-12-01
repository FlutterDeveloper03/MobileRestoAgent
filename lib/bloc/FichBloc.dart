import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/Printer.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/customFichLine.dart';
import 'package:mobile_resto_agent/model/printerReject.dart';
import 'package:mobile_resto_agent/model/table.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* === === === === === === === === STATES === === === === === === === === */

abstract class FichState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyState extends FichState {}

class LoadingState extends FichState {}

class ErrorState extends FichState {}

class FichLoadedState extends FichState {
  final List<CustomFichLine> fichLines;
  final TblMgSalesman salesman;

  FichLoadedState({
    required this.fichLines,
    required this.salesman,
  });

  @override
  List<Object> get props => [fichLines];
}


class LoadedWithFichDelete extends FichState {
  final List<CustomFichLine> fichLines;
  final CustomFichLine fichLine;
  final TblMgSalesman salesman;

  LoadedWithFichDelete({
    required this.fichLines,
    required this.salesman,
    required this.fichLine,
  });

  @override
  List<Object> get props => [fichLines, fichLine, salesman];
}

class LoadedRejects extends FichState {
  final List<CustomFichLine> fichLines;
  final List<CustomFichLine> deleteFichlines;
  final List<PrinterReject> rejects;
  final TblMgSalesman salesman;

  LoadedRejects({
    required this.fichLines,
    required this.deleteFichlines,
    required this.salesman,
    required this.rejects,
  });

  @override
  List<Object> get props => [fichLines, rejects, salesman];
}

class LoadedWithMessageState extends FichState {
  final List<CustomFichLine> fichLines;
  final String message;
  final TblMgSalesman salesman;

  LoadedWithMessageState({
    required this.fichLines,
    required this.message,
    required this.salesman,
  });

  @override
  List<Object> get props => [fichLines, message];
}

class NewLoadedState extends FichState {
  final List<CustomFichLine> fichLines;
  final String salesman;
  final String firmName;
  final String address;
  final String phone;

  NewLoadedState({
    required this.fichLines,
    required this.salesman,
    required this.address,
    required this.firmName,
    required this.phone,
  });

  @override
  List<Object> get props => [fichLines];
}

/* === === === === === === === === Events === === === === === === === === */

abstract class FichEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends FichEvent {
  final int fichId;

  LoadEvent(this.fichId);
}

class DeleteFichLine extends FichEvent {
  final CustomFichLine fichLine;

  DeleteFichLine({required this.fichLine});
}

class DeleteFichLines extends FichEvent {
  final List<CustomFichLine> rejects;
  final Table table;

  DeleteFichLines({required this.rejects, required this.table});
}

class ChangeSalesmanEvent extends FichEvent {
  final int fichId;
  final int toSalesman;

  ChangeSalesmanEvent(this.fichId, this.toSalesman);

  @override
  List<Object> get props => [fichId, toSalesman];
}

class MinusFichLine extends FichEvent {
  final CustomFichLine fichLine;

  MinusFichLine({required this.fichLine});
}

class PlusFichLine extends FichEvent {
  final CustomFichLine fichLine;

  PlusFichLine({required this.fichLine});
}

class CloseOrderAccount extends FichEvent {
  final Table table;

  CloseOrderAccount({required this.table});
}

/* === === === === === === === === BLoC === === === === === === === === */

class FichBloc extends Bloc<FichEvent, FichState> {
  FichBloc() : super(EmptyState());
  List<CustomFichLine> fichLines = [];

  @override
  Stream<FichState> mapEventToState(FichEvent event) async* {
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
    Map<String,dynamic> map = jsonDecode(_sharedPref.getString(SharedPrefKeys.salesman) ?? '');
    TblMgSalesman salesman = TblMgSalesman.fromMap(map);
    if (event is LoadEvent) {
      yield LoadingState();
      try {
        fichLines = await QueryFromApi(baseUrl, selectedDbConnectionType,
                serverAddress: serverAddress, serverPort: serverPort, dbName: dbName, dbUName: dbUName, dbUPass: dbUPass)
            .getFichLines(event.fichId);
      } catch (e) {
        print('Print FichBloc loadEvent error:$e');
      }
      if (fichLines.isEmpty) {
        yield EmptyState();
      }
      yield FichLoadedState(fichLines: fichLines, salesman: salesman);
    } else if (event is CloseOrderAccount) {
      yield LoadingState();
      if (event.table.fichId > 0 && fichLines.isNotEmpty) {
        int salesmanId = 0;
        try {
          salesmanId = salesman.salesmanId;
          await QueryFromApi(baseUrl, selectedDbConnectionType,
                  serverAddress: serverAddress, serverPort: serverPort, dbName: dbName, dbUName: dbUName, dbUPass: dbUPass)
              .closeOrders(fichLines, event.table.fichId, salesmanId, salesman.salesmanWhId);
          String firmName = await QueryFromApi(baseUrl, selectedDbConnectionType,
                  serverAddress: serverAddress, serverPort: serverPort, dbName: dbName, dbUName: dbUName, dbUPass: dbUPass)
              .getFirmName();
          String phoneNumber = _sharedPref.getString(SharedPrefKeys.phoneNumber) ?? '';
          String address = _sharedPref.getString(SharedPrefKeys.address) ?? '';
          yield NewLoadedState(
            fichLines: fichLines,
            phone: phoneNumber,
            address: address,
            salesman: salesman.salesmanName,
            firmName: firmName,
          );
          // fichLines.clear();
        } catch (e) {
          print('Print error catched in fichBloc:$e');
          yield LoadedWithMessageState(
            fichLines: fichLines,
            message: 'account_was_not_closed',
            salesman: salesman,
          );
        }
      }
    } else if (event is DeleteFichLine) {
      print('Print delete fich line was called');
      yield LoadingState();
      try {
        List<CustomFichLine> fichLinesTemp = await QueryFromApi(baseUrl, selectedDbConnectionType,
                serverAddress: serverAddress, serverPort: serverPort, dbName: dbName, dbUName: dbUName, dbUPass: dbUPass)
            .deleteFichLine(event.fichLine);
        if (fichLinesTemp.isNotEmpty && fichLines.length > 1) {
          fichLines = fichLinesTemp;
          yield LoadedWithFichDelete(
            fichLines: fichLines,
            salesman: salesman,
            fichLine: event.fichLine,
          );
        } else if (fichLinesTemp.isEmpty && fichLines.length == 1) {
          fichLines = fichLinesTemp;
          yield LoadedWithFichDelete(
            fichLines: fichLines,
            salesman: salesman,
            fichLine: event.fichLine,
          );
        } else {
          yield FichLoadedState(fichLines: fichLines, salesman: salesman);
        }
        print('Print fichlines length:${fichLines.length}');
      } catch (e) {
        if (fichLines.isEmpty) {
          yield EmptyState();
        } else {
          yield LoadedWithMessageState(
            fichLines: fichLines,
            salesman: salesman,
            message: 'Some error',
          );
        }
        print('Print FichBloc loadEvent error:$e');
      }
    } else if (event is DeleteFichLines) {
      print('Print DeleteFichLines was called');
      yield LoadingState();
      if (event.rejects.isNotEmpty) {
        try {
          List<CustomFichLine> fichLinesTemp = await QueryFromApi(baseUrl, selectedDbConnectionType,
                  serverAddress: serverAddress, serverPort: serverPort, dbName: dbName, dbUName: dbUName, dbUPass: dbUPass)
              .deleteFichLines(event.rejects);
          fichLines = fichLinesTemp;
          try {
            salesman = TblMgSalesman.fromMap(jsonDecode(_sharedPref.getString(SharedPrefKeys.salesman) ?? ''));
          } catch (e) {
            print('Print can not get salesman:$e');
          }
          List<PrinterReject> rejects = await CheckPrinter().printRejects(
            salesman,
            event.rejects.first.fichCode,
            event.table.tableName,
            event.rejects,
          );
          yield LoadedRejects(
            fichLines: fichLines,
            salesman: salesman,
            deleteFichlines: event.rejects,
            rejects: rejects,
          );
        } catch (e) {
          print('Print error in FichBloc>DeleteFichLines event: $e');
          yield FichLoadedState(fichLines: fichLines, salesman: salesman);
        }
      } else {
        yield FichLoadedState(fichLines: fichLines, salesman: salesman);
      }
    } else if (event is ChangeSalesmanEvent){
      yield LoadingState();
      try {
        await QueryFromApi(baseUrl, selectedDbConnectionType,
            serverAddress: serverAddress, serverPort: serverPort, dbName: dbName, dbUName: dbUName, dbUPass: dbUPass)
            .changeOrderFichSalesman(event.fichId,event.toSalesman);
        yield FichLoadedState(fichLines: fichLines, salesman: salesman);
      } catch (e){
        print('PrintError: error in FichBloc>ChangeSalesmanEvent: $e');
        yield FichLoadedState(fichLines: fichLines, salesman: salesman);
      }
    }
  }
}
