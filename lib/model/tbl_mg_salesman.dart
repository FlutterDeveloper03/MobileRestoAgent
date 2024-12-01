import 'dart:convert';

import 'package:equatable/equatable.dart';

class TblMgSalesman extends Equatable {
  final int salesmanId;
  final String salesmanName;
  final int firmId;
  final String salesmanPass;
  final String salesmanMng;
  final int salesmanWhId;
  final int saleDiscCardId;
  final int ksCardId;
  final String speCode;
  final String groupCode;
  final String securityCode;
  final String salesmanIdGuid;
  final int salesmanStatusId;

  TblMgSalesman({
    required this.salesmanId,
    required this.salesmanName,
    required this.firmId,
    required this.salesmanPass,
    required this.salesmanMng,
    required this.salesmanWhId,
    required this.saleDiscCardId,
    required this.ksCardId,
    required this.speCode,
    required this.groupCode,
    required this.securityCode,
    required this.salesmanIdGuid,
    required this.salesmanStatusId,
  });

  TblMgSalesman copyWith({
    int? salesmanId,
    String? salesmanName,
    int? firmId,
    String? salesmanPass,
    String? salesmanMng,
    int? salesmanWhId,
    int? saleDiscCardId,
    int? ksCardId,
    String? speCode,
    String? groupCode,
    String? securityCode,
    String? salesmanIdGuid,
    int? salesmanStatusId,
  }) {
    return TblMgSalesman(
      salesmanId: salesmanId ?? this.salesmanId,
      salesmanName: salesmanName ?? this.salesmanName,
      firmId: firmId ?? this.firmId,
      salesmanPass: salesmanPass ?? this.salesmanPass,
      salesmanMng: salesmanMng ?? this.salesmanMng,
      salesmanWhId: salesmanWhId ?? this.salesmanWhId,
      saleDiscCardId: saleDiscCardId ?? this.saleDiscCardId,
      ksCardId: ksCardId ?? this.ksCardId,
      speCode: speCode ?? this.speCode,
      groupCode: groupCode ?? this.groupCode,
      securityCode: securityCode ?? this.securityCode,
      salesmanIdGuid: salesmanIdGuid ?? this.salesmanIdGuid,
      salesmanStatusId: salesmanStatusId ?? this.salesmanStatusId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'salesman_id': salesmanId,
      'salesman_name': salesmanName,
      'firm_id': firmId,
      'salesman_pass': salesmanPass,
      'salesman_mng_pass': salesmanMng,
      'salesman_wh_id': salesmanWhId,
      'sale_disc_card_id': saleDiscCardId,
      'ks_card_id': ksCardId,
      'spe_code': speCode,
      'group_code': groupCode,
      'security_code': securityCode,
      'salesman_id_guid': salesmanIdGuid,
      'salesman_status_id': salesmanStatusId,
    };
  }

  factory TblMgSalesman.fromMap(Map<String, dynamic> map) {
    return TblMgSalesman(
      salesmanId: map['salesman_id'] ?? 0,
      salesmanName: map['salesman_name']?.toString() ?? 'NAN',
      firmId: map['firm_id'] ?? 0,
      salesmanPass: map['salesman_pass']?.toString() ?? '',
      salesmanMng: map['salesman_mng_pass']?.toString() ?? '',
      salesmanWhId: map['salesman_wh_id'] ?? 0,
      saleDiscCardId: map['sale_disc_card_id'] ?? 0,
      ksCardId: map['ks_card_id'] ?? 0,
      speCode: map['spe_code']?.toString() ?? '',
      groupCode: map['group_code']?.toString() ?? '',
      securityCode: map['security_code']?.toString() ?? '',
      salesmanIdGuid: map['salesman_id_guid']?.toString() ?? '',
      salesmanStatusId: map['salesman_status_id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TblMgSalesman.fromJson(String source) =>
      TblMgSalesman.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      salesmanId,
      salesmanName,
      firmId,
      salesmanPass,
      salesmanMng,
      salesmanWhId,
      saleDiscCardId,
      ksCardId,
      speCode,
      groupCode,
      securityCode,
      salesmanIdGuid,
      salesmanStatusId,
    ];
  }
}
