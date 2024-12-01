import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/model/tbl_mg_mat_attributes.dart';

class TblMgMaterials extends Equatable {
  final int id;
  final String materialCode;
  final String materialName;
  final String barBarcode;
  final double salePrice;
  final double matAutoPrice;
  final Uint8List imagePict;
  final String groupCode;
  final int catId;
  final String securityCode;
  final String securityName;
  final String matNameLang1;
  final String matNameLang2;
  final String matNameLang3;
  final String descLang1;
  final String descLang2;
  final String descLang3;
  final int aStatusId;
  final List<TblMgMatAttributes> matAttributes;

  TblMgMaterials({
    required this.id,
    required this.materialCode,
    required this.materialName,
    required this.barBarcode,
    required this.salePrice,
    required this.matAutoPrice,
    required this.imagePict,
    required this.groupCode,
    required this.catId,
    required this.securityCode,
    required this.securityName,
    required this.matNameLang1,
    required this.matNameLang2,
    required this.matNameLang3,
    required this.descLang1,
    required this.descLang2,
    required this.descLang3,
    required this.aStatusId,
    required this.matAttributes
  });

  @override
  List<Object> get props {
    return [
      id,
      materialCode,
      materialName,
      barBarcode,
      salePrice,
      matAutoPrice,
      imagePict,
      groupCode,
      catId,
      securityCode,
      securityName,
      matNameLang1,
      matNameLang2,
      matNameLang3,
      descLang1,
      descLang2,
      descLang3,
      aStatusId,
      matAttributes
    ];
  }

  String name(AppLocalizations locale) {
    if (locale.locale.languageCode == 'tk' && this.matNameLang1.isNotEmpty) {
      return this.matNameLang1;
    } else if (locale.locale.languageCode == 'ru' &&
        this.matNameLang2.isNotEmpty) {
      return this.matNameLang2;
    } else if (locale.locale.languageCode == 'en' &&
        this.matNameLang3.isNotEmpty) {
      return this.matNameLang3;
    }
    return this.materialName;
  }

  String desc(AppLocalizations locale) {
    if (locale.locale.languageCode == 'tk' && this.descLang1.isNotEmpty) {
      return this.descLang1;
    } else if (locale.locale.languageCode == 'ru' &&
        this.descLang2.isNotEmpty) {
      return this.descLang2;
    } else if (locale.locale.languageCode == 'en' &&
        this.descLang3.isNotEmpty) {
      return this.descLang3;
    }
    return this.descLang1;
  }

  TblMgMaterials copyWith({
    int? id,
    String? materialCode,
    String? materialName,
    String? barBarcode,
    double? salePrice,
    double? matAutoPrice,
    Uint8List? imagePict,
    String? groupCode,
    int? catId,
    String? securityCode,
    String? securityName,
    String? matNameLang1,
    String? matNameLang2,
    String? matNameLang3,
    String? descLang1,
    String? descLang2,
    String? descLang3,
    int? aStatusId,
    List<TblMgMatAttributes>? matAttributes
  }) {
    return TblMgMaterials(
        id: id ?? this.id,
        materialCode: materialCode ?? this.materialCode,
        materialName: materialName ?? this.materialName,
        barBarcode: barBarcode ?? this.barBarcode,
        salePrice: salePrice ?? this.salePrice,
        matAutoPrice: matAutoPrice ?? this.matAutoPrice,
        imagePict: imagePict ?? this.imagePict,
        groupCode: groupCode ?? this.groupCode,
        catId: catId ?? this.catId,
        securityCode: securityCode ?? this.securityCode,
        securityName: securityName ?? this.securityName,
        matNameLang1: matNameLang1 ?? this.matNameLang1,
        matNameLang2: matNameLang2 ?? this.matNameLang2,
        matNameLang3: matNameLang3 ?? this.matNameLang3,
        descLang1: descLang1 ?? this.descLang1,
        descLang2: descLang2 ?? this.descLang2,
        descLang3: descLang3 ?? this.descLang3,
        aStatusId: aStatusId ?? this.aStatusId,
        matAttributes: matAttributes ?? this.matAttributes
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'material_id': id,
      'material_code': materialCode,
      'material_name': materialName,
      'bar_barcode': barBarcode,
      'price_value': salePrice.toString(),
      'mat_auto_price': matAutoPrice,
      'image_pict': base64.encode(imagePict),
      'group_code': groupCode,
      'cat_id': catId,
      'security_code': securityCode,
      'security_code_name': securityName,
      'mat_name_lang1': matNameLang1,
      'mat_name_lang2': matNameLang2,
      'mat_name_lang3': matNameLang3,
      'spe_code2': descLang1,
      'spe_code3': descLang2,
      'spe_code4': descLang3,
      'a_status_id': aStatusId,
      'matAttributes': (matAttributes.isNotEmpty) ? matAttributes.map((e) => e.toMap()).toList() : []
    };
  }

  factory TblMgMaterials.fromMap(Map<String, dynamic> map) {
    String image = map['image_pict'] ?? '';
    return TblMgMaterials(
        id: map['material_id'] ?? 0,
        materialCode: map['material_code'] ?? '',
        materialName: map['material_name'] ?? '',
        barBarcode: map['bar_barcode'] ?? '',
        salePrice: double.tryParse(map['price_value']?.toString() ?? "0.0") ?? 0.0,
        matAutoPrice: double.tryParse(map['mat_auto_price']?.toString() ?? "0.0") ?? 0.0,
        imagePict: image.isNotEmpty ? base64Decode(image) : Uint8List(0),
        groupCode: map['group_code'] ?? '0',
        catId: map['cat_id'] ?? 0,
        securityCode: map['security_code'] ?? '',
        securityName: map['security_code_name'] ?? '',
        matNameLang1: map['mat_name_lang1'] ?? '',
        matNameLang2: map['mat_name_lang2'] ?? '',
        matNameLang3: map['mat_name_lang3'] ?? '',
        descLang1: map['spe_code2'] ?? '',
        descLang2: map['spe_code3'] ?? '',
        descLang3: map['spe_code4'] ?? '',
        aStatusId: map['a_status_id'] ?? '',
        matAttributes: ((map['mat_attributes'] ?? '') is String)
            ? ((((map['mat_attributes'] ?? '') as String).isNotEmpty) ? (jsonDecode(((map['mat_attributes'] ?? '') as String)) as List).map((
            i) => TblMgMatAttributes.fromMap(i)).toList() : [])
            : ((map['mat_attributes'] ?? []) is List) ? (map['mat_attributes'] as List).map((i) => TblMgMatAttributes.fromMap(i)).toList() : []
    );
  }

  String toJson() => json.encode(toMap());

  factory TblMgMaterials.fromJson(String source) =>
      TblMgMaterials.fromMap(json.decode(source));

  @override
  String toString() {
    return '''
    TblMgMaterials(
      id: $id, 
      materialCode: $materialCode, 
      materialName: $materialName, 
      barBarcode: $barBarcode, 
      salePrice: $salePrice,
      matAutoPrice: $matAutoPrice,
      imagePict length: ${imagePict.length}, 
      groupCode: $groupCode, 
      catId: $catId,
      securityCode: $securityCode,
      securityName: $securityName,
      matNameLang1: $matNameLang1, 
      matNameLang2: $matNameLang2, 
      matNameLang3: $matNameLang3, 
      descLang1: $descLang1,
      descLang2: $descLang2,
      descLang3: $descLang3,
      aStatusId: $aStatusId,
    )''';
  }
}
