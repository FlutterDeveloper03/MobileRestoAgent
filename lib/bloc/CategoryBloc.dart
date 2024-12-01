import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/tbl_mg_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* === === === === === === === === STATES === === === === === === === === */

abstract class CategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyState extends CategoryState {}

class LoadingState extends CategoryState {}

class ErrorState extends CategoryState {}

class LoadedState extends CategoryState {
  final List<TblMgCategory> categories;
  LoadedState({required this.categories});
  @override
  List<Object> get props => [categories];
}

/* === === === === === === === === Events === === === === === === === === */

abstract class CategoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEvent extends CategoryEvent {}

class SearchEvent extends CategoryEvent {
  final String search;
  final AppLocalizations locale;
  SearchEvent({required this.search, required this.locale});
}

/* === === === === === === === === BLoC === === === === === === === === */

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  // QuerryApiClient api = QuerryApiClient();
  FromHive hive = FromHive();
  CategoryBloc() : super(EmptyState());
  List<TblMgCategory> categories = [];

  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    final _sharedPref = await SharedPreferences.getInstance();
    String baseUrl = _sharedPref.getString(SharedPrefKeys.baseUrl) ??
        SharedPrefKeys.defaultUrl;
    String serverAddress = "";
    String serverPort = "";
    String dbUName = "";
    String dbUPass = "";
    String dbName = "";
    int selectedDbConnectionType = _sharedPref.getInt(SharedPrefKeys.selectedDbConnectionType) ?? 0;
    if (selectedDbConnectionType==0){
      serverAddress = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[0] ?? SharedPrefKeys.defaultUrl.split(":")[0];
      serverPort = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[1] ?? SharedPrefKeys.defaultUrl.split(":")[1];
      dbUName = _sharedPref.getString(SharedPrefKeys.DbUName) ?? SharedPrefKeys.defaultDbUName;
      dbUPass = _sharedPref.getString(SharedPrefKeys.DbUPass) ?? '';
      dbName = _sharedPref.getString(SharedPrefKeys.DbName) ?? SharedPrefKeys.defaultDbName;
    }
    if (event is LoadEvent) {
      yield LoadingState();
      try {
        categories = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).getCategories();
        if (categories.isNotEmpty) {
          hive.putCategories(categories.map((e) => e.toMap()).toList());
        }
      } catch (e) {
        print('Print Error:$e');
      }
      if (categories.isEmpty) {
        try {
          categories = await hive.getCategories();
        } catch (e) {
          print('Print category hive get error $e');
        }
      }
      categories.sort((a, b) => a.catOrder.compareTo(b.catOrder));
      yield LoadedState(categories: categories);
    } else if (event is SearchEvent) {
      List<TblMgCategory> searched = [];
      for (var e in categories) {
        String catName = e.name(event.locale).toLowerCase();
        String search = event.search.toLowerCase();
        if (catName.contains(search)) {
          searched.add(e);
        }
      }
      categories.sort((a, b) => a.catOrder.compareTo(b.catOrder));
      yield LoadedState(categories: searched);
    }
  }
}
