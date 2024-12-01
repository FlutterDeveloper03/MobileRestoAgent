import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/Helpers/network_printer.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_resto_agent/bloc/RejectBloc.dart';
import 'package:mobile_resto_agent/model/customFichLine.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RejectScreen extends StatefulWidget {
  const RejectScreen({Key? key}) : super(key: key);

  @override
  _RejectScreenState createState() => _RejectScreenState();
}

class _RejectScreenState extends State<RejectScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController tControl = TextEditingController();
  String input = '';
  Future<void> printImage(NetworkPrinter printer, Uint8List rawImage) async {
    final img.Image? image = img.decodeImage(rawImage);
    if (image != null) {
      printer.imageRaster(img.copyResize(image, width: 575));
      print('Print image was printed');
    } else {
      print('Print image is null!');
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
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        bool result = false;

        print('Print delete fichlines result:$result');
        return result;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(trs.translate('report_screen') ?? 'report_screen'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Container(
          color: Colors.white,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 310,
              child: BlocConsumer<RejectBloc, RejectState>(
                builder: (context, state) {
                  print("Print state is :$state");
                  if (state is LoadedState) {
                    print(
                        'Print 4 rejects cart: ${state.reject.fichLines.first.materialName}');
                    List<CustomFichLine> fichLines = state.reject.fichLines;
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
                              '${state.reject.fichLines.first.securityName}(${state.reject.printer.ip})',
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
                                state.reject.fichCode,
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
                              state.reject.client,
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
                              state.reject.salesman.salesmanName,
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
                              DateFormat('yyyy-MM-dd kk:mm')
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
                    List<Widget> body =
                    List.generate(fichLines.length, (index) {
                      return Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: Text(
                                fichLines[index].materialName,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                fichLines[index].fichLineAmount.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
                    List<Widget> foot = [
                      Divider(
                        thickness: 3,
                        color: Colors.black,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bellik: ' + input,
                          textWidthBasis: TextWidthBasis.longestLine,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            overflow: TextOverflow.clip,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ];
                    List<Widget> joined = header + body + foot;

                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<RejectBloc>(context).add(
                          RefreshEvent(),
                        );
                      },
                      child: ListView(
                        children: [
                          Screenshot(
                            controller: screenshotController,
                            child: Container(
                              width: 310,
                              color: Colors.white,
                              child: SingleChildScrollView(
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
                                          .capture(
                                          delay: Duration(milliseconds: 10))
                                          .then((capturedImage) async {
                                        try {
                                          NetworkPrinter printer =
                                          NetworkPrinter(
                                            PaperSize.mm80,
                                            await CapabilityProfile.load(),
                                          );
                                          final PosPrintResult res =
                                          await printer.connect(
                                            state.reject.printer.ip,
                                            port: int.parse(
                                                state.reject.printer.port),
                                          );
                                          if (res == PosPrintResult.success &&
                                              capturedImage != null) {
                                            await printImage(
                                                printer, capturedImage);
                                            // showCapturedWidget(context, capturedImage);
                                            printer.disconnect();
                                            print('Print success in print');
                                            BlocProvider.of<RejectBloc>(context)
                                                .add(
                                              NextRejectEvent(),
                                            );
                                          } else {
                                            print(
                                                'Print not success in print');
                                            BlocProvider.of<RejectBloc>(context)
                                                .add(
                                              RefreshEvent(),
                                            );
                                          }
                                        } catch (e) {
                                          print(
                                              'Print problem on printer print:$e');
                                          BlocProvider.of<RejectBloc>(context)
                                              .add(
                                            RefreshEvent(),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(trs.translate(
                                                  'can_not_print') ??
                                                  'can_not_print')));
                                        }
                                      }).catchError((onError) {
                                        print(onError);
                                        BlocProvider.of<RejectBloc>(context)
                                            .add(
                                          RefreshEvent(),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                            content: Text(trs.translate(
                                                'can_not_print') ??
                                                'can_not_print')));
                                      });
                                    },
                                    child:
                                    Text(trs.translate('print') ?? 'print'),
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
                                          .capture(
                                          delay: Duration(milliseconds: 10))
                                          .then((capturedImage) async {
                                        try {
                                          NetworkPrinter printer =
                                          NetworkPrinter(
                                            PaperSize.mm80,
                                            await CapabilityProfile.load(),
                                          );
                                          final _sharedPref =
                                          await SharedPreferences
                                              .getInstance();
                                          String? defaultJson = _sharedPref
                                              .getString(SharedPrefKeys
                                              .defaultPrinter);
                                          PrinterAddress defaultPrinter =
                                          defaultJson != null
                                              ? PrinterAddress.fromJson(
                                              defaultJson)
                                              : PrinterAddress(
                                              ip: SharedPrefKeys
                                                  .printerUrl,
                                              port: '9100');
                                          print(
                                              'Print default printer: ${defaultPrinter.ip}');
                                          final PosPrintResult res =
                                          await printer.connect(
                                            defaultPrinter.ip,
                                            port:
                                            int.parse(defaultPrinter.port),
                                          );
                                          if (res == PosPrintResult.success &&
                                              capturedImage != null) {
                                            await printImage(
                                                printer, capturedImage);
                                            // showCapturedWidget(context, capturedImage);
                                            printer.disconnect();
                                            BlocProvider.of<RejectBloc>(context)
                                                .add(
                                              NextRejectEvent(),
                                            );
                                          } else {
                                            BlocProvider.of<RejectBloc>(context)
                                                .add(
                                              RefreshEvent(),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(trs.translate(
                                                    'can_not_print') ??
                                                    'can_not_print')));
                                          }
                                        } catch (e) {
                                          print(
                                              'Print problem on printer print:$e');
                                          BlocProvider.of<RejectBloc>(context)
                                              .add(
                                            RefreshEvent(),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(trs.translate(
                                                  'can_not_print') ??
                                                  'can_not_print')));
                                        }
                                      }).catchError((onError) {
                                        print(onError);
                                        BlocProvider.of<RejectBloc>(context)
                                            .add(
                                          RefreshEvent(),
                                        );
                                      });
                                    },
                                    child: Text(
                                        trs.translate('print_on_default') ??
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
                                      if (pass ==
                                          state.reject.salesman.salesmanMng) {
                                        result = true;
                                      } else {
                                        result = false;
                                      }
                                      if (result) {
                                        await screenshotController
                                            .capture(
                                            delay:
                                            Duration(milliseconds: 10))
                                            .then((capturedImage) async {
                                          try {
                                            NetworkPrinter printer =
                                            NetworkPrinter(
                                              PaperSize.mm80,
                                              await CapabilityProfile.load(),
                                            );
                                            final _sharedPref =
                                            await SharedPreferences
                                                .getInstance();
                                            String? defaultJson =
                                            _sharedPref.getString(
                                                SharedPrefKeys.cashPrinter);
                                            PrinterAddress defaultPrinter =
                                            defaultJson != null
                                                ? PrinterAddress.fromJson(
                                                defaultJson)
                                                : PrinterAddress(
                                                ip: SharedPrefKeys
                                                    .printerUrl,
                                                port: '9100');
                                            print(
                                                'Print default printer: ${defaultPrinter.ip}');
                                            final PosPrintResult res =
                                            await printer.connect(
                                              defaultPrinter.ip,
                                              port: int.parse(
                                                  defaultPrinter.port),
                                            );
                                            if (res == PosPrintResult.success &&
                                                capturedImage != null) {
                                              print(
                                                  'Print image print section');
                                              await printImage(
                                                  printer, capturedImage);
                                              // showCapturedWidget(context, capturedImage);
                                              printer.disconnect();
                                            } else {
                                              print(
                                                  'Print image was null: $capturedImage');
                                              // showCapturedWidget(context, capturedImage);
                                              printer.disconnect();
                                            }
                                          } catch (e) {
                                            print(
                                                'Print problem on printer print:$e');
                                          }
                                        }).catchError((onError) {
                                          print(onError);
                                        });
                                        BlocProvider.of<RejectBloc>(context)
                                            .add(
                                          NextRejectEvent(),
                                        );
                                      }
                                    },
                                    child: Text(
                                        trs.translate('unsuccessfully_next') ??
                                            'unsuccessfully_next'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                          ),
                        ],
                      ),
                    );
                  } else if (state is LoadingState) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<RejectBloc>(context).add(
                          RefreshEvent(),
                        );
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Container(
                              height: height * 0.89,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
                listener: (context, state) {
                  if (state is EmptyState) {
                    print('Print Empty state');
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 250,
          height: 65,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 2),
          ),
          child: TextField(
            controller: tControl,
            onChanged: (String txt) {
              setState(() {
                input = txt;
              });
            },
            textAlignVertical: TextAlignVertical.center,
            // decoration: InputDecoration(
            //   border: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(0),
            //     borderSide: BorderSide.none,
            //   ),
            // ),
            cursorHeight: 25,
            scrollPadding: EdgeInsets.all(5.0),
            style: TextStyle(
              // height: 20,
              fontSize: 20,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
