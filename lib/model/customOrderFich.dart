import 'dart:convert';

import 'package:equatable/equatable.dart';

class CustomOrderFich extends Equatable {
  final int fichId;
  final String fichCode;
  final double fichTotal;
  final double fichNettotal;
  final double fichDiscount;
  final int arapId;
  final int invId;
  CustomOrderFich({
    required this.fichId,
    required this.fichCode,
    required this.fichTotal,
    required this.fichNettotal,
    required this.fichDiscount,
    required this.arapId,
    required this.invId,
  });
  @override
  List<Object> get props {
    return [
      fichId,
      fichCode,
      fichTotal,
      fichNettotal,
      fichDiscount,
      arapId,
      invId,
    ];
  }

  CustomOrderFich copyWith({
    int? fichId,
    String? fichCode,
    double? fichTotal,
    double? fichNettotal,
    double? fichDiscount,
    int? arapId,
    int? invId,
  }) {
    return CustomOrderFich(
      fichId: fichId ?? this.fichId,
      fichCode: fichCode ?? this.fichCode,
      fichTotal: fichTotal ?? this.fichTotal,
      fichNettotal: fichNettotal ?? this.fichNettotal,
      fichDiscount: fichDiscount ?? this.fichDiscount,
      arapId: arapId ?? this.arapId,
      invId: invId ?? this.invId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fich_id': fichId,
      'fich_code': fichCode,
      'fich_total': fichTotal,
      'fich_nettotal': fichNettotal,
      'fich_discount': fichDiscount,
      'arap_id': arapId,
      'inv_id': invId,
    };
  }

  factory CustomOrderFich.fromMap(Map<String, dynamic> map) {
    return CustomOrderFich(
      fichId: map['fich_id'],
      fichCode: map['fich_code'],
      fichTotal: map['fich_total'],
      fichNettotal: map['fich_nettotal'],
      fichDiscount: map['fich_discount'],
      arapId: map['arap_id'],
      invId: map['inv_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomOrderFich.fromJson(String source) =>
      CustomOrderFich.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
