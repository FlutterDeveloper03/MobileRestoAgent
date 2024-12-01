import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/model/imageModel.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:mobile_resto_agent/model/table.dart';
import 'package:mobile_resto_agent/model/tbl_dk_table_category.dart';
import 'package:mobile_resto_agent/model/tbl_mg_category.dart';
import 'package:mobile_resto_agent/model/tbl_mg_materials.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';

class FromHive {
  final Box<dynamic> box = Hive.box('menu');
  final Box<dynamic> imagesBox = Hive.box('images');
  final String category = 'category';
  final String material = 'material';
  final String table = 'table';
  final String salesman = 'salesman';
  final String tableCategory = 'tableCategory';

  Future<List<TblMgCategory>> getCategories() async {
    dynamic value = box.get(category);
    if (value == null) return [];
    List list = json.decode(value);
    List<TblMgCategory> categories =
        list.map((e) => TblMgCategory.fromJson(e)).toList();
    return categories;
  }

  Future putCategories(List<Map<String, dynamic>> list) async {
    String encoded = json.encode(list);
    try {
      box.put(category, encoded);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<TblMgMaterials>> getMaterial() async {
    dynamic value = box.get(material);
    if (value == null) return [];
    List list = json.decode(value);
    List<TblMgMaterials> materials =
        list.map((e) => TblMgMaterials.fromMap(e)).toList();
    return materials;
  }

  putMaterials(List<Map<String, dynamic>> list) async {
    String encoded = json.encode(list);
    try {
      box.put(material, encoded);
    } catch (e) {
      print('Error: $e');
    }
  }

  ImageModel? getImage({int matId=0,int catId=0}) {
    try{
      if (matId>0){
        ImageModel imageModel = imagesBox.get('mat${matId.toString()}');
        return imageModel;
      } else if (catId>0){
        ImageModel imageModel = imagesBox.get('cat${matId.toString()}');
        return imageModel;
      }
    } catch (e){
      debugPrint("PrintError on getImage from hive: ${e.toString()}");
      return null;
    }


  }

  bool putImage(ImageModel imageModel) {
    try{
      if (imageModel.catId>0){
        imagesBox.put('cat${imageModel.catId.toString()}', imageModel);
        return true;
      } else if (imageModel.matId>0){
        imagesBox.put('mat${imageModel.matId.toString()}', imageModel);
        return true;
      }
    } catch(e){
      debugPrint('PrintError on PutImage: ${e.toString()}');
      return false;
    }

    return false;
  }

  Future<List<TblDkTableCategory>> getTableCategories() async {
    dynamic value = box.get(tableCategory);
    if (value == null) return [];
    List list = json.decode(value);
    List<TblDkTableCategory> tableCategories = list.map((e) => TblDkTableCategory.fromMap(e)).toList();
    return tableCategories;
  }

  Future putTableCategories(List<Map<String, dynamic>> list) async {
    String encoded = json.encode(list);
    try {
      box.put(tableCategory, encoded);
    } catch (e) {
      print('PrintError: $e');
    }
  }


  Future<List<Table>> getTables() async {
    dynamic value = box.get(table);
    if (value == null) return [];
    List list = json.decode(value);
    List<Table> tables = list.map((e) => Table.fromMap(e)).toList();
    return tables;
  }



  Future<List<TblMgSalesman>> getSalesmans() async {
    dynamic value = box.get(salesman);
    if (value == null) return [];
    List list = json.decode(value);
    List<TblMgSalesman> salesmans = list.map((e) => TblMgSalesman.fromMap(e)).toList();
    return salesmans;
  }

  Future putTables(List<Map<String, dynamic>> list) async {
    String encoded = json.encode(list);
    try {
      box.put(table, encoded);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future putSalesmans(List<Map<String, dynamic>> list) async {
    String encoded = json.encode(list);
    try {
      box.put(salesman, encoded);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<PrinterAddress>> getPrinterAddresses() async {
    try {
      dynamic value = box.get(SharedPrefKeys.printerList);
      if (value == null) return [];
      List list = jsonDecode(value);
      List<PrinterAddress> printers =
          list.map((e) => PrinterAddress.fromMap(e)).toList();
      return printers;
    } catch (e) {
      print('Hive getPrinterAddresses error: $e');
      return [];
    }
  }

  Future putPrinterAdresses(List<PrinterAddress> printers) async {
    try {
      String encoded = jsonEncode(printers.map((e) => e.toMap()).toList());
      box.put(SharedPrefKeys.printerList, encoded);
    } catch (e) {
      print('Hive putPrinterAdresses error: $e');
    }
  }

  void dispose() {
    box.close();
  }
}
