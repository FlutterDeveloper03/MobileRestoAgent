import 'package:equatable/equatable.dart';
import 'package:mobile_resto_agent/model/tbl_mg_mat_attributes.dart';
import 'package:mobile_resto_agent/model/tbl_mg_materials.dart';

class CartItem extends Equatable {
  final TblMgMaterials material;
  final String fich_line_desc;
  final List<TblMgMatAttributes> matAttributes;
  final double count;
  CartItem({
    required this.material,
    required this.fich_line_desc,
    required this.matAttributes,
    required this.count,
  });

  List<Object> get props => [material,fich_line_desc,matAttributes, count];

  Map<String, dynamic> toMap() {
    return {
      'tbl_mg_materials': this.material.toMap(),
      'fich_line_desc':this.fich_line_desc,
      'mat_attributes':this.matAttributes,
      'count': this.count,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      material: TblMgMaterials.fromMap(map['tbl_mg_materials']),
      fich_line_desc: map['fich_line_desc'],
      matAttributes: map['mat_attributes'],
      count: map['count'],
    );
  }


  CartItem copyWith({
    TblMgMaterials? material,
    String? fich_line_desc,
    List<TblMgMatAttributes>? matAttributes,
    double? count
  }) {
    return CartItem(
      matAttributes: matAttributes ?? this.matAttributes,
      count: count ?? this.count,
      fich_line_desc: fich_line_desc ?? this.fich_line_desc,
      material: material ?? this.material
    );
  }
}
