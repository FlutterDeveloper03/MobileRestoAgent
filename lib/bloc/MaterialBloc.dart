import 'dart:convert';
import 'dart:io';
import 'package:mobile_resto_agent/Helpers/Printer.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/data/remote/QueryFromApi.dart';
import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/model/printerReport.dart';
import 'package:mobile_resto_agent/model/table.dart';
import 'package:mobile_resto_agent/model/tbl_mg_mat_attributes.dart';
import 'package:mobile_resto_agent/model/tbl_mg_materials.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:udp/udp.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// === === === === === === === === STATES === === === === === === === ===

abstract class MaterialBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyState extends MaterialBlocState {}

class LoadingState extends MaterialBlocState {}

class LoadedState extends MaterialBlocState {
  final List<TblMgMaterials> materials;
  final List<CartItem> cartItems;
  final TblMgSalesman? salesman;

  LoadedState(this.materials, this.cartItems,this.salesman);

  @override
  List<Object> get props => [materials, cartItems];

  @override
  toString()=>"LoadedState. MaterialCount=${materials.length.toString()}, cartItemsCount=${cartItems.length.toString()}";
}

// class NewLoadedState extends MaterialBlocState {
//   final List<TblMgMaterials> materials;
//   final List<CartItem> cartItems;
//   NewLoadedState(this.materials, this.cartItems);
//   @override
//   List<Object> get props => [materials, cartItems];
// }

class ReportState extends MaterialBlocState {
  final List<TblMgMaterials> materials;
  final List<CartItem> cartItems;
  final List<PrinterReport>? reports;
  final int? selectedPrintType;

  ReportState(this.materials, this.cartItems, {this.reports, this.selectedPrintType});

  @override
  List<Object> get props => [materials, cartItems];

  @override
  toString()=>"ReportState CartItemsCount: ${cartItems.length.toString()}";
}

class LoadedWithMessageState extends MaterialBlocState {
  final List<TblMgMaterials> materials;
  final List<CartItem> cartItems;
  final String message;

  LoadedWithMessageState({
    required this.materials,
    required this.cartItems,
    required this.message,
  });

  @override
  List<Object> get props => [materials, cartItems, message];
}

// === === === === === === ===  ===EVENTS === === === === === === === ===

abstract class MaterialEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMaterialEvent extends MaterialEvent {}

class PlusCount extends MaterialEvent {
  final TblMgMaterials material;

  PlusCount({required this.material});

  @override
  List<Object> get props => [material];

  @override
  toString()=>"PlusCountState Material:${material.materialName.toString()}";
}

class MinusCount extends MaterialEvent {
  final TblMgMaterials material;

  MinusCount({required this.material});

  @override
  List<Object> get props => [material];
}

class NewValue extends MaterialEvent {
  final TblMgMaterials material;
  final List<TblMgMatAttributes> matAttributes;
  final double count;

  NewValue({required this.material, required this.matAttributes, required this.count});

  @override
  List<Object> get props => [material,matAttributes,count];
}

class SetDescription extends MaterialEvent {
  final String fichLineDesc;
  SetDescription({required this.fichLineDesc});

  @override
  List<Object> get props => [fichLineDesc];
}

class CleanCart extends MaterialEvent {}

class InsertFichLines extends MaterialEvent {
  final Table table;

  InsertFichLines({required this.table});

  @override
  List<Object> get props => [table];

  @override
  toString()=>"InsertFichLinesEvent Table:${table.tableName.toString()}";
}

class UpdateMaterialStatus extends MaterialEvent {
  final int status;
  final TblMgMaterials material;

  UpdateMaterialStatus({required this.status, required this.material});

  @override
  List<Object> get props => [status, material];

  @override
  toString()=>"UpdateMaterialStatus: $status, $material";
}

class GetByCatIdEvent extends MaterialEvent {
  final int id;

  GetByCatIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SearchEvent extends MaterialEvent {
  final String search;
  final AppLocalizations locale;

  SearchEvent({required this.search, required this.locale});

  @override
  List<Object> get props => [search, locale];
}



// === === === === === === === === BLoC === === === === === === === ===

class MaterialBloc extends Bloc<MaterialEvent, MaterialBlocState> {
  // QuerryApiClient api = QuerryApiClient();
  List<TblMgMaterials> materials = [];
  List<CartItem> cartItems = [];
  FromHive hive = FromHive();

  MaterialBloc() : super(EmptyState());

  @override
  void onTransition(Transition<MaterialEvent, MaterialBlocState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<MaterialBlocState> mapEventToState(MaterialEvent event) async* {
    String serverAddress = "";
    String serverPort = "";
    String dbUName = "";
    String dbUPass = "";
    String dbName = "";
    final _sharedPref = await SharedPreferences.getInstance();
    TblMgSalesman? salesman;
    try {
      salesman=TblMgSalesman.fromMap(jsonDecode(_sharedPref.getString(SharedPrefKeys.salesman) ?? ''));
    } catch (e) {
      print('Print can not get salesman:$e');
    }
    int selectedDbConnectionType = _sharedPref.getInt(SharedPrefKeys.selectedDbConnectionType) ?? 0;
    if (selectedDbConnectionType == 0) {
      serverAddress = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[0] ?? SharedPrefKeys.defaultUrl.split(":")[0];
      serverPort = _sharedPref.getString(SharedPrefKeys.baseUrl)?.split(":")[1] ?? SharedPrefKeys.defaultUrl.split(":")[1];
      dbUName = _sharedPref.getString(SharedPrefKeys.DbUName) ?? SharedPrefKeys.defaultDbUName;
      dbUPass = _sharedPref.getString(SharedPrefKeys.DbUPass) ?? '';
      dbName = _sharedPref.getString(SharedPrefKeys.DbName) ?? SharedPrefKeys.defaultDbName;
    }
    String baseUrl = _sharedPref.getString(SharedPrefKeys.baseUrl) ?? SharedPrefKeys.defaultUrl;
    if (event is GetMaterialEvent) {
      yield LoadingState();
      try {
        materials = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).getMaterial();
        if (materials.isNotEmpty) {
          hive.putMaterials(materials.map((e) => e.toMap()).toList());
        }
      } catch (e) {
        print('Print material api and hive put error $e');
      }
      if (materials.isEmpty) {
        try {
          materials = await hive.getMaterial();
        } catch (e) {
          print('Print material hive get error $e');
        }
      }
      yield LoadedState(materials, cartItems,salesman);
    } else if (event is GetByCatIdEvent) {
      yield LoadingState();
      try {
        materials = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).getMaterialByCat(event.id);
        if (materials.isNotEmpty) {
          hive.putMaterials(materials.map((e) => e.toMap()).toList());
        }
      } catch (e) {
        print('Print material api and hive put error $e');
      }
      if (materials.isEmpty) {
        try {
          materials = await hive.getMaterial();
        } catch (e) {
          print('Print material hive get error $e');
        }
      }
      yield LoadedState(materials, cartItems,salesman);
    } else if (event is SearchEvent) {
      List<TblMgMaterials> searched = [];
      for (var e in materials) {
        String catName = e.name(event.locale).toLowerCase();
        String search = event.search.toLowerCase();
        if (catName.contains(search)) {
          searched.add(e);
          print('Print ${e.matNameLang1}');
        }
      }
      yield LoadedState(searched, cartItems,salesman);
    } else if (event is PlusCount) {
      yield LoadingState();
      if (cartItems.isNotEmpty) {
        CartItem cartItem;
        int index = 0;
        if (cartItems.any((element) => element.material.id == event.material.id)) {
          cartItem = cartItems.firstWhere((element) => element.material.id == event.material.id);
        } else {
          cartItem = CartItem(material: event.material, fich_line_desc: '',matAttributes: [], count: 0);
        }
        index = cartItems.indexOf(cartItem);
        if (cartItems.remove(cartItem)) {
          cartItems.insert(
            index,
            CartItem(material: event.material,fich_line_desc: cartItem.fich_line_desc,matAttributes: cartItem.matAttributes, count: cartItem.count + 1),
          );
        } else {
          cartItems.add(CartItem(material: event.material, fich_line_desc: '',matAttributes: [],count: 1));
        }
      } else {
        cartItems.add(CartItem(material: event.material, fich_line_desc: '',matAttributes: [],count: 1));
      }
      yield LoadedState(materials, cartItems,salesman);
    } else if (event is NewValue) {
      yield LoadingState();
      if (cartItems.isNotEmpty) {
        CartItem cartItem;
        int index = 0;
        if (cartItems.any((element) => element.material.id == event.material.id)) {
          cartItem = cartItems.firstWhere((element) => element.material.id == event.material.id);
        } else {
          cartItem = CartItem(material: event.material,fich_line_desc: '',matAttributes: [], count: 0);
        }
        index = cartItems.indexOf(cartItem);
        if (cartItems.remove(cartItem)) {
          cartItems.insert(
            index,
            CartItem(material: event.material, fich_line_desc: cartItem.fich_line_desc,matAttributes: event.matAttributes, count: event.count),
          );
        } else {
          cartItems.add(CartItem(material: event.material,fich_line_desc: '',matAttributes: event.matAttributes, count: event.count));
        }
      } else {
        cartItems.add(CartItem(material: event.material, fich_line_desc: '',matAttributes: event.matAttributes, count: event.count));
      }
      yield LoadedState(materials, cartItems,salesman);
    } else if (event is MinusCount) {
      yield LoadingState();
      if (cartItems.isNotEmpty && cartItems.any((element) => element.material.id == event.material.id)) {
        CartItem cartItem = cartItems.firstWhere((element) => element.material.id == event.material.id);
        int index = cartItems.indexOf(cartItem);
        if (cartItem.count == 1) {
          cartItems.remove(cartItem);
        } else if (cartItem.count > 1) {
          cartItems.remove(cartItem);
          cartItems.insert(
            index,
            CartItem(material: event.material,fich_line_desc: cartItem.fich_line_desc,matAttributes: cartItem.matAttributes, count: cartItem.count - 1),
          );
        }
      }
      yield LoadedState(materials, cartItems,salesman);
    } else if (event is CleanCart) {
      yield LoadingState();
      cartItems.clear();
      yield LoadedState(materials, cartItems,salesman);
    } else if (event is InsertFichLines) {
      try {
        if (event.table.fichId > 0 && cartItems.isNotEmpty) {
          bool result = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).insertFichLines(event.table, cartItems);
          if (result) {
            int _selectedPrintType = _sharedPref.getInt(SharedPrefKeys.selectedPrintType) ?? 0;
            if (_selectedPrintType == 0) {
              List<PrinterReport> reports = await CheckPrinter().printCartItems(
                salesman,
                event.table.fichCode,
                event.table.tableName,
                cartItems,
              );
              cartItems.clear();
              yield ReportState(materials, cartItems, reports: reports, selectedPrintType: 0);
            } else {
              String socketAddress = _sharedPref.getString(SharedPrefKeys.socketAddress) ?? '';
              if (socketAddress.isNotEmpty) {
                try {
                  var udpSender = await UDP.bind(Endpoint.any());
                  print("PrintInfo: Udp sent fich_id:${event.table.fichId}}");
                  var dataLength = udpSender.send('{"fich_id":${event.table.fichId}}'.codeUnits,
                      Endpoint.multicast(InternetAddress(socketAddress.split(':')[0]), port: Port(int.parse(socketAddress.split(':')[1]))));
                  stdout.write("$dataLength bytes sent.");
                } catch (e) {
                  print('PrintError: ${e.toString()}');
                }
              }

              cartItems.clear();
              yield ReportState(materials, cartItems, selectedPrintType: 1);
            }
          } else {
            yield LoadedWithMessageState(
              materials: materials,
              cartItems: cartItems,
              message: 'cart_items_was_not_added_to_fich_lines',
            );
          }
        } else if (cartItems.isNotEmpty && event.table.fichId == 0) {
          TblMgSalesman? salesman;
          try {
            salesman = TblMgSalesman.fromMap(jsonDecode(_sharedPref.getString(SharedPrefKeys.salesman) ?? ''));
          } catch (e) {
            print('Print can not get salesman:$e');
          }
          Map<String,dynamic>? fichMap = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).insertWithFich(cartItems, event.table, salesman);
          if (fichMap != null) {
            int _selectedPrintType = _sharedPref.getInt(SharedPrefKeys.selectedPrintType) ?? 0;
            if (_selectedPrintType == 0) {
              List<PrinterReport> reports = await CheckPrinter().printCartItems(
                salesman,
                fichMap["fich_code"].toString(),
                event.table.tableName,
                cartItems,
              );
              cartItems.clear();
              yield ReportState(materials, cartItems, reports: reports, selectedPrintType: 0);
            } else {
              String socketAddress = _sharedPref.getString(SharedPrefKeys.socketAddress) ?? '';
              if (socketAddress.isNotEmpty) {
                try {
                  var udpSender = await UDP.bind(Endpoint.any());
                  print("PrintInfo: Udp sent fich_id:${event.table.fichId}}");
                  var dataLength = udpSender.send('{"fich_id":${fichMap["fich_id"]}}'.codeUnits,
                      Endpoint.multicast(InternetAddress(socketAddress.split(':')[0]), port: Port(int.parse(socketAddress.split(':')[1]))));
                  stdout.write("$dataLength bytes sent.");
                } catch (e) {
                  print('PrintError: ${e.toString()}');
                }
              }

              cartItems.clear();
              yield ReportState(materials, cartItems, selectedPrintType: 1);
            }
          } else {
            yield LoadedWithMessageState(
              materials: materials,
              cartItems: cartItems,
              message: 'cart_items_was_not_added_to_fich_lines',
            );
          }
        } else {
          yield LoadedState(materials, cartItems,salesman);
        }
      } catch (e) {
        yield LoadedState(materials, cartItems,salesman);
      }
    } else if (event is SetDescription){
      yield LoadingState();
      if (cartItems.isNotEmpty){
        List<CartItem> _modifiedCartItems = cartItems.map((e) => e.copyWith(fich_line_desc: event.fichLineDesc)).toList();
        cartItems = _modifiedCartItems;
      }
      yield LoadedState(materials, cartItems,salesman);
    } else if (event is UpdateMaterialStatus) {
      yield LoadingState();
      if (event.material.aStatusId!=event.status){
        int isUpdated = await QueryFromApi(baseUrl,selectedDbConnectionType,serverAddress: serverAddress,serverPort: serverPort,dbName: dbName,dbUName: dbUName,dbUPass: dbUPass).updateMaterialStatus(event.material,event.status);
        if (isUpdated>0){
          materials[materials.indexWhere((element) => element.id==event.material.id)] = event.material.copyWith(aStatusId: event.status);
        }
        yield LoadedState(materials, cartItems,salesman);
      }

    }
  }
}
