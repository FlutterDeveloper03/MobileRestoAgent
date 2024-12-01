import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/model/customFichLine.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:mobile_resto_agent/model/printerReject.dart';
import 'package:mobile_resto_agent/model/printerReport.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';

class CheckPrinter {
  final FromHive hive = FromHive();
  final PaperSize paper = PaperSize.mm80;

  Future<List<PrinterReport>> printCartItems(
    TblMgSalesman? salesman,
    String fichCode,
    String client,
    List<CartItem> cartItems,
  ) async {
    List<PrinterAddress> printers = [];
    List<PrinterReport> reports = [];
    try {
      printers = await hive.getPrinterAddresses();
    } catch (e) {
    }

    for (var printer in printers) {
      List<CartItem> prCartItems = cartItems
          .where((item) => item.material.securityCode == printer.ip)
          .toList();

      if (prCartItems.isNotEmpty) {
        reports.add(PrinterReport(
          salesman: salesman,
          fichCode: fichCode,
          client: client,
          cartItems: prCartItems,
          printer: printer,
        ));
      }
    }
    return reports;
  }

  Future<List<PrinterReject>> printRejects(
    TblMgSalesman salesman,
    String fichCode,
    String client,
    List<CustomFichLine> fichLines,
  ) async {
    List<PrinterAddress> printers = [];
    List<PrinterReject> reports = [];
    try {
      printers = await hive.getPrinterAddresses();
    } catch (e) {
      print('Hive settings get printer addresses error: $e');
    }

    for (var printer in printers) {
      List<CustomFichLine> prFichLines =
          fichLines.where((item) => item.securityCode == printer.ip).toList();
      if (prFichLines.isNotEmpty) {
        reports.add(PrinterReject(
          salesman: salesman,
          fichCode: fichCode,
          client: client,
          fichLines: prFichLines,
          printer: printer,
        ));
      }
    }
    return reports;
  }
}
