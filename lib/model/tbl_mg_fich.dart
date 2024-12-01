import 'dart:convert';

import 'package:equatable/equatable.dart';

class TblMgFich extends Equatable {
  final int fichId;
  final String fichCode;
  final DateTime fichDate;
  final double fichTotal;
  final DateTime fichCreateDate;
  final int fichTypeId;
  final int arapId;
  final int divId;
  final int deptId;
  final int plantId;
  final int whId;
  final int pId;
  final int invId;
  final String fichDesc;
  final double fichDiscount;
  final double fichNettotal;
  final int salesmanId;
  final int tId;
  final String speCode;
  final String groupCode;
  final String securityCode;
  final int payplanId;
  final double repRate;
  final double repTotal;
  final String fichIdGuid;
  TblMgFich({
    required this.fichId,
    required this.fichCode,
    required this.fichDate,
    required this.fichTotal,
    required this.fichCreateDate,
    required this.fichTypeId,
    required this.arapId,
    required this.divId,
    required this.deptId,
    required this.plantId,
    required this.whId,
    required this.pId,
    required this.invId,
    required this.fichDesc,
    required this.fichDiscount,
    required this.fichNettotal,
    required this.salesmanId,
    required this.tId,
    required this.speCode,
    required this.groupCode,
    required this.securityCode,
    required this.payplanId,
    required this.repRate,
    required this.repTotal,
    required this.fichIdGuid,
  });

  @override
  List<Object> get props {
    return [
      fichId,
      fichCode,
      fichDate,
      fichTotal,
      fichCreateDate,
      fichTypeId,
      arapId,
      divId,
      deptId,
      plantId,
      whId,
      pId,
      invId,
      fichDesc,
      fichDiscount,
      fichNettotal,
      salesmanId,
      tId,
      speCode,
      groupCode,
      securityCode,
      payplanId,
      repRate,
      repTotal,
      fichIdGuid,
    ];
  }

  TblMgFich copyWith({
    int? fichId,
    String? fichCode,
    DateTime? fichDate,
    double? fichTotal,
    DateTime? fichCreateDate,
    int? fichTypeId,
    int? arapId,
    int? divId,
    int? deptId,
    int? plantId,
    int? whId,
    int? pId,
    int? invId,
    String? fichDesc,
    double? fichDiscount,
    double? fichNettotal,
    int? salesmanId,
    int? tId,
    String? speCode,
    String? groupCode,
    String? securityCode,
    int? payplanId,
    double? repRate,
    double? repTotal,
    String? fichIdGuid,
  }) {
    return TblMgFich(
      fichId: fichId ?? this.fichId,
      fichCode: fichCode ?? this.fichCode,
      fichDate: fichDate ?? this.fichDate,
      fichTotal: fichTotal ?? this.fichTotal,
      fichCreateDate: fichCreateDate ?? this.fichCreateDate,
      fichTypeId: fichTypeId ?? this.fichTypeId,
      arapId: arapId ?? this.arapId,
      divId: divId ?? this.divId,
      deptId: deptId ?? this.deptId,
      plantId: plantId ?? this.plantId,
      whId: whId ?? this.whId,
      pId: pId ?? this.pId,
      invId: invId ?? this.invId,
      fichDesc: fichDesc ?? this.fichDesc,
      fichDiscount: fichDiscount ?? this.fichDiscount,
      fichNettotal: fichNettotal ?? this.fichNettotal,
      salesmanId: salesmanId ?? this.salesmanId,
      tId: tId ?? this.tId,
      speCode: speCode ?? this.speCode,
      groupCode: groupCode ?? this.groupCode,
      securityCode: securityCode ?? this.securityCode,
      payplanId: payplanId ?? this.payplanId,
      repRate: repRate ?? this.repRate,
      repTotal: repTotal ?? this.repTotal,
      fichIdGuid: fichIdGuid ?? this.fichIdGuid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fich_id': fichId,
      'fich_code': fichCode,
      'fich_date': fichDate.millisecondsSinceEpoch,
      'fich_total': fichTotal,
      'fich_create_date': fichCreateDate.millisecondsSinceEpoch,
      'fich_type_id': fichTypeId,
      'arap_id': arapId,
      'div_id': divId,
      'dept_id': deptId,
      'plant_id': plantId,
      'wh_id': whId,
      'p_id': pId,
      'inv_id': invId,
      'fich_desc': fichDesc,
      'fich_discount': fichDiscount,
      'fich_nettotal': fichNettotal,
      'salesman_id': salesmanId,
      'T_ID': tId,
      'spe_code': speCode,
      'group_code': groupCode,
      'security_code': securityCode,
      'payplan_id': payplanId,
      'rep_rate': repRate,
      'rep_total': repTotal,
      'fich_id_guid': fichIdGuid,
    };
  }

  factory TblMgFich.fromMap(Map<String, dynamic> map) {
    return TblMgFich(
      fichId: map['fich_id'],
      fichCode: map['fich_code'],
      fichDate: DateTime.fromMillisecondsSinceEpoch(map['fich_date']),
      fichTotal: map['fich_total'],
      fichCreateDate:
          DateTime.fromMillisecondsSinceEpoch(map['fich_create_date']),
      fichTypeId: map['fich_type_id'],
      arapId: map['arap_id'],
      divId: map['div_id'],
      deptId: map['dept_id'],
      plantId: map['plant_id'],
      whId: map['wh_id'],
      pId: map['p_id'],
      invId: map['inv_id'],
      fichDesc: map['fich_desc'],
      fichDiscount: map['fich_discount'],
      fichNettotal: map['fich_nettotal'],
      salesmanId: map['salesman_id'],
      tId: map['T_ID'],
      speCode: map['spe_code'],
      groupCode: map['group_code'],
      securityCode: map['security_code'],
      payplanId: map['payplan_id'],
      repRate: map['rep_rate'],
      repTotal: map['rep_total'],
      fichIdGuid: map['fich_id_guid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TblMgFich.fromJson(String source) =>
      TblMgFich.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TblMgFich(fichId: $fichId, fichCode: $fichCode, fichDate: $fichDate, fichTotal: $fichTotal, fichCreateDate: $fichCreateDate, fichTypeId: $fichTypeId, arapId: $arapId, divId: $divId, deptId: $deptId, plantId: $plantId, whId: $whId, pId: $pId, invId: $invId, fichDesc: $fichDesc, fichDiscount: $fichDiscount, fichNettotal: $fichNettotal, salesmanId: $salesmanId, tId: $tId, speCode: $speCode, groupCode: $groupCode, securityCode: $securityCode, payplanId: $payplanId, repRate: $repRate, repTotal: $repTotal, fichIdGuid: $fichIdGuid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TblMgFich &&
        other.fichId == fichId &&
        other.fichCode == fichCode &&
        other.fichDate == fichDate &&
        other.fichTotal == fichTotal &&
        other.fichCreateDate == fichCreateDate &&
        other.fichTypeId == fichTypeId &&
        other.arapId == arapId &&
        other.divId == divId &&
        other.deptId == deptId &&
        other.plantId == plantId &&
        other.whId == whId &&
        other.pId == pId &&
        other.invId == invId &&
        other.fichDesc == fichDesc &&
        other.fichDiscount == fichDiscount &&
        other.fichNettotal == fichNettotal &&
        other.salesmanId == salesmanId &&
        other.tId == tId &&
        other.speCode == speCode &&
        other.groupCode == groupCode &&
        other.securityCode == securityCode &&
        other.payplanId == payplanId &&
        other.repRate == repRate &&
        other.repTotal == repTotal &&
        other.fichIdGuid == fichIdGuid;
  }

  @override
  int get hashCode {
    return fichId.hashCode ^
        fichCode.hashCode ^
        fichDate.hashCode ^
        fichTotal.hashCode ^
        fichCreateDate.hashCode ^
        fichTypeId.hashCode ^
        arapId.hashCode ^
        divId.hashCode ^
        deptId.hashCode ^
        plantId.hashCode ^
        whId.hashCode ^
        pId.hashCode ^
        invId.hashCode ^
        fichDesc.hashCode ^
        fichDiscount.hashCode ^
        fichNettotal.hashCode ^
        salesmanId.hashCode ^
        tId.hashCode ^
        speCode.hashCode ^
        groupCode.hashCode ^
        securityCode.hashCode ^
        payplanId.hashCode ^
        repRate.hashCode ^
        repTotal.hashCode ^
        fichIdGuid.hashCode;
  }
}
