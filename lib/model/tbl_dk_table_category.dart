import 'dart:convert';
import 'package:equatable/equatable.dart';

class TblDkTableCategory extends Equatable {
  final int tableCatId;
  final String tableCatName;
  TblDkTableCategory({
    required this.tableCatId,
    required this.tableCatName,
  });
  @override
  List<Object> get props {
    return [
      tableCatId,
      tableCatName
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'tableCatId': tableCatId,
      'tableCatName': tableCatName,
    };
  }

  factory TblDkTableCategory.fromMap(Map<String, dynamic> map) {
    return TblDkTableCategory(
      tableCatId: map['tableCatId'] ?? 0,
      tableCatName: map['group_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TblDkTableCategory.fromJson(dynamic source) =>
      TblDkTableCategory.fromMap(source);

}
