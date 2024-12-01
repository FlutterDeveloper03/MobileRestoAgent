import 'dart:convert';

import 'package:equatable/equatable.dart';

class Table extends Equatable {
  final int arapId;
  final int fichId;
  final String fichCode;
  final String tableName;
  final double fichTotal;
  final double fichNetTotal;
  final String speCode;
  final String groupCode;
  final String securityCode;
  final String invDesc;
  final String salesmanName;

  Table(
      {required this.arapId,
      required this.fichId,
      required this.fichCode,
      required this.tableName,
      required this.fichTotal,
      required this.fichNetTotal,
      required this.speCode,
      required this.groupCode,
      required this.securityCode,
      required this.invDesc,
      required this.salesmanName});

  @override
  List<Object> get props {
    return [
      arapId,
      fichId,
      fichCode,
      tableName,
      fichTotal,
      fichNetTotal,
      speCode,
      groupCode,
      securityCode,
      invDesc,
      salesmanName,
    ];
  }

  Table copyWith({
    int? arapId,
    int? fichId,
    String? fichCode,
    String? tableName,
    double? fichTotal,
    double? fichNetTotal,
    String? speCode,
    String? groupCode,
    String? securityCode,
    String? invDesc,
    String? salesmanName,
  }) {
    return Table(
      arapId: arapId ?? this.arapId,
      fichId: fichId ?? this.fichId,
      fichCode: fichCode ?? this.fichCode,
      tableName: tableName ?? this.tableName,
      fichTotal: fichTotal ?? this.fichTotal,
      fichNetTotal: fichNetTotal ?? this.fichNetTotal,
      speCode: speCode ?? this.speCode,
      groupCode: groupCode ?? this.groupCode,
      securityCode: securityCode ?? this.securityCode,
      invDesc: invDesc ?? this.invDesc,
      salesmanName: salesmanName ?? this.salesmanName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'arap_id': arapId,
      'fich_id': fichId,
      'fich_code': fichCode,
      'sale_disc_card_name': tableName,
      'fich_total': fichTotal.toString(),
      'fich_nettotal': fichNetTotal.toString(),
      'speCode': speCode.toString(),
      'groupCode': groupCode.toString(),
      'securityCode': securityCode.toString(),
      'invDesc': invDesc.toString(),
      'salesmanName': salesmanName.toString(),
    };
  }

  factory Table.fromMap(Map<String, dynamic> map) {
    // print('map: $map');
    return Table(
      arapId: map['arap_id'] ?? 0,
      fichId: map['fich_id'] ?? 0,
      fichCode: map['fich_code'] ?? '',
      tableName: map['sale_disc_card_name'] ?? '',
      fichTotal: double.tryParse(map['fich_total']?.toString() ?? "0.0") ?? 0.0,
      fichNetTotal: double.tryParse(map['fich_nettotal']?.toString() ?? "0.0") ?? 0.0,
      speCode: map['spe_code']?.toString() ?? '',
      groupCode: map['f_group_code']?.toString() ?? '',
      securityCode: map['security_code']?.toString() ?? '',
      invDesc: map['fich_desc']?.toString() ?? '',
      salesmanName: map['salesman_name']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Table.fromJson(String source) => Table.fromMap(json.decode(source));

  @override
  String toString() =>
      'TblMgArap(arapId: $arapId, fichId: $fichId, fichCode: $fichCode, arapName: $tableName, balance: $fichTotal, speCode:$speCode, '
          'groupCode:$groupCode, securityCode:$securityCode, invDesc: $invDesc, salesmanName: $salesmanName)';
}
