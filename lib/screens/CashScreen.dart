import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/Helpers/network_printer.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_resto_agent/model/customFichLine.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_resto_agent/model/table.dart' as m;

class CashSreen extends StatefulWidget {
  final List<CustomFichLine> fichLines;
  final m.Table table;
  final String salesman;
  final String firmName;
  final String address;
  final String phone;
  const CashSreen({
    Key? key,
    required this.fichLines,
    required this.table,
    required this.salesman,
    required this.address,
    required this.firmName,
    required this.phone,
  }) : super(key: key);

  @override
  _CashSreenState createState() => _CashSreenState();
}

class _CashSreenState extends State<CashSreen> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController tControl = TextEditingController();
  String input = '';
  bool isPrinted=false;
  Future<void> printImage(NetworkPrinter printer, Uint8List rawImage) async {
    final img.Image? image = img.decodeImage(rawImage);
    if (image != null) {
      printer.imageRaster(img.copyResize(image, width: 575));
    }
    printer.cut();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations trs = AppLocalizations.of(context);
    List<Widget> header = [
      Container(
        height: 100,
        // width: 100,
        child: Image.asset('assets/images/check.png'),
      ),
      Text(
        widget.firmName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        widget.address,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Container(
            width: 100,
            child: Text(
              'Faktura kody:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.table.fichCode,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          )
        ],
      ),
      Row(
        children: [
          Container(
            width: 100,
            child: Text(
              'Ofisiant:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            child: Text(
              widget.salesman,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      Row(
        children: [
          Container(
            width: 100,
            child: Text(
              'Müşderi:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            child: Text(
              widget.table.tableName,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      Row(
        children: [
          Container(
            width: 100,
            child: Text(
              'Telefon no:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            child: Text(
              widget.phone,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      Row(
        children: [
          Container(
            width: 100,
            child: Text(
              'Wagt:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            child: Text(
              DateFormat('yyyy-MM-dd kk:mm:ss')
                  .format(DateTime.now())
                  .toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Divider(
        thickness: 3,
        height: 3,
        color: Colors.black,
      ),
      Container(
        height: 18,
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Text(
                'Ady',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                'Muk X Bah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Jem',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(
        thickness: 3,
        height: 3,
        color: Colors.black,
      ),
    ];
    List<Widget> body = List.generate(widget.fichLines.length, (index) {
      CustomFichLine fichLine = widget.fichLines[index];
      return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Text(
                fichLine.materialName,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  // fontFamily: index % 2 == 0 ? 'monospace' : '',
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${fichLine.fichLineAmount.toInt()} X ${fichLine.fichLinePrice}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (fichLine.fichLineAmount * fichLine.fichLinePrice).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
    List<Widget> foot = [
      Container(
        alignment: Alignment.centerRight,
        child: Text(
          'JEMI:' + widget.table.fichTotal.toStringAsFixed(2),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      SizedBox(height: 5),
      Container(
        alignment: Alignment.center,
        child: Text(
          'Bizi saýladygyňyz üçin sag boluň!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Text(
          'Biz size ýene garaşýarys!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    ];
    List<Widget> joined = header + body + foot;

    Future<void> informDialog() async {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            trs.translate('must_print_before_exit') ?? 'You must print to continue!',
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: [
            TextButton(
              child: Text(
                trs.translate('ok') ?? 'OK',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        if (isPrinted){
          return true;
        } else {
          informDialog();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(trs.translate('cash_screen') ?? 'cash_screen'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
              width: 310,
              child: ListView(
                children: [
                  Screenshot(
                    controller: screenshotController,
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: joined,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextButton(
                            onPressed: () async {
                              await screenshotController
                                  .capture(delay: Duration(milliseconds: 10))
                                  .then((capturedImage) async {
                                try {
                                  final _sharedPref =
                                      await SharedPreferences.getInstance();
                                  String? defaultJson = _sharedPref
                                      .getString(SharedPrefKeys.cashPrinter);
                                  PrinterAddress cashPrinter = defaultJson != null
                                      ? PrinterAddress.fromJson(defaultJson)
                                      : PrinterAddress(
                                          ip: SharedPrefKeys.printerUrl,
                                          port: '9100');
                                  NetworkPrinter printer = NetworkPrinter(
                                    PaperSize.mm80,
                                    await CapabilityProfile.load(),
                                  );
                                  final PosPrintResult res =
                                      await printer.connect(
                                    cashPrinter.ip,
                                    port: int.parse(cashPrinter.port),
                                  );
                                  if (res == PosPrintResult.success &&
                                      capturedImage != null) {
                                    printImage(printer, capturedImage);
                                    isPrinted=true;
                                    printer.disconnect();
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                trs.translate('can_not_print') ??
                                                    'can_not_print')));
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              trs.translate('can_not_print') ??
                                                  'can_not_print')));
                                }
                              }).catchError((onError) {
                                print(onError);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            trs.translate('can_not_print') ??
                                                'can_not_print')));
                              });
                            },
                            child: Text(trs.translate('print') ?? 'print'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextButton(
                            onPressed: () async {
                              await screenshotController
                                  .capture(delay: Duration(milliseconds: 10))
                                  .then((capturedImage) async {
                                try {
                                  NetworkPrinter printer = NetworkPrinter(
                                    PaperSize.mm80,
                                    await CapabilityProfile.load(),
                                  );
                                  final _sharedPref =
                                      await SharedPreferences.getInstance();
                                  String? defaultJson = _sharedPref
                                      .getString(SharedPrefKeys.defaultPrinter);
                                  PrinterAddress defaultPrinter =
                                      defaultJson != null
                                          ? PrinterAddress.fromJson(defaultJson)
                                          : PrinterAddress(
                                              ip: SharedPrefKeys.printerUrl,
                                              port: '9100');
                                  final PosPrintResult res =
                                      await printer.connect(
                                    defaultPrinter.ip,
                                    port: int.parse(defaultPrinter.port),
                                  );
                                  if (res == PosPrintResult.success &&
                                      capturedImage != null) {
                                    printImage(printer, capturedImage);
                                    isPrinted=true;
                                    printer.disconnect();
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                trs.translate('can_not_print') ??
                                                    'can_not_print')));
                                  }

                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              trs.translate('can_not_print') ??
                                                  'can_not_print')));
                                }
                              }).catchError((onError) {
                                print(onError);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            trs.translate('can_not_print') ??
                                                'can_not_print')));
                              });
                            },
                            child: Text(trs.translate('print_on_default') ??
                                'print_on_default'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
