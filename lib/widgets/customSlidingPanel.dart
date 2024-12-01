import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_resto_agent/bloc/FichBloc.dart' as f;
import 'package:mobile_resto_agent/bloc/MaterialBloc.dart';
import 'package:mobile_resto_agent/bloc/TableBloc.dart' as t;
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/model/CartItem.dart';
import 'package:mobile_resto_agent/model/customFichLine.dart';
import 'package:mobile_resto_agent/model/table.dart' as tm;
import 'package:mobile_resto_agent/model/tbl_mg_mat_attributes.dart';
import 'package:mobile_resto_agent/model/tbl_mg_salesman.dart';
import 'package:mobile_resto_agent/screens/CashScreen.dart';
import 'package:mobile_resto_agent/screens/DeleteFichLinesScreen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CustomSlidingPanel extends StatefulWidget {
  final Widget child;
  tm.Table table;
  final double headerHeight;

  CustomSlidingPanel({
    Key? key,
    required this.child,
    required this.table,
    required this.headerHeight,
  }) : super(key: key);

  @override
  _CustomSlidingPanelState createState() => _CustomSlidingPanelState();
}

class _CustomSlidingPanelState extends State<CustomSlidingPanel> {
  PanelController panelController = PanelController();
  bool isOpened = false;
  double sumFich = 0;
  double sumCart = 0;
  List<int> selectedLines = [];
  List<CustomFichLine> rejects = [];
  TblMgSalesman? salesman;
  String txt = '';

  String speCode = "";
  String securityCode = "";
  String groupCode = "";
  String invDesc = "";

  showTextFieldDialog(BuildContext context, Function func, AppLocalizations trs, String defaultText, bool isPassword) {
    showDialog(
      context: context,
      builder: (context1) {
        TextEditingController textController = TextEditingController();
        TextEditingController invDescTextController = TextEditingController();
        TextEditingController speCodeTextController = TextEditingController();
        TextEditingController groupCodeTextController = TextEditingController();
        TextEditingController securityCodeTextController = TextEditingController();

        invDescTextController.text = (widget.table.invDesc.isNotEmpty) ? widget.table.invDesc : invDesc;
        speCodeTextController.text = (widget.table.speCode.isNotEmpty) ? widget.table.speCode : speCode;
        groupCodeTextController.text = (widget.table.groupCode.isNotEmpty) ? widget.table.groupCode : groupCode;
        securityCodeTextController.text = (widget.table.securityCode.isNotEmpty) ? widget.table.securityCode : securityCode;



        BorderRadius borderRadius = BorderRadius.circular(15);
        textController.text = (isPassword) ? '' : defaultText;
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
            height: (isPassword) ? 115 : 340,
            width: 350,
            child: Column(
              children: [
                (!isPassword)
                    ? Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Colors.white,
                        ),
                        child: TextField(
                          autofocus: true,
                          obscureText: false,
                          controller: invDescTextController,
                          decoration: InputDecoration(
                            hintText: trs.translate('invDescription') ?? 'Invoice description',
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(Icons.info_outline, color: Theme.of(context).primaryColorLight),
                            contentPadding: EdgeInsets.all(8.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                (!isPassword)
                    ? Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Colors.white,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          obscureText: false,
                          controller: speCodeTextController,
                          decoration: InputDecoration(
                            hintText: trs.translate('invSpeCodeAsPhone1') ?? 'Phone1',
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.phone_android_outlined,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            contentPadding: EdgeInsets.all(8.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                (!isPassword)
                    ? Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Colors.white,
                        ),
                        child: TextField(
                          autofocus: true,
                          obscureText: false,
                          controller: groupCodeTextController,
                          decoration: InputDecoration(
                            hintText: trs.translate('invGroupCodeAsPhone2') ?? 'Phone2',
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            contentPadding: EdgeInsets.all(8.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                (!isPassword)
                    ? Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Colors.white,
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) => Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(trs.translate('orderTypeTable') ?? 'Table'),
                                  leading: Radio(
                                    value: trs.translate('orderTypeTable') ?? 'Table',
                                    groupValue: securityCodeTextController.text,
                                    onChanged: (String? value) => setState(() => securityCodeTextController.text = (value ?? '')),
                                  ),
                                  onTap: () {
                                    setState(() => securityCodeTextController.text = (trs.translate('orderTypeTable') ?? ''));
                                  },
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(trs.translate('orderTypeDelivery') ?? 'Delivery'),
                                  leading: Radio(
                                    value: trs.translate('orderTypeDelivery') ?? 'Delivery',
                                    groupValue: securityCodeTextController.text,
                                    onChanged: (String? value) => setState(() => securityCodeTextController.text = (value ?? '')),
                                  ),
                                  onTap: () {
                                    setState(() => securityCodeTextController.text = (trs.translate('orderTypeDelivery') ?? ''));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Colors.white,
                  ),
                  child: TextField(
                    autofocus: true,
                    obscureText: isPassword,
                    controller: textController,
                    onSubmitted: (String text) {
                      func(text);
                      Navigator.pop(context);
                    },
                    decoration: InputDecoration(
                      hintText: (isPassword) ? trs.translate('password') : trs.translate('lineDescription') ?? 'LineDescription',
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        (isPassword) ? Icons.password : Icons.info_outline,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      contentPadding: EdgeInsets.all(8.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                        borderRadius: borderRadius,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColorLight),
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  onPressed: () {
                    try {
                      if (!isPassword) {
                        txt = textController.text;
                        speCode = speCodeTextController.text;
                        groupCode = groupCodeTextController.text;
                        securityCode = securityCodeTextController.text;
                        invDesc = invDescTextController.text;
                        func(invDescTextController.text, speCodeTextController.text, groupCodeTextController.text, securityCodeTextController.text,
                            textController.text);
                      } else {
                        func(textController.text);
                      }
                    } catch (e) {
                      print("PrintError: " + e.toString());
                    }
                    Navigator.pop(context);
                  },
                  child: Text(trs.translate('ok') ?? 'ok'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showAttributesDialog(BuildContext context, CartItem cartItem, Function func, AppLocalizations trs) {
    showDialog(
      context: context,
      builder: (context1) {
        final attributesTEC = TextEditingController();
        BorderRadius borderRadius = BorderRadius.circular(15);
        String extraAttribs = '';
        if (cartItem.matAttributes.isNotEmpty) {
          for (TblMgMatAttributes attribute in cartItem.matAttributes) {
            extraAttribs = (cartItem.material.matAttributes.contains(attribute)) ? '' : attribute.mat_attribute_name.toString() + ',';
          }
        }
        attributesTEC.text = extraAttribs;
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
            height: MediaQuery.of(context).size.height / 1.3,
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Attributlar'),
                  controller: attributesTEC,
                ),
                (cartItem.material.matAttributes.length > 0)
                    ? Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return StatefulBuilder(
                                builder: (context, setState) => CheckboxListTile(
                                  title: Text(cartItem.material.matAttributes[index].mat_attribute_name.toString()),
                                  selected: cartItem.matAttributes
                                      .any((element) => element.mat_attribute_name == cartItem.material.matAttributes[index].mat_attribute_name),
                                  value: cartItem.matAttributes
                                      .any((element) => element.mat_attribute_name == cartItem.material.matAttributes[index].mat_attribute_name),
                                  activeColor: Theme.of(context).primaryColor,
                                  onChanged: (value) {
                                    if (value ?? false) {
                                      cartItem.matAttributes.add(cartItem.material.matAttributes[index]);
                                      setState(
                                        () => {},
                                      );
                                    } else {
                                      cartItem.matAttributes.removeWhere(
                                          (element) => element.mat_attribute_id == cartItem.material.matAttributes[index].mat_attribute_id);
                                      setState(
                                        () => {},
                                      );
                                    }
                                  },
                                  secondary: Icon(Icons.apartment),
                                ),
                              );
                            },
                            itemCount: cartItem.material.matAttributes.length,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                        child: Text(trs.translate('noAttributes') ?? 'Product doesn\'t have any additional attributes'),
                      )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  onPressed: () {
                    String attrStr = attributesTEC.text;
                    cartItem.matAttributes.removeWhere((element) => element.mat_attribute_id.isEmpty);
                    if (attrStr.isNotEmpty) {
                      if (attrStr.endsWith(',')) {
                        attrStr = attrStr.substring(0, attributesTEC.text.length - 1);
                      }
                      cartItem.matAttributes.add(TblMgMatAttributes(
                          mat_attribute_id: '',
                          mat_attribute_name: attrStr,
                          mat_attribute_desc: attrStr,
                          mat_attribute_type_id: '',
                          material_id_guid: '',
                          material_id: 0,
                          spe_code: '',
                          group_code: '',
                          security_code: '',
                          image_path: '',
                          linked_material_code: ''));
                    }
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: Text(trs.translate('ok') ?? 'ok'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final double width = MediaQuery.of(context).size.width;
    Widget buildCartItems(List<CartItem> cartItems) {
      return SliverToBoxAdapter(
        child: Container(
          height: MediaQuery.sizeOf(context).height/1.7,
          child: ListView(
            children: cartItems.map((cartItem) {
              return Container(
                height: 70,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Row(
                  children: [
                    cartItem.material.imagePict.isNotEmpty ?
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(left: 5),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                                image: MemoryImage(cartItem.material.imagePict),
                                fit: BoxFit.cover,
                              )
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SvgPicture.asset(
                        'assets/images/Cart.svg',
                        height: 30,
                        width: 30,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              cartItem.material.name(trs),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      cartItem.material.salePrice.toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.blue[900]),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('x', style: TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      cartItem.count.toStringAsFixed(0),
                                      style: TextStyle(color: Colors.green[900]),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        '=',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      (cartItem.material.salePrice * cartItem.count).toString(),
                                      style: TextStyle(color: Colors.red[900]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<MaterialBloc>(context).add(MinusCount(
                                  material: cartItem.material,
                                ));
                              },
                              icon: Icon(Icons.remove),
                            ),
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<MaterialBloc>(context).add(PlusCount(
                                  material: cartItem.material,
                                ));
                              },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () async {
                          showAttributesDialog(context, cartItem, () {}, trs);
                        },
                        child: Icon(
                          Icons.info_outline,
                          color: (cartItem.matAttributes.length > 0) ? Colors.amberAccent : Colors.black,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    Widget buildFichLines(
      List<CustomFichLine> fichLines,
      TblMgSalesman salesman,
    ) {
      if (selectedLines.isEmpty) {
        selectedLines = fichLines.map((e) => 0).toList();
      }
      return SliverToBoxAdapter(
        child: Container(
          height: fichLines.length * 70,
          child: Column(
            children: fichLines.map((fichLine) {
              int index = fichLines.indexOf(fichLine);
              bool selected = selectedLines[index] == 1;
              return Container(
                height: (fichLine.spe_code1.isNotEmpty) ? 65 : 50,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: selected ? Colors.grey[500] : Theme.of(context).primaryColorLight,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(left: 5),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: fichLine.imagePict.isNotEmpty
                                ? DecorationImage(
                                    image: MemoryImage(fichLine.imagePict),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: AssetImage('assets/images/NoImage.svg'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              fichLine.name(trs),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            fichLine.fichLinePrice.toString(),
                            style: TextStyle(color: Colors.blue[200]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('x', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            fichLine.fichLineAmount.toString(),
                            style: TextStyle(color: Colors.green[200]),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('=', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            fichLine.fichLineNettotal.toString(),
                            style: TextStyle(color: Colors.red[200]),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedLines[index] == 0) {
                                selectedLines[index] = 1;
                                rejects.add(fichLine);
                              } else {
                                selectedLines[index] = 0;
                                rejects.removeAt(index);
                              }
                            });
                          },
                          icon: Icon(
                            selected ? Icons.remove : Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (fichLine.spe_code1.isNotEmpty)
                      FittedBox(fit: BoxFit.fitWidth, child: Text(fichLine.spe_code1.toString(), style: TextStyle(color: Colors.white)))
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    Future<bool> askToConfirmDialog(String text) async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                trs.translate(text) ?? text,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              actions: [
                TextButton(
                  child: Text(
                    trs.translate('no') ?? 'no',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: Text(
                    trs.translate('yes') ?? 'yes',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                )
              ],
            ),
          )) ??
          false;
    }

    Widget panel = Container(
      height: 600,
      margin: EdgeInsets.only(top: widget.headerHeight),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(trs.translate('orders') ?? 'orders'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (salesman != null) {
                        deleteFichLine(String? text) {
                          if (text == salesman!.salesmanMng) {
                            BlocProvider.of<f.FichBloc>(context).add(
                              f.DeleteFichLines(
                                rejects: rejects,
                                table: widget.table,
                              ),
                            );
                          }
                        }

                        showTextFieldDialog(context, deleteFichLine, trs, '', true);
                      }
                    },
                    child: Text(trs.translate('delete_selected_orders') ?? 'delete_selected_orders'),
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<f.FichBloc, f.FichState>(
            listener: (_, state) {
              if (state is f.FichLoadedState) {
                if (state.fichLines.isNotEmpty) {
                  setState(() {
                    sumFich = state.fichLines.map((e) => e.fichLineNettotal).toList().reduce((value, element) => value + element);
                  });
                } else {
                  setState(() {
                    sumFich = 0;
                  });
                }
              } else if (state is f.LoadedWithFichDelete) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DeleteFichLinesScreen(
                      fichLine: state.fichLine,
                      table: widget.table,
                      salesman: state.salesman,
                    ),
                  ),
                );
                BlocProvider.of<f.FichBloc>(context).add(f.LoadEvent(widget.table.fichId));
              } else if (state is f.LoadedRejects) {
                BlocProvider.of<t.TableBloc>(context).add(t.LoadEvent());
                Navigator.pop(context);
              } else if (state is f.LoadedWithMessageState) {
                if (state.fichLines.isNotEmpty) {
                  setState(() {
                    sumFich = state.fichLines.map((e) => e.fichLineNettotal).toList().reduce((value, element) => value + element);
                  });
                } else {
                  setState(() {
                    sumFich = 0;
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is f.NewLoadedState) {
                BlocProvider.of<t.TableBloc>(context).add(t.LoadEvent());
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CashSreen(
                    fichLines: state.fichLines,
                    table: widget.table,
                    salesman: state.salesman,
                    address: state.address,
                    firmName: state.firmName,
                    phone: state.phone,
                  ),
                ));
              }
            },
            builder: (_, state) {
              if (state is f.FichLoadedState) {
                salesman = state.salesman;
                return buildFichLines(state.fichLines, state.salesman);
              } else if (state is f.LoadedWithFichDelete) {
                salesman = state.salesman;
                return buildFichLines(state.fichLines, state.salesman);
              } else if (state is f.LoadingState) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    child: Center(child: Text(trs.translate('loading') ?? 'loading')),
                  ),
                );
              } else if (state is f.LoadedWithMessageState) {
                if (state.fichLines.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).primaryColorLight,
                      ),
                      child: Center(child: Text(trs.translate('no_fich_line') ?? 'no_fich_line')),
                    ),
                  );
                }
                return buildFichLines(state.fichLines, state.salesman);
              }
              return SliverToBoxAdapter(
                child: Container(
                  height: 10,
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Divider(thickness: 4),
            ),
          ),
          BlocConsumer<MaterialBloc, MaterialBlocState>(
            listener: (_, state) {
              if (state is ReportState) {
                BlocProvider.of<t.TableBloc>(context).add(t.LoadEvent());
                Navigator.pop(context);
              } else if (state is LoadedState) {
                if (state.cartItems.isNotEmpty) {
                  setState(() {
                    sumCart = state.cartItems.map((e) => e.count * e.material.salePrice).toList().reduce((value, element) => value + element);
                  });
                } else {
                  setState(() {
                    sumCart = 0;
                  });
                }
              } else if (state is LoadedWithMessageState) {
                if (state.cartItems.isNotEmpty) {
                  setState(() {
                    sumCart = state.cartItems.map((e) => e.count * e.material.salePrice).toList().reduce((value, element) => value + element);
                  });
                } else {
                  setState(() {
                    sumCart = 0;
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (_, state) {
              if (state is LoadedState) {
                return buildCartItems(state.cartItems);
              } else if (state is LoadedWithMessageState) {
                return buildCartItems(state.cartItems);
              } else if (state is ReportState) {
                return buildCartItems(state.cartItems);
              }
              return SliverToBoxAdapter(
                child: Container(child: Text('Unknown')),
              );
            },
          ),
        ],
      ),
    );

    Widget header = Container(
      height: widget.headerHeight,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: TextButton(
              onPressed: () async {
                bool result = await askToConfirmDialog('confirm_order');
                if (result == true) {
                  widget.table = widget.table.copyWith(
                      arapId: widget.table.arapId,
                      fichId: widget.table.fichId,
                      fichCode: widget.table.fichCode,
                      tableName: widget.table.tableName,
                      fichTotal: widget.table.fichTotal,
                      fichNetTotal: widget.table.fichNetTotal,
                      speCode: (speCode.isNotEmpty) ? speCode : null,
                      securityCode: (securityCode.isNotEmpty) ? securityCode : null,
                      groupCode: (groupCode.isNotEmpty) ? groupCode : null,
                      invDesc: (invDesc.isNotEmpty) ? invDesc : null);
                  BlocProvider.of<MaterialBloc>(context).add(InsertFichLines(table: widget.table));
                }
              },
              child: Column(
                children: [
                  Icon(
                    Icons.restaurant,
                    color: Theme.of(context).primaryColorDark,
                    size: 25,
                  ),
                  Container(
                    height: 9,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        trs.translate('order') ?? 'order',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: TextButton(
              onPressed: () async {
                debugPrint("DescButton pressed");
                showTextFieldDialog(context, (String invDesc, String speCode, String groupCode, String securityCode, String lineDesc) {
                  BlocProvider.of<MaterialBloc>(context).add(SetDescription(fichLineDesc: lineDesc));
                }, trs, txt, false);
              },
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColorDark,
                    size: 25,
                  ),
                  Container(
                    height: 9,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        trs.translate('description') ?? 'Description',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '${trs.translate("sum") ?? "sum"}: ${sumFich.toStringAsFixed(2)} + ${sumCart.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 50,
            margin: const EdgeInsets.fromLTRB(2.0, 2.0, 8.0, 2.0),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isOpened ? Icons.arrow_downward : Icons.arrow_upward,
                color: Theme.of(context).primaryColorLight,
              ),
              onPressed: () async {
                if (isOpened) {
                  await panelController.animatePanelToPosition(0);
                } else {
                  await panelController.animatePanelToPosition(1.0);
                }
              },
            ),
          ),
        ],
      ),
    );

    return SlidingUpPanel(
      onPanelClosed: () {
        setState(() {
          if (isOpened) isOpened = false;
        });
      },
      onPanelOpened: () {
        setState(() {
          if (!isOpened) isOpened = true;
        });
      },
      controller: panelController,
      borderRadius: BorderRadius.circular(15),
      minHeight: widget.headerHeight,
      maxHeight: 600,
      header: header,
      panel: panel,
      body: widget.child,
    );
  }
}
