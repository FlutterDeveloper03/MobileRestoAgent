import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/table.dart';
import 'package:shared_preferences/shared_preferences.dart';

// === === === === === === === === STATES === === === === === === === ===

abstract class TableState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyState extends TableState {}

class LoadingState extends TableState {}

class ErrorState extends TableState {}

class LoadedState extends TableState {
  final List<Table> tables;

  LoadedState({required this.tables});

  @override
  List<Object> get props => [tables];
}

// === === === === === === === === Events === === === === === === === ===

abstract class TableEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends TableEvent {
  final String tableCategory;

  LoadEvent({this.tableCategory = ''});

  @override
  List<Object> get props => [tableCategory];
}

class MoveTableEvent extends TableEvent {
  final Table fromTable;
  final Table toTable;

  MoveTableEvent(this.fromTable, this.toTable);

  @override
  List<Object> get props => [fromTable, toTable];
}

// === === === === === === === === BLoC === === === === === === === ===

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(EmptyState());
  FromHive hive = FromHive();
  List<Table> tables = [];

  Stream<TableState> mapEventToState(TableEvent event) async* {
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
    if (event is LoadEvent) {
      yield LoadingState();
      try {
        tables = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).getTables(event.tableCategory);
        if (tables.isNotEmpty) {
          hive.putTables(tables.map((e) => e.toMap()).toList());
        }
      } catch (e) {
        print('Print error in TableBloc while loading tables: $e');
      }
      if (tables.isEmpty) {
        try {
          tables = await hive.getTables();
        } catch (e) {
          print('Print error on getting tables from hive');
        }
      }
      yield LoadedState(tables: tables);
    } else if (event is MoveTableEvent) {
      yield LoadingState();
      try {
        await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).moveTable(event.fromTable, event.toTable);

        tables = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).getTables('');
        if (tables.isNotEmpty) {
          hive.putTables(tables.map((e) => e.toMap()).toList());
        }
      } catch (e) {
        print('Print error in TableBloc while loading tables: $e');
      }
      if (tables.isEmpty) {
        try {
          tables = await hive.getTables();
        } catch (e) {
          print('Print error on getting tables from hive');
        }
      }
      yield LoadedState(tables: tables);
    }
  }
}
