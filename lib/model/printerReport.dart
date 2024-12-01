import 'package:equatable/equatable.dart';

import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';

class PrinterReport extends Equatable {
  final TblMgSalesman? salesman;
  final String fichCode;
  final String client;
  final List<CartItem> cartItems;
  final PrinterAddress printer;

  PrinterReport({
    required this.salesman,
    required this.fichCode,
    required this.client,
    required this.cartItems,
    required this.printer,
  });

  PrinterReport copyWith({
    TblMgSalesman? salesman,
    String? fichCode,
    String? client,
    List<CartItem>? cartItems,
    PrinterAddress? printer,
  }) {
    return PrinterReport(
      salesman: salesman ?? this.salesman,
      fichCode: fichCode ?? this.fichCode,
      client: client ?? this.client,
      cartItems: cartItems ?? this.cartItems,
      printer: printer ?? this.printer,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      salesman ??
          TblMgSalesman(
              salesmanId: 0,
              salesmanName: '',
              firmId: 0,
              salesmanPass: '',
              salesmanMng: '',
              salesmanWhId: 0,
              saleDiscCardId: 0,
              ksCardId: 0,
              speCode: '',
              groupCode: '',
              securityCode: '',
              salesmanIdGuid: '',
              salesmanStatusId: 1
          ),
      fichCode,
      client,
      cartItems,
      printer,
    ];
  }
}
