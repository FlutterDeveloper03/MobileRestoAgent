import 'dart:convert';

class TblMgOrderFichLine {
  final int fichLineId;
  final double fichLineAmount;
  final double fichLinePrice;
  final double fichLineTotal;
  final int invId;
  final int fichId;
  final int materialId;
  final String fichLineDesc;
  final int unitDetId;
  final double fichLineDiscPrc;
  final double fichLineDiscAmount;
  final double fichLineNettotal;
  final DateTime fichLineDate;
  final int serviceId;
  final DateTime fichLineExpiredate;
  final String fichLineSerialno;
  final int matInvLineId;
  final double repRate;
  final double repTotal;
  final int fichLineTypeId;
  final String speCode;
  final String groupCode;
  final String securityCode;
  final String fichLineIdGuid;
  final String fichIdGuid;
  TblMgOrderFichLine({
    required this.fichLineId,
    required this.fichLineAmount,
    required this.fichLinePrice,
    required this.fichLineTotal,
    required this.invId,
    required this.fichId,
    required this.materialId,
    required this.fichLineDesc,
    required this.unitDetId,
    required this.fichLineDiscPrc,
    required this.fichLineDiscAmount,
    required this.fichLineNettotal,
    required this.fichLineDate,
    required this.serviceId,
    required this.fichLineExpiredate,
    required this.fichLineSerialno,
    required this.matInvLineId,
    required this.repRate,
    required this.repTotal,
    required this.fichLineTypeId,
    required this.speCode,
    required this.groupCode,
    required this.securityCode,
    required this.fichLineIdGuid,
    required this.fichIdGuid,
  });

  TblMgOrderFichLine copyWith({
    int? fichLineId,
    double? fichLineAmount,
    double? fichLinePrice,
    double? fichLineTotal,
    int? invId,
    int? fichId,
    int? materialId,
    String? fichLineDesc,
    int? unitDetId,
    double? fichLineDiscPrc,
    double? fichLineDiscAmount,
    double? fichLineNettotal,
    DateTime? fichLineDate,
    int? serviceId,
    DateTime? fichLineExpiredate,
    String? fichLineSerialno,
    int? matInvLineId,
    double? repRate,
    double? repTotal,
    int? fichLineTypeId,
    String? speCode,
    String? groupCode,
    String? securityCode,
    String? fichLineIdGuid,
    String? fichIdGuid,
  }) {
    return TblMgOrderFichLine(
      fichLineId: fichLineId ?? this.fichLineId,
      fichLineAmount: fichLineAmount ?? this.fichLineAmount,
      fichLinePrice: fichLinePrice ?? this.fichLinePrice,
      fichLineTotal: fichLineTotal ?? this.fichLineTotal,
      invId: invId ?? this.invId,
      fichId: fichId ?? this.fichId,
      materialId: materialId ?? this.materialId,
      fichLineDesc: fichLineDesc ?? this.fichLineDesc,
      unitDetId: unitDetId ?? this.unitDetId,
      fichLineDiscPrc: fichLineDiscPrc ?? this.fichLineDiscPrc,
      fichLineDiscAmount: fichLineDiscAmount ?? this.fichLineDiscAmount,
      fichLineNettotal: fichLineNettotal ?? this.fichLineNettotal,
      fichLineDate: fichLineDate ?? this.fichLineDate,
      serviceId: serviceId ?? this.serviceId,
      fichLineExpiredate: fichLineExpiredate ?? this.fichLineExpiredate,
      fichLineSerialno: fichLineSerialno ?? this.fichLineSerialno,
      matInvLineId: matInvLineId ?? this.matInvLineId,
      repRate: repRate ?? this.repRate,
      repTotal: repTotal ?? this.repTotal,
      fichLineTypeId: fichLineTypeId ?? this.fichLineTypeId,
      speCode: speCode ?? this.speCode,
      groupCode: groupCode ?? this.groupCode,
      securityCode: securityCode ?? this.securityCode,
      fichLineIdGuid: fichLineIdGuid ?? this.fichLineIdGuid,
      fichIdGuid: fichIdGuid ?? this.fichIdGuid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fich_line_id': fichLineId,
      'fich_line_amount': fichLineAmount,
      'fich_line_price': fichLinePrice,
      'fich_line_total': fichLineTotal,
      'inv_id': invId,
      'fich_id': fichId,
      'material_id': materialId,
      'fich_line_desc': fichLineDesc,
      'unit_det_id': unitDetId,
      'fich_line_disc_prc': fichLineDiscPrc,
      'fich_line_disc_amount': fichLineDiscAmount,
      'fich_line_nettotal': fichLineNettotal,
      'fich_line_date': fichLineDate.millisecondsSinceEpoch,
      'service_id': serviceId,
      'fich_line_expiredate': fichLineExpiredate.millisecondsSinceEpoch,
      'fich_line_serialno': fichLineSerialno,
      'mat_inv_line_id': matInvLineId,
      'rep_rate': repRate,
      'rep_total': repTotal,
      'fich_line_type_id': fichLineTypeId,
      'spe_code': speCode,
      'group_code': groupCode,
      'security_code': securityCode,
      'fich_line_id_guid': fichLineIdGuid,
      'fich_id_guid': fichIdGuid,
    };
  }

  factory TblMgOrderFichLine.fromMap(Map<String, dynamic> map) {
    return TblMgOrderFichLine(
      fichLineId: map['fich_line_id'],
      fichLineAmount: map['fich_line_amount'],
      fichLinePrice: map['fich_line_price'],
      fichLineTotal: map['fich_line_total'],
      invId: map['inv_id'],
      fichId: map['fich_id'],
      materialId: map['material_id'],
      fichLineDesc: map['fich_line_desc'],
      unitDetId: map['unit_det_id'],
      fichLineDiscPrc: map['fich_line_disc_prc'],
      fichLineDiscAmount: map['fich_line_disc_amount'],
      fichLineNettotal: map['fich_line_nettotal'],
      fichLineDate: DateTime.fromMillisecondsSinceEpoch(map['fich_line_date']),
      serviceId: map['service_id'],
      fichLineExpiredate:
          DateTime.fromMillisecondsSinceEpoch(map['fich_line_expiredate']),
      fichLineSerialno: map['fich_line_serialno'],
      matInvLineId: map['mat_inv_line_id'],
      repRate: map['rep_rate'],
      repTotal: map['rep_total'],
      fichLineTypeId: map['fich_line_type_id'],
      speCode: map['spe_code'],
      groupCode: map['group_code'],
      securityCode: map['security_code'],
      fichLineIdGuid: map['fich_line_id_guid'],
      fichIdGuid: map['fich_id_guid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TblMgOrderFichLine.fromJson(String source) =>
      TblMgOrderFichLine.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TblMgOrderFichLine(fichLineId: $fichLineId, fichLineAmount: $fichLineAmount, fichLinePrice: $fichLinePrice, fichLineTotal: $fichLineTotal, invId: $invId, fichId: $fichId, materialId: $materialId, fichLineDesc: $fichLineDesc, unitDetId: $unitDetId, fichLineDiscPrc: $fichLineDiscPrc, fichLineDiscAmount: $fichLineDiscAmount, fichLineNettotal: $fichLineNettotal, fichLineDate: $fichLineDate, serviceId: $serviceId, fichLineExpiredate: $fichLineExpiredate, fichLineSerialno: $fichLineSerialno, matInvLineId: $matInvLineId, repRate: $repRate, repTotal: $repTotal, fichLineTypeId: $fichLineTypeId, speCode: $speCode, groupCode: $groupCode, securityCode: $securityCode, fichLineIdGuid: $fichLineIdGuid, fichIdGuid: $fichIdGuid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TblMgOrderFichLine &&
        other.fichLineId == fichLineId &&
        other.fichLineAmount == fichLineAmount &&
        other.fichLinePrice == fichLinePrice &&
        other.fichLineTotal == fichLineTotal &&
        other.invId == invId &&
        other.fichId == fichId &&
        other.materialId == materialId &&
        other.fichLineDesc == fichLineDesc &&
        other.unitDetId == unitDetId &&
        other.fichLineDiscPrc == fichLineDiscPrc &&
        other.fichLineDiscAmount == fichLineDiscAmount &&
        other.fichLineNettotal == fichLineNettotal &&
        other.fichLineDate == fichLineDate &&
        other.serviceId == serviceId &&
        other.fichLineExpiredate == fichLineExpiredate &&
        other.fichLineSerialno == fichLineSerialno &&
        other.matInvLineId == matInvLineId &&
        other.repRate == repRate &&
        other.repTotal == repTotal &&
        other.fichLineTypeId == fichLineTypeId &&
        other.speCode == speCode &&
        other.groupCode == groupCode &&
        other.securityCode == securityCode &&
        other.fichLineIdGuid == fichLineIdGuid &&
        other.fichIdGuid == fichIdGuid;
  }

  @override
  int get hashCode {
    return fichLineId.hashCode ^
        fichLineAmount.hashCode ^
        fichLinePrice.hashCode ^
        fichLineTotal.hashCode ^
        invId.hashCode ^
        fichId.hashCode ^
        materialId.hashCode ^
        fichLineDesc.hashCode ^
        unitDetId.hashCode ^
        fichLineDiscPrc.hashCode ^
        fichLineDiscAmount.hashCode ^
        fichLineNettotal.hashCode ^
        fichLineDate.hashCode ^
        serviceId.hashCode ^
        fichLineExpiredate.hashCode ^
        fichLineSerialno.hashCode ^
        matInvLineId.hashCode ^
        repRate.hashCode ^
        repTotal.hashCode ^
        fichLineTypeId.hashCode ^
        speCode.hashCode ^
        groupCode.hashCode ^
        securityCode.hashCode ^
        fichLineIdGuid.hashCode ^
        fichIdGuid.hashCode;
  }
}
