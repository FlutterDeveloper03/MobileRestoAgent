import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:mobile_resto_agent/model/customFichLine.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';

class PrinterReject extends Equatable {
  final TblMgSalesman salesman;
  final String fichCode;
  final String client;
  final List<CustomFichLine> fichLines;
  final PrinterAddress printer;
  PrinterReject({
    required this.salesman,
    required this.fichCode,
    required this.client,
    required this.fichLines,
    required this.printer,
  });

  PrinterReject copyWith({
    TblMgSalesman? salesman,
    String? fichCode,
    String? client,
    List<CustomFichLine>? fichLines,
    PrinterAddress? printer,
  }) {
    return PrinterReject(
      salesman: salesman ?? this.salesman,
      fichCode: fichCode ?? this.fichCode,
      client: client ?? this.client,
      fichLines: fichLines ?? this.fichLines,
      printer: printer ?? this.printer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'salesman': salesman.toMap(),
      'fichCode': fichCode,
      'client': client,
      'fichLines': fichLines.map((x) => x.toMap()).toList(),
      'printer': printer.toMap(),
    };
  }

  factory PrinterReject.fromMap(Map<String, dynamic> map) {
    return PrinterReject(
      salesman: TblMgSalesman.fromMap(map['salesman']),
      fichCode: map['fichCode'],
      client: map['client'],
      fichLines: List<CustomFichLine>.from(
          map['fichLines']?.map((x) => CustomFichLine.fromMap(x))),
      printer: PrinterAddress.fromMap(map['printer']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrinterReject.fromJson(String source) =>
      PrinterReject.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      salesman,
      fichCode,
      client,
      fichLines,
      printer,
    ];
  }
}
