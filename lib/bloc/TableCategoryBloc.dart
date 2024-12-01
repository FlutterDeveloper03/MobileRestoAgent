import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/tbl_dk_table_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* === === === === === === === === Events === === === === === === === === */
abstract class TableCategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTableCategoriesEvent extends TableCategoryEvent {}

/* === === === === === === === === STATES === === === === === === === === */
abstract class TableCategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class TableCategoriesInitialState extends TableCategoryState {}
class TableCategoriesEmptyState extends TableCategoryState {}

class LoadingTableCategoriesState extends TableCategoryState {}

class ErrorLoadTableCategoriesState extends TableCategoryState {}

class TableCategoriesLoadedState extends TableCategoryState {
  final List<TblDkTableCategory> tableCategories;
  TableCategoriesLoadedState({required this.tableCategories});
  @override
  List<Object> get props => [tableCategories];
}

/* === === === === === === === === BLoC === === === === === === === === */
class TableCategoryBloc extends Bloc<TableCategoryEvent, TableCategoryState> {
  FromHive hive = FromHive();
  TableCategoryBloc() : super(TableCategoriesInitialState());
  List<TblDkTableCategory> tableCategories = [];

  Stream<TableCategoryState> mapEventToState(TableCategoryEvent event) async* {
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
    if (event is LoadTableCategoriesEvent) {
      yield LoadingTableCategoriesState();
      try {
        tableCategories = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).getTableCategories();
        if (tableCategories.isNotEmpty) {
          hive.putTableCategories(tableCategories.map((e) => e.toMap()).toList());
        }
      } catch (e) {
        print('PrintError:$e');
      }
      if (tableCategories.isEmpty) {
        try {
          tableCategories = await hive.getTableCategories();
        } catch (e) {
          print('PrintError: $e');
        }
      }
      tableCategories.sort((a, b) => a.tableCatName.compareTo(b.tableCatName));
      yield TableCategoriesLoadedState(tableCategories: tableCategories);
    }
  }
}