import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';

class TblMgCategory extends Equatable {
  final int catId;
  final String catName;
  final String catNameTm;
  final String catNameRu;
  final String catNameEn;
  final int catOrder;
  final Uint8List catImage;
  TblMgCategory({
    required this.catId,
    required this.catName,
    required this.catNameTm,
    required this.catNameRu,
    required this.catNameEn,
    required this.catOrder,
    required this.catImage,
  });
  @override
  List<Object> get props {
    return [
      catId,
      catName,
      catNameTm,
      catNameRu,
      catNameEn,
      catOrder,
      catImage,
    ];
  }

  String name(AppLocalizations locale) {
    if (locale.locale.languageCode == 'tk') {
      return this.catNameTm;
    } else if (locale.locale.languageCode == 'ru') {
      return this.catNameRu;
    } else if (locale.locale.languageCode == 'en') {
      return this.catNameEn;
    }
    return this.catName;
  }

  TblMgCategory copyWith({
    int? catId,
    String? catName,
    String? catNameTm,
    String? catNameRu,
    String? catNameEn,
    int? catOrder,
    Uint8List? catImage,
  }) {
    return TblMgCategory(
      catId: catId ?? this.catId,
      catName: catName ?? this.catName,
      catNameTm: catNameTm ?? this.catNameTm,
      catNameRu: catNameRu ?? this.catNameRu,
      catNameEn: catNameEn ?? this.catNameEn,
      catOrder: catOrder ?? this.catOrder,
      catImage: catImage ?? this.catImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cat_id': catId,
      'cat_name': catName,
      'cat_name_tm': catNameTm,
      'cat_name_ru': catNameRu,
      'cat_name_en': catNameEn,
      'cat_order': catOrder,
      'cat_image': base64Encode(catImage),
    };
  }

  factory TblMgCategory.fromMap(Map<String, dynamic> map) {
    return TblMgCategory(
      catId: map['cat_id'] ?? 0,
      catName: map['cat_name'] ?? '',
      catNameTm: map['cat_name_tm'] ?? '',
      catNameRu: map['cat_name_ru'] ?? '',
      catNameEn: map['cat_name_en'] ?? '',
      catOrder: map['cat_order'] ?? 0,
      catImage: base64Decode(map['cat_image'] ?? ''),
    );
  }

  String toJson() => json.encode(toMap());

  factory TblMgCategory.fromJson(dynamic source) =>
      TblMgCategory.fromMap(source);

  @override
  bool get stringify => true;
}
