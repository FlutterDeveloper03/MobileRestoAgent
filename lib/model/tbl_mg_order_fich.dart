import 'dart:convert';

import 'package:equatable/equatable.dart';

class TblMgOrderFich extends Equatable {
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
  final int ordStatusId;
  final double repRate;
  final double repTotal;
  final DateTime fichModifyDate;
  final double fichTotalUnitAmount;
  final int fichModified;
  final int bankAccIdClient;
  final int bankAccIdLocal;
  final int deliveryArapId;
  final DateTime syncDatetime;
  final double orderLat;
  final double orderLong;
  final String fichNettotalText;
  final String fichIdGuid;
  TblMgOrderFich({
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
    required this.ordStatusId,
    required this.repRate,
    required this.repTotal,
    required this.fichModifyDate,
    required this.fichTotalUnitAmount,
    required this.fichModified,
    required this.bankAccIdClient,
    required this.bankAccIdLocal,
    required this.deliveryArapId,
    required this.syncDatetime,
    required this.orderLat,
    required this.orderLong,
    required this.fichNettotalText,
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
      ordStatusId,
      repRate,
      repTotal,
      fichModifyDate,
      fichTotalUnitAmount,
      fichModified,
      bankAccIdClient,
      bankAccIdLocal,
      deliveryArapId,
      syncDatetime,
      orderLat,
      orderLong,
      fichNettotalText,
      fichIdGuid,
    ];
  }

  TblMgOrderFich copyWith({
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
    int? ordStatusId,
    double? repRate,
    double? repTotal,
    DateTime? fichModifyDate,
    double? fichTotalUnitAmount,
    int? fichModified,
    int? bankAccIdClient,
    int? bankAccIdLocal,
    int? deliveryArapId,
    DateTime? syncDatetime,
    double? orderLat,
    double? orderLong,
    String? fichNettotalText,
    String? fichIdGuid,
  }) {
    return TblMgOrderFich(
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
      ordStatusId: ordStatusId ?? this.ordStatusId,
      repRate: repRate ?? this.repRate,
      repTotal: repTotal ?? this.repTotal,
      fichModifyDate: fichModifyDate ?? this.fichModifyDate,
      fichTotalUnitAmount: fichTotalUnitAmount ?? this.fichTotalUnitAmount,
      fichModified: fichModified ?? this.fichModified,
      bankAccIdClient: bankAccIdClient ?? this.bankAccIdClient,
      bankAccIdLocal: bankAccIdLocal ?? this.bankAccIdLocal,
      deliveryArapId: deliveryArapId ?? this.deliveryArapId,
      syncDatetime: syncDatetime ?? this.syncDatetime,
      orderLat: orderLat ?? this.orderLat,
      orderLong: orderLong ?? this.orderLong,
      fichNettotalText: fichNettotalText ?? this.fichNettotalText,
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
      'ord_status_id': ordStatusId,
      'rep_rate': repRate,
      'rep_total': repTotal,
      'fich_modify_date': fichModifyDate.millisecondsSinceEpoch,
      'fich_total_unit_amount': fichTotalUnitAmount,
      'fich_modified': fichModified,
      'bank_acc_id_client': bankAccIdClient,
      'bank_acc_id_local': bankAccIdLocal,
      'delivery_arap_id': deliveryArapId,
      'sync_datetime': syncDatetime.millisecondsSinceEpoch,
      'order_lat': orderLat,
      'order_long': orderLong,
      'fich_nettotal_text': fichNettotalText,
      'fich_id_guid': fichIdGuid,
    };
  }

  factory TblMgOrderFich.fromMap(Map<String, dynamic> map) {
    return TblMgOrderFich(
      fichId: map['fich_id'] ?? 0,
      fichCode: map['fich_code'] ?? '',
      fichDate: DateTime.parse(
          map['fich_date']?.toString() ?? '1900-01-01 00:00:00.000'),
      fichTotal: double.tryParse(map['fich_total']?.toString() ?? '0.0') ?? 0.0,
      fichCreateDate: DateTime.parse(
          map['fich_create_date']?.toString() ?? '1900-01-01 00:00:00.000'),
      fichTypeId: map['fich_type_id'] ?? 0,
      arapId: map['arap_id'] ?? 0,
      divId: map['div_id'] ?? 1,
      deptId: map['dept_id'] ?? 1,
      plantId: map['plant_id'] ?? 1,
      whId: map['wh_id'] ?? 1,
      pId: map['p_id'] ?? 1,
      invId: map['inv_id'] ?? 0,
      fichDesc: map['fich_desc'] ?? '',
      fichDiscount: double.tryParse(map['fich_discount']?.toString() ?? "0.0") ?? 0.0,
      fichNettotal: double.tryParse(map['fich_nettotal']?.toString() ?? "0.0") ?? 0.0,
      salesmanId: map['salesman_id'] ?? 0,
      tId: map['T_ID'] ?? 0,
      speCode: map['spe_code'] ?? '',
      groupCode: map['group_code'] ?? '',
      securityCode: map['security_code'] ?? '',
      payplanId: map['payplan_id'] ?? 0,
      ordStatusId: map['ord_status_id'] ?? 0,
      repRate: double.tryParse(map['rep_rate']?.toString() ?? '0.0') ?? 0.0,
      repTotal: double.tryParse(map['rep_total']?.toString() ?? '0.0') ?? 0.0,
      fichModifyDate: DateTime.parse(
          map['fich_modify_date']?.toString() ?? '1900-01-01 00:00:00.000'),
      fichTotalUnitAmount: double.tryParse(map['fich_total_unit_amount']?.toString() ?? '0.0') ?? 0.0,
      fichModified: map['fich_modified'] ?? 0,
      bankAccIdClient: map['bank_acc_id_client'] ?? 0,
      bankAccIdLocal: map['bank_acc_id_local'] ?? 0,
      deliveryArapId: map['delivery_arap_id'] ?? 1,
      syncDatetime: DateTime.parse(
          map['sync_datetime']?.toString() ?? '1900-01-01 00:00:00.000'),
      orderLat: double.tryParse(map['order_lat']?.toString() ?? '0.0') ?? 0.0,
      orderLong: double.tryParse(map['order_long']?.toString() ?? '0.0') ?? 0.0,
      fichNettotalText: map['fich_nettotal_text'] ?? '',
      fichIdGuid: map['fich_id_guid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TblMgOrderFich.fromJson(String source) =>
      TblMgOrderFich.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TblMgOrderFich(fichId: $fichId, fichCode: $fichCode, fichDate: $fichDate, fichTotal: $fichTotal, fichCreateDate: $fichCreateDate, fichTypeId: $fichTypeId, arapId: $arapId, divId: $divId, deptId: $deptId, plantId: $plantId, whId: $whId, pId: $pId, invId: $invId, fichDesc: $fichDesc, fichDiscount: $fichDiscount, fichNettotal: $fichNettotal, salesmanId: $salesmanId, tId: $tId, speCode: $speCode, groupCode: $groupCode, securityCode: $securityCode, payplanId: $payplanId, ordStatusId: $ordStatusId, repRate: $repRate, repTotal: $repTotal, fichModifyDate: $fichModifyDate, fichTotalUnitAmount: $fichTotalUnitAmount, fichModified: $fichModified, bankAccIdClient: $bankAccIdClient, bankAccIdLocal: $bankAccIdLocal, deliveryArapId: $deliveryArapId, syncDatetime: $syncDatetime, orderLat: $orderLat, orderLong: $orderLong, fichNettotalText: $fichNettotalText, fichIdGuid: $fichIdGuid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TblMgOrderFich &&
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
        other.ordStatusId == ordStatusId &&
        other.repRate == repRate &&
        other.repTotal == repTotal &&
        other.fichModifyDate == fichModifyDate &&
        other.fichTotalUnitAmount == fichTotalUnitAmount &&
        other.fichModified == fichModified &&
        other.bankAccIdClient == bankAccIdClient &&
        other.bankAccIdLocal == bankAccIdLocal &&
        other.deliveryArapId == deliveryArapId &&
        other.syncDatetime == syncDatetime &&
        other.orderLat == orderLat &&
        other.orderLong == orderLong &&
        other.fichNettotalText == fichNettotalText &&
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
        ordStatusId.hashCode ^
        repRate.hashCode ^
        repTotal.hashCode ^
        fichModifyDate.hashCode ^
        fichTotalUnitAmount.hashCode ^
        fichModified.hashCode ^
        bankAccIdClient.hashCode ^
        bankAccIdLocal.hashCode ^
        deliveryArapId.hashCode ^
        syncDatetime.hashCode ^
        orderLat.hashCode ^
        orderLong.hashCode ^
        fichNettotalText.hashCode ^
        fichIdGuid.hashCode;
  }
}
