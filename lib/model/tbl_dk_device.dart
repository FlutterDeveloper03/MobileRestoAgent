import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:equatable/equatable.dart';

class TblDkDevice extends Equatable {
  final int devId;
  final String devGuid;
  final String devUniqueId;
  final int rpAccId;
  final String devName;
  final String devDesc;
  final bool isAllowed;
  final DateTime? devVerifyDate;
  final String devVerifyKey;
  final String addInf1;
  final String addInf2;
  final String addInf3;
  final String addInf4;
  final String addInf5;
  final String addInf6;
  final String addInf7;
  final String addInf8;
  final String addInf9;
  final String addInf10;
  final DateTime? createdDate;
  final DateTime? modifiedDate;
  final int createdUId;
  final int modifiedUId;
  final DateTime? syncDateTime;
  final int optimisticLockField;
  final int gCRecord;
  final int resPriceGroupId;
  final int uId;
  final DateTime? allowDate;
  final DateTime? disallowedDate;
  TblDkDevice({
    required this.devId,
    required this.devGuid,
    required this.devUniqueId,
    required this.rpAccId,
    required this.devName,
    required this.devDesc,
    required this.isAllowed,
    required this.devVerifyDate,
    required this.devVerifyKey,
    required this.addInf1,
    required this.addInf2,
    required this.addInf3,
    required this.addInf4,
    required this.addInf5,
    required this.addInf6,
    required this.addInf7,
    required this.addInf8,
    required this.addInf9,
    required this.addInf10,
    required this.createdDate,
    required this.modifiedDate,
    required this.createdUId,
    required this.modifiedUId,
    required this.syncDateTime,
    required this.optimisticLockField,
    required this.gCRecord,
    required this.resPriceGroupId,
    required this.uId,
    required this.allowDate,
    required this.disallowedDate,
  });

  TblDkDevice copyWith({
    int? devId,
    String? devGuid,
    String? devUniqueId,
    int? rpAccId,
    String? devName,
    String? devDesc,
    bool? isAllowed,
    DateTime? devVerifyDate,
    String? devVerifyKey,
    String? addInf1,
    String? addInf2,
    String? addInf3,
    String? addInf4,
    String? addInf5,
    String? addInf6,
    DateTime? createdDate,
    DateTime? modifiedDate,
    int? createdUId,
    int? modifiedUId,
    DateTime? syncDateTime,
    int? optimisticLockField,
    int? gCRecord,
    int? resPriceGroupId,
    int? uId,
    DateTime? allowDate,
    DateTime? disallowedDate,
  }) {
    return TblDkDevice(
      devId: devId ?? this.devId,
      devGuid: devGuid ?? this.devGuid,
      devUniqueId: devUniqueId ?? this.devUniqueId,
      rpAccId: rpAccId ?? this.rpAccId,
      devName: devName ?? this.devName,
      devDesc: devDesc ?? this.devDesc,
      isAllowed: isAllowed ?? this.isAllowed,
      devVerifyDate: devVerifyDate ?? this.devVerifyDate,
      devVerifyKey: devVerifyKey ?? this.devVerifyKey,
      addInf1: addInf1 ?? this.addInf1,
      addInf2: addInf2 ?? this.addInf2,
      addInf3: addInf3 ?? this.addInf3,
      addInf4: addInf4 ?? this.addInf4,
      addInf5: addInf5 ?? this.addInf5,
      addInf6: addInf6 ?? this.addInf6,
      addInf7: addInf6 ?? this.addInf7,
      addInf8: addInf6 ?? this.addInf8,
      addInf9: addInf6 ?? this.addInf9,
      addInf10: addInf6 ?? this.addInf10,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      createdUId: createdUId ?? this.createdUId,
      modifiedUId: modifiedUId ?? this.modifiedUId,
      syncDateTime: syncDateTime ?? this.syncDateTime,
      optimisticLockField: optimisticLockField ?? this.optimisticLockField,
      gCRecord: gCRecord ?? this.gCRecord,
      resPriceGroupId: resPriceGroupId ?? this.resPriceGroupId,
      uId: uId ?? this.uId,
      allowDate: allowDate ?? this.allowDate,
      disallowedDate: disallowedDate ?? this.disallowedDate,
    );
  }

  Map<String, dynamic> toCryptMap() {
    final Key key1 = Key.fromBase64(
        base64Encode('Xzd0Rda!B^VkQ5)jlJUD1*0aoTd-4*)2'.codeUnits));
    final iv = IV.fromLength(16);
    String desc = devDesc.isNotEmpty ? devDesc : '';
    String name = devName.isNotEmpty ? devName : 'NO NAME';

    final Encrypter encrypter = Encrypter(AES(key1));
    return {
      'DevId': devId,
      'DevGuid': devGuid,
      'DevUniqueId': devUniqueId,
      'RpAccId': rpAccId,
      'DevName': name,
      'DevDesc': desc,
      'IsAllowed': isAllowed,
      'DevVerifyDate': devVerifyDate?.toString(),
      'DevVerifyKey': (devVerifyDate!=null) ?  encrypter
          .encrypt(jsonEncode([isAllowed.toString(), devVerifyDate?.toString()]),
              iv: iv)
          .base64 : '',
      'AddInf1': addInf1,
      'AddInf2': addInf2,
      'AddInf3': addInf3,
      'AddInf4': addInf4,
      'AddInf5': addInf5,
      'AddInf6': addInf6,
      'AddInf7': addInf7,
      'AddInf8': addInf8,
      'AddInf9': addInf9,
      'AddInf10': addInf10,
      'CreatedDate': createdDate?.toString(),
      'ModifiedDate': modifiedDate?.toString(),
      'CreatedUId': createdUId,
      'ModifiedUId': modifiedUId,
      'SyncDateTime': syncDateTime?.toString(),
      'OptimisticLockField': optimisticLockField,
      'GCRecord': gCRecord,
      'ResPriceGroupId': resPriceGroupId,
      'UId': uId,
      'AllowDate': allowDate?.toString(),
      'DisallowedDate': disallowedDate?.toString(),
    };
  }

  factory TblDkDevice.fromCryptMap(Map<String, dynamic> map) {
    DateTime? _parsedDate = DateTime.tryParse(map['DevVerifyKey'].toString());
    final Key key1 = Key.fromBase64(
        base64Encode('Xzd0Rda!B^VkQ5)jlJUD1*0aoTd-4*)2'.codeUnits));
    final iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(key1));
    final List<dynamic> decrypted =(map['DevVerifyKey']?.toString() ?? '').isNotEmpty ?
        (_parsedDate!=null) ? [map['IsAllowed'],map['DevVerifyKey']] :
        jsonDecode(encrypter.decrypt64(map['DevVerifyKey'] ?? ''.codeUnits, iv: iv)) : ''.codeUnits;

    return TblDkDevice(
      devId: map['DevId'] ?? 0,
      devGuid: map['DevGuid'] ?? '',
      devUniqueId: map['DevUniqueId'] ?? '',
      rpAccId: map['RpAccId'] ?? 0,
      devName: map['DevName'] ?? '',
      devDesc: map['DevDesc'] ?? '',
      isAllowed: decrypted.isNotEmpty ? decrypted[0].toString().toLowerCase()=="true" : false,
      devVerifyDate: map['DevVerifyDate'] != null
          ? DateTime.parse(map['DevVerifyDate'].toString())
          : DateTime.now(),
      devVerifyKey: (map['DevVerifyKey']!=null && decrypted.isNotEmpty) ? decrypted[1] : '',
      addInf1: map['AddInf1'] ?? '',
      addInf2: map['AddInf2'] ?? '',
      addInf3: map['AddInf3'] ?? '',
      addInf4: map['AddInf4'] ?? '',
      addInf5: map['AddInf5'] ?? '',
      addInf6: map['AddInf6'] ?? '',
      addInf7: map['AddInf7'] ?? '',
      addInf8: map['AddInf8'] ?? '',
      addInf9: map['AddInf9'] ?? '',
      addInf10: map['AddInf10'] ?? '',
      createdDate: DateTime.parse(
          map['CreatedDate']?.toString() ?? '1900-01-01 00:00:00.000'),
      modifiedDate: DateTime.parse(
          map['ModifiedDate']?.toString() ?? '1900-01-01 00:00:00.000'),
      createdUId: map['CreatedUId'] ?? 0,
      modifiedUId: map['ModifiedUId'] ?? 0,
      syncDateTime: DateTime.parse(
          map['SyncDateTime']?.toString() ?? '1900-01-01 00:00:00.000'),
      optimisticLockField: map['OptimisticLockField'] ?? 0,
      gCRecord: map['GCRecord'] ?? 0,
      resPriceGroupId: map['ResPriceGroupId'] ?? 0,
      uId: map['UId'] ?? 0,
      allowDate: map['AllowDate'] != null
          ? DateTime.parse(map['AllowDate'].toString())
          : null,
      disallowedDate: map['DisallowedDate'] != null
          ? DateTime.parse(map['DisallowedDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'DevId': devId,
      'DevGuid': devGuid,
      'DevUniqueId': devUniqueId,
      'RpAccId': rpAccId,
      'DevName': devName,
      'DevDesc': devDesc,
      'IsAllowed': isAllowed,
      'DevVerifyDate': devVerifyDate.toString(),
      'DevVerifyKey': devVerifyKey,
      'AddInf1': addInf1,
      'AddInf2': addInf2,
      'AddInf3': addInf3,
      'AddInf4': addInf4,
      'AddInf5': addInf5,
      'AddInf6': addInf6,
      'AddInf7': addInf7,
      'AddInf8': addInf8,
      'AddInf9': addInf9,
      'AddInf10': addInf10,
      'CreatedDate': createdDate.toString(),
      'ModifiedDate': modifiedDate.toString(),
      'CreatedUId': createdUId,
      'ModifiedUId': modifiedUId,
      'SyncDateTime': syncDateTime.toString(),
      'OptimisticLockField': optimisticLockField,
      'GCRecord': gCRecord,
      'ResPriceGroupId': resPriceGroupId,
      'UId': uId,
      'AllowDate': allowDate.toString(),
      'DisallowedDate': disallowedDate.toString(),
    };
  }

  factory TblDkDevice.fromMap(Map<String, dynamic> map) {
    final Key key1 = Key.fromBase64(base64Encode('Xzd0Rda!B^VkQ5)jlJUD1*0aoTd-4*)2'.codeUnits));
    final iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(key1));
    final bool isAllowed = map['IsAllowed'] ?? false;
    final DateTime? devVerifyDate = map['DevVerifyDate'] != null
        ? DateTime.parse(map['DevVerifyDate'].toString())
        : DateTime.now();
    return TblDkDevice(
      devId: map['DevId'] ?? 0,
      devGuid: map['DevGuid'] ?? '',
      devUniqueId: map['DevUniqueId'] ?? '',
      rpAccId: map['RpAccId'] ?? 0,
      devName: map['DevName'] ?? '',
      devDesc: map['DevDesc'] ?? '',
      isAllowed: isAllowed,
      devVerifyDate: devVerifyDate,
      devVerifyKey: (map['DevVerifyDate']!=null) ?  encrypter
          .encrypt(jsonEncode([isAllowed.toString(), map['DevVerifyDate']?.toString()]),
          iv: iv)
          .base64 : '',
      addInf1: map['AddInf1'] ?? '',
      addInf2: map['AddInf2'] ?? '',
      addInf3: map['AddInf3'] ?? '',
      addInf4: map['AddInf4'] ?? '',
      addInf5: map['AddInf5'] ?? '',
      addInf6: map['AddInf6'] ?? '',
      addInf7: map['AddInf7'] ?? '',
      addInf8: map['AddInf8'] ?? '',
      addInf9: map['AddInf9'] ?? '',
      addInf10: map['AddInf10'] ?? '',
      createdDate: DateTime.parse(
          map['CreatedDate']?.toString() ?? '1900-01-01 00:00:00.000'),
      modifiedDate: DateTime.parse(
          map['ModifiedDate']?.toString() ?? '1900-01-01 00:00:00.000'),
      createdUId: map['CreatedUId'] ?? 0,
      modifiedUId: map['ModifiedUId'] ?? 0,
      syncDateTime: DateTime.parse(
          map['SyncDateTime']?.toString() ?? '1900-01-01 00:00:00.000'),
      optimisticLockField: map['OptimisticLockField'] ?? 0,
      gCRecord: map['GCRecord'] ?? 0,
      resPriceGroupId: map['ResPriceGroupId'] ?? 0,
      uId: map['UId'] ?? 0,
      allowDate: DateTime.parse(
          map['AllowDate']?.toString() ?? '1900-01-01 00:00:00.000'),
      disallowedDate: DateTime.parse(
          map['DisallowedDate']?.toString() ?? '1900-01-01 00:00:00.000'),
    );
  }

  String toJson() => json.encode(toMap());

  factory TblDkDevice.fromJson(String source) =>
      TblDkDevice.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      devId,
      devGuid,
      devUniqueId,
      rpAccId,
      devName,
      devDesc,
      isAllowed,
      devVerifyKey,
      addInf1,
      addInf2,
      addInf3,
      addInf4,
      addInf5,
      addInf6,
      addInf7,
      addInf8,
      addInf9,
      addInf10,
      createdUId,
      modifiedUId,
      optimisticLockField,
      gCRecord,
      resPriceGroupId,
      uId,
    ];
  }
}
