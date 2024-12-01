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
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_resto_agent/model/table.dart' as m;

class DeleteFichLinesScreen extends StatefulWidget {
  final CustomFichLine fichLine;
  final m.Table table;
  final TblMgSalesman salesman;
  const DeleteFichLinesScreen({
    Key? key,
    required this.fichLine,
    required this.table,
    required this.salesman,
  }) : super(key: key);

  @override
  _DeleteFichLinesScreenState createState() => _DeleteFichLinesScreenState();
}

class _DeleteFichLinesScreenState extends State<DeleteFichLinesScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController tControl = TextEditingController();
  String input = '';
  Future<void> printImage(NetworkPrinter printer, Uint8List rawImage) async {
    final img.Image? image = img.decodeImage(rawImage);
    if (image != null) {
      printer.imageRaster(img.copyResize(image, width: 575));
    } else {
      print('PrintError: Image is null!');
    }
    printer.cut();
  }

  Future<String> showTextFieldDialog(
    BuildContext context,
    AppLocalizations trs,
  ) async {
    return await (showDialog(
          context: context,
          builder: (context1) {
            TextEditingController passController = TextEditingController();
            BorderRadius borderRadius = BorderRadius.circular(15);
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
              insetPadding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: borderRadius,
                ),
                padding: EdgeInsets.all(8.0),
                height: 115,
                width: 350,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Colors.white,
                      ),
                      child: TextField(
                        autofocus: true,
                        obscureText: true,
                        controller: passController,
                        onSubmitted: (String text) {
                          Navigator.pop(context, text);
                        },
                        decoration: InputDecoration(
                          hintText: trs.translate('password'),
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.password,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          contentPadding: EdgeInsets.all(8.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight),
                            borderRadius: borderRadius,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight),
                            borderRadius: borderRadius,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        side: BorderSide(
                          style: BorderStyle.solid,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, passController.text);
                      },
                      child: Text(trs.translate('ok') ?? 'ok'),
                    ),
                  ],
                ),
              ),
            );
          },
        )) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations trs = AppLocalizations.of(context);
    List<Widget> header = [
      Text(
        'Otmen çek',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
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
              'Ýeri',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            child: Text(
              '${widget.fichLine.securityName}(${widget.fichLine.securityCode})',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
              'Zakaz code:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: 210,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.fichLine.fichCode,
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
              'Ofisiant:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            child: Text(
              widget.salesman.salesmanName,
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
              DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now()).toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      Divider(
        thickness: 3,
        color: Colors.black,
      ),
      Row(
        children: [
          Expanded(
            flex: 9,
            child: Text(
              'Ady',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Mukadary',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      Divider(
        thickness: 3,
        color: Colors.black,
      ),
    ];
    List<Widget> body = [
      Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Text(
                widget.fichLine.materialName,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  // fontFamily: index % 2 == 0 ? 'monospace' : '',
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.fichLine.fichLineAmount.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    List<Widget> foot = [];
    List<Widget> joined = header + body + foot;

    // double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        bool result = false;
        // String pass = await showTextFieldDialog(
        //   context,
        //   trs,
        // );
        // if (pass == widget.salesman.salesmanMng) {
        //   print('delete true');
        //   // return true;
        //   result = true;
        // } else {
        //   print('delete false');
        //   result = false;
        // }

        print('delete fichlines result:$result');
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(trs.translate('deletefichlines_screen') ??
              'deletefichlines_screen'),
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
                            onPressed: () {
                              screenshotController
                                  .capture(delay: Duration(milliseconds: 10))
                                  .then((capturedImage) async {
                                try {
                                  // final _sharedPref =
                                  //     await SharedPreferences.getInstance();
                                  // String? defaultJson = _sharedPref
                                  //     .getString(SharedPrefKeys.cashPrinter);

                                  PrinterAddress deletePrinter = PrinterAddress(
                                      ip: widget.fichLine.securityCode,
                                      port: '9100');
                                  NetworkPrinter printer = NetworkPrinter(
                                    PaperSize.mm80,
                                    await CapabilityProfile.load(),
                                  );
                                  final PosPrintResult res =
                                      await printer.connect(
                                    deletePrinter.ip,
                                    port: int.parse(deletePrinter.port),
                                  );
                                  if (res == PosPrintResult.success &&
                                      capturedImage != null) {
                                    await printImage(printer, capturedImage);
                                    // showCapturedWidget(context, capturedImage);
                                    printer.disconnect();
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            trs.translate('can_not_print') ??
                                                'can_not_print'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print(
                                      'problem on printer print:$e');
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
                            onPressed: () {
                              screenshotController
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
                                      .getString(SharedPrefKeys.cashPrinter);
                                  PrinterAddress defaultPrinter =
                                      defaultJson != null
                                          ? PrinterAddress.fromJson(defaultJson)
                                          : PrinterAddress(
                                              ip: SharedPrefKeys.printerUrl,
                                              port: '9100');
                                  print(
                                      'default printer: ${defaultPrinter.ip}');
                                  final PosPrintResult res =
                                      await printer.connect(
                                    defaultPrinter.ip,
                                    port: int.parse(defaultPrinter.port),
                                  );
                                  if (res == PosPrintResult.success &&
                                      capturedImage != null) {
                                    await printImage(printer, capturedImage);
                                    // showCapturedWidget(context, capturedImage);
                                    printer.disconnect();
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(trs.translate(
                                                    'can_not_print') ??
                                                'can_not_print')));
                                  }
                                } catch (e) {
                                  print(
                                      'problem on printer print:$e');
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
                        Container(
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          child: TextButton(
                            onPressed: () async {
                              bool result = false;
                              String pass = await showTextFieldDialog(
                                context,
                                trs,
                              );
                              if (pass == widget.salesman.salesmanMng) {
                                result = true;
                              } else {
                                result = false;
                              }
                              if (result) {
                                Navigator.pop(context);
                                screenshotController
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
                                        .getString(SharedPrefKeys.cashPrinter);
                                    PrinterAddress defaultPrinter =
                                        defaultJson != null
                                            ? PrinterAddress.fromJson(
                                                defaultJson)
                                            : PrinterAddress(
                                                ip: SharedPrefKeys.printerUrl,
                                                port: '9100');
                                    print(
                                        'default printer: ${defaultPrinter.ip}');
                                    final PosPrintResult res =
                                        await printer.connect(
                                      defaultPrinter.ip,
                                      port: int.parse(defaultPrinter.port),
                                    );
                                    if (res == PosPrintResult.success &&
                                        capturedImage != null) {
                                      await printImage(printer, capturedImage);
                                      // showCapturedWidget(context, capturedImage);
                                      printer.disconnect();
                                      Navigator.pop(context);
                                    } else {
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //         content: Text(trs.translate(
                                      //                 'can_not_print') ??
                                      //             'can_not_print')));
                                    }
                                  } catch (e) {
                                    print(
                                        'problem on printer print:$e');
                                  }
                                }).catchError((onError) {
                                  print(onError);
                                });
                              }
                            },
                            child: Text(trs.translate('unsuccessfully_next') ??
                                'unsuccessfully_next'),
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
