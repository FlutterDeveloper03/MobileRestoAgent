import 'dart:convert';
import 'package:equatable/equatable.dart';

class TblMgMatAttributes extends Equatable {
  final String mat_attribute_id;
  final String mat_attribute_name;
  final String mat_attribute_desc;
  final String mat_attribute_type_id;
  final String material_id_guid;
  final int material_id;
  final String spe_code;
  final String group_code;
  final String security_code;
  final String image_path;
  final String linked_material_code;

  TblMgMatAttributes({
    required this.mat_attribute_id,
    required this.mat_attribute_name,
    required this.mat_attribute_desc,
    required this.mat_attribute_type_id,
    required this.material_id_guid,
    required this.material_id,
    required this.spe_code,
    required this.group_code,
    required this.security_code,
    required this.image_path,
    required this.linked_material_code,
  });

  @override
  List<Object> get props {
    return [
      mat_attribute_id,
      mat_attribute_name,
      mat_attribute_desc,
      mat_attribute_type_id,
      material_id_guid,
      material_id,
      spe_code,
      group_code,
      security_code,
      image_path,
      linked_material_code
    ];
  }


  TblMgMatAttributes copyWith({
    String? mat_attribute_id,
    String? mat_attribute_name,
    String? mat_attribute_desc,
    String? mat_attribute_type_id,
    String? material_id_guid,
    int? material_id,
    String? spe_code,
    String? group_code,
    String? security_code,
    String? image_path,
    String? linked_material_code
  }) {
    return TblMgMatAttributes(
        mat_attribute_id: mat_attribute_id ?? this.mat_attribute_id,
        mat_attribute_name: mat_attribute_name ?? this.mat_attribute_name,
        mat_attribute_desc: mat_attribute_desc ?? this.mat_attribute_desc,
        mat_attribute_type_id: mat_attribute_type_id ?? this.mat_attribute_type_id,
        material_id_guid: material_id_guid ?? this.material_id_guid,
        material_id: material_id ?? this.material_id,
        spe_code: spe_code ?? this.spe_code,
        group_code: group_code ?? this.group_code,
        security_code: security_code ?? this.security_code,
        image_path: image_path ?? this.image_path,
        linked_material_code: linked_material_code ?? this.linked_material_code
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mat_attribute_id':mat_attribute_id,
      'mat_attribute_name':mat_attribute_name,
      'mat_attribute_desc':mat_attribute_desc,
      'mat_attribute_type_id':mat_attribute_type_id,
      'material_id_guid':material_id_guid,
      'material_id':material_id,
      'spe_code':spe_code,
      'group_code':group_code,
      'security_code':security_code,
      'image_path':image_path,
      'linked_material_code':linked_material_code,
    };
  }

  factory TblMgMatAttributes.fromMap(Map<String, dynamic> map) {
    return TblMgMatAttributes(
        mat_attribute_id: map['mat_attribute_id'] ?? 0,
        mat_attribute_name: map['mat_attribute_name']?.toString() ?? '',
        mat_attribute_desc: map['mat_attribute_desc']?.toString() ?? '',
        mat_attribute_type_id: map['mat_attribute_type_id']?.toString() ?? '',
        material_id_guid: map['material_id_guid']?.toString() ?? '',
        material_id: int.parse(map['material_id'] ?? 0),
        spe_code: map['spe_code']?.toString() ?? '',
        group_code: map['group_code']?.toString() ?? '',
        security_code: map['security_code']?.toString() ?? '',
        image_path: map['image_path']?.toString() ?? '',
        linked_material_code: map['linked_material_code']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TblMgMatAttributes.fromJson(String source) =>
      TblMgMatAttributes.fromMap(json.decode(source));

  @override
  String toString() {
    return '''
    TblMgMatAttributes(
      mat_attribute_id:$mat_attribute_id,
      mat_attribute_name:$mat_attribute_name,
      mat_attribute_desc:$mat_attribute_desc,
      mat_attribute_type_id:$mat_attribute_type_id,
      material_id_guid:$material_id_guid,
      material_id:$material_id,
      spe_code:$spe_code,
      group_code:$group_code,
      security_code:$security_code,
      image_path:$image_path,
      linked_material_code:$linked_material_code,
    )''';
  }
}
