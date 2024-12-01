import 'dart:convert';

import 'package:equatable/equatable.dart';

class PrinterAddress extends Equatable {
  final String ip;
  final String port;
  PrinterAddress({
    required this.ip,
    required this.port,
  });
  @override
  List<Object> get props => [ip, port];

  PrinterAddress copyWith({
    String? ip,
    String? port,
  }) {
    return PrinterAddress(
      ip: ip ?? this.ip,
      port: port ?? this.port,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ip': ip,
      'port': port,
    };
  }

  factory PrinterAddress.fromMap(Map<String, dynamic> map) {
    return PrinterAddress(
      ip: map['ip'],
      port: map['port'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PrinterAddress.fromJson(String source) =>
      PrinterAddress.fromMap(json.decode(source));

  @override
  bool get stringify => true;
}
