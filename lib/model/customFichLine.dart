import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';

class CustomFichLine extends Equatable {
  final int fichLineId;
  final String materialName;
  final String matNameLang1;
  final String matNameLang2;
  final String matNameLang3;
  final String securityCode;
  final String securityName;
  final double fichLineAmount;
  final double fichLinePrice;
  final double fichLineTotal;
  final int fichId;
  final String fichCode;
  final int materialId;
  final String fichLineDesc;
  final double fichLineDiscPrc;
  final double fichLineDiscAmount;
  final double fichLineNettotal;
  final DateTime fichLineDate;
  final String fichLineIdGuid;
  final String fichIdGuid;
  final Uint8List imagePict;
  final String spe_code1;

  CustomFichLine({
    required this.fichLineId,
    required this.materialName,
    required this.matNameLang1,
    required this.matNameLang2,
    required this.matNameLang3,
    required this.securityCode,
    required this.securityName,
    required this.fichLineAmount,
    required this.fichLinePrice,
    required this.fichLineTotal,
    required this.fichId,
    required this.fichCode,
    required this.materialId,
    required this.fichLineDesc,
    required this.fichLineDiscPrc,
    required this.fichLineDiscAmount,
    required this.fichLineNettotal,
    required this.fichLineDate,
    required this.fichLineIdGuid,
    required this.fichIdGuid,
    required this.imagePict,
    required this.spe_code1
  });

  String name(AppLocalizations locale) {
    if (locale.locale.languageCode == 'tk') {
      return this.matNameLang3;
    } else if (locale.locale.languageCode == 'ru') {
      return this.matNameLang2;
    } else if (locale.locale.languageCode == 'en') {
      return this.matNameLang3;
    }
    return this.materialName;
  }

  CustomFichLine copyWith({
    int? fichLineId,
    String? materialName,
    String? matNameLang1,
    String? matNameLang2,
    String? matNameLang3,
    String? securityCode,
    String? securityName,
    double? fichLineAmount,
    double? fichLinePrice,
    double? fichLineTotal,
    int? fichId,
    String? fichCode,
    int? materialId,
    String? fichLineDesc,
    double? fichLineDiscPrc,
    double? fichLineDiscAmount,
    double? fichLineNettotal,
    DateTime? fichLineDate,
    String? fichLineIdGuid,
    String? fichIdGuid,
    Uint8List? imagePict,
    String? spe_code1,
  }) {
    return CustomFichLine(
      fichLineId: fichLineId ?? this.fichLineId,
      materialName: materialName ?? this.materialName,
      matNameLang1: matNameLang1 ?? this.matNameLang1,
      matNameLang2: matNameLang2 ?? this.matNameLang2,
      matNameLang3: matNameLang3 ?? this.matNameLang3,
      securityCode: securityCode ?? this.securityCode,
      securityName: securityName ?? this.securityName,
      fichLineAmount: fichLineAmount ?? this.fichLineAmount,
      fichLinePrice: fichLinePrice ?? this.fichLinePrice,
      fichLineTotal: fichLineTotal ?? this.fichLineTotal,
      fichId: fichId ?? this.fichId,
      fichCode: fichCode ?? this.fichCode,
      materialId: materialId ?? this.materialId,
      fichLineDesc: fichLineDesc ?? this.fichLineDesc,
      fichLineDiscPrc: fichLineDiscPrc ?? this.fichLineDiscPrc,
      fichLineDiscAmount: fichLineDiscAmount ?? this.fichLineDiscAmount,
      fichLineNettotal: fichLineNettotal ?? this.fichLineNettotal,
      fichLineDate: fichLineDate ?? this.fichLineDate,
      fichLineIdGuid: fichLineIdGuid ?? this.fichLineIdGuid,
      fichIdGuid: fichIdGuid ?? this.fichIdGuid,
      imagePict: imagePict ?? this.imagePict,
      spe_code1: spe_code1 ?? this.spe_code1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fich_line_id': fichLineId,
      'material_name': materialName,
      'mat_name_lang1': matNameLang1,
      'mat_name_lang2': matNameLang2,
      'mat_name_lang3': matNameLang3,
      'security_code': securityCode,
      'security_code_name': securityName,
      'fich_line_amount': fichLineAmount.toString(),
      'fich_line_price': fichLinePrice.toString(),
      'fich_line_total': fichLineTotal.toString(),
      'fich_id': fichId,
      'fich_code': fichCode,
      'material_id': materialId,
      'fich_line_desc': fichLineDesc,
      'fich_line_disc_prc': fichLineDiscPrc.toString(),
      'fich_line_disc_amount': fichLineDiscAmount.toString(),
      'fich_line_nettotal': fichLineNettotal.toString(),
      'fich_line_date': fichLineDate.millisecondsSinceEpoch,
      'fich_line_id_guid': fichLineIdGuid,
      'fich_id_guid': fichIdGuid,
      'image_pict': base64.encode(imagePict),
      'spe_code1': spe_code1.toString()
    };
  }

  factory CustomFichLine.fromMap(Map<String, dynamic> map) {
    String image = map['image_pict'] ?? '';
    return CustomFichLine(
      fichLineId: map['fich_line_id'] ?? 0,
      materialName: map['material_name'] ?? '',
      matNameLang1: map['mat_name_lang1'] ?? '',
      matNameLang2: map['mat_name_lang2'] ?? '',
      matNameLang3: map['mat_name_lang3'] ?? '',
      securityCode: map['security_code'] ?? '',
      securityName: map['security_code_name'] ?? '',
      fichLineAmount: double.tryParse(map['fich_line_amount']?.toString() ?? '0.0') ?? 0.0,
      fichLinePrice: double.tryParse(map['fich_line_price']?.toString() ?? '0.0') ?? 0.0,
      fichLineTotal: double.tryParse(map['fich_line_total']?.toString() ?? '0.0') ?? 0.0,
      fichId: map['fich_id'] ?? 0,
      fichCode: map['fich_code'] ?? '',
      materialId: map['material_id'] ?? 0,
      fichLineDesc: map['fich_line_desc'] ?? '',
      fichLineDiscPrc: double.tryParse(map['fich_line_disc_prc']?.toString() ?? '0.0') ?? 0.0,
      fichLineDiscAmount: double.tryParse(map['fich_line_disc_amount']?.toString() ?? '0.0') ?? 0.0,
      fichLineNettotal: double.tryParse(map['fich_line_nettotal']?.toString() ?? '0.0') ?? 0.0,
      fichLineDate: DateTime.parse(map['fich_line_date'].replaceAll('Z', '') ??
          '1900-01-01 00:00:00.000'),
      fichLineIdGuid: map['fich_line_id_guid'] ?? '',
      fichIdGuid: map['fich_id_guid'] ?? '',
      imagePict:
          image.isNotEmpty ? base64Decode((map['image_pict'])) : Uint8List(0),
        spe_code1:map['spe_code1'] ?? ''
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomFichLine.fromJson(String source) =>
      CustomFichLine.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      fichLineId,
      materialName,
      matNameLang1,
      matNameLang2,
      matNameLang3,
      securityCode,
      securityName,
      fichLineAmount,
      fichLinePrice,
      fichLineTotal,
      fichId,
      fichCode,
      materialId,
      fichLineDesc,
      fichLineDiscPrc,
      fichLineDiscAmount,
      fichLineNettotal,
      fichLineDate,
      fichLineIdGuid,
      fichIdGuid,
      imagePict,
    ];
  }
}
