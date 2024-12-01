import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/bloc/LanguageBloc.dart';
import 'package:mobile_resto_agent/bloc/SettingsBloc.dart';
import 'package:mobile_resto_agent/model/appLanguage.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:mobile_resto_agent/widgets/cBackButton.dart';
import 'package:mobile_resto_agent/widgets/printerAddress.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  showTextFieldDialog(BuildContext context, String text, AppLocalizations trs, SettingsEvent event, {bool obscureText = false})
  {
    showDialog(
      context: context,
      builder: (context) {
        String hint = '';
        late TextInputType type;
        if (event is NewUrlEvent) {
          hint = 'ip_address';
          type = TextInputType.number;
        } else if (event is NewAddressEvent) {
          hint = 'locale_address';
          type = TextInputType.streetAddress;
        } else if (event is NewPhoneNumberEvent) {
          hint = 'phone_number';
          type = TextInputType.phone;
        } else if (event is NewSocketAddressEvent) {
          hint = trs.translate('socket_address') ?? 'Socket address';
          type = TextInputType.text;
        } else if (event is NewDbNameEvent) {
          hint = trs.translate('dbName') ?? 'Database name';
          type = TextInputType.text;
        } else if (event is NewDbUNameEvent) {
          hint = trs.translate('server_u_name') ?? 'User name';
          type = TextInputType.text;
        } else if (event is NewDbUPassEvent) {
          hint = trs.translate('server_u_pass') ?? 'Password';
          type = TextInputType.text;
        }
        TextEditingController controller = TextEditingController(
          text: text,
        );
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
                    controller: controller,
                    obscureText: obscureText,
                    keyboardType: type,
                    inputFormatters: [
                      if (event is NewSocketAddressEvent || event is NewUrlEvent) FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[.:]*')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => newValue.copyWith(
                          text: newValue.text.replaceAll(',', '.'),
                        ),
                      )
                    ],
                    decoration: InputDecoration(
                      hintText: trs.translate(hint),
                      hintStyle: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        (event is NewAddressEvent)
                            ? Icons.location_on_outlined
                            : (event is NewUrlEvent || event is NewSocketAddressEvent)
                                ? Icons.lan
                                : (event is NewDbNameEvent)
                                    ? Icons.title
                                    : (event is NewDbUNameEvent)
                                        ? Icons.account_box
                                        : (event is NewDbUPassEvent)
                                            ? Icons.password
                                            : Icons.description,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                  onPressed: () {
                    if (controller.text.isNotEmpty && event is NewUrlEvent) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        NewUrlEvent(controller.text),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    } else if (controller.text.isNotEmpty && event is NewAddressEvent) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        NewAddressEvent(address: controller.text),
                      );
                      Navigator.pop(context);
                    } else if (controller.text.isNotEmpty && event is NewSocketAddressEvent) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        NewSocketAddressEvent(socketAddress: controller.text),
                      );
                      Navigator.pop(context);
                    } else if (controller.text.isNotEmpty && event is NewPhoneNumberEvent) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        NewPhoneNumberEvent(number: controller.text),
                      );
                      Navigator.pop(context);
                    } else if (controller.text.isNotEmpty && event is NewDbNameEvent) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        NewDbNameEvent(controller.text),
                      );
                      Navigator.pop(context);
                    } else if (controller.text.isNotEmpty && event is NewDbUNameEvent) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        NewDbUNameEvent(controller.text),
                      );
                      Navigator.pop(context);
                    } else if (controller.text.isNotEmpty && event is NewDbUPassEvent) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        NewDbUPassEvent(controller.text),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(trs.translate('save') ?? 'save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  changePrinterAddress(BuildContext context,PrinterAddress address,AppLocalizations trs,SettingsEvent event,)
  {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController ipTextController = TextEditingController(
          text: address.ip,
        );
        TextEditingController portTextController = TextEditingController(
          text: address.port.isNotEmpty ? address.port : '9100',
        );
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
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Colors.white,
                        ),
                        child: TextField(
                          autofocus: true,
                          controller: ipTextController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: trs.translate('ip_address'),
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
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
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: portTextController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: trs.translate('port'),
                            hintStyle: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(
                              Icons.power_outlined,
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
                    ),
                  ],
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
                    if (ipTextController.text.isNotEmpty || portTextController.text.isNotEmpty) {
                      if (event is NewDefaultPrinterEvent) {
                        BlocProvider.of<SettingsBloc>(context).add(
                          NewDefaultPrinterEvent(
                            ip: ipTextController.text,
                            port: portTextController.text,
                          ),
                        );
                      } else if (event is NewCashPrinterEvent) {
                        BlocProvider.of<SettingsBloc>(context).add(
                          NewCashPrinterEvent(
                            ip: ipTextController.text,
                            port: portTextController.text,
                          ),
                        );
                      } else if (event is NewPrinterEvent) {
                        BlocProvider.of<SettingsBloc>(context).add(
                          NewPrinterEvent(
                            ip: ipTextController.text,
                            port: portTextController.text,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(trs.translate('save') ?? 'save'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _selectedPrintType = 0; //0=Direct Print, 1=Socket

  @override
  Widget build(BuildContext context) {
    final trs = AppLocalizations.of(context);
    final double height = MediaQuery.of(context).size.height;
    Future<bool> askToConfirmDialog(String text) async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                trs.translate(text) ?? text,
                style: Theme.of(context).textTheme.headline5,
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
          ) ??
          false);
    }

    return Scaffold(
      appBar: AppBar(
        leading: CBackButton(),
        leadingWidth: 80,
        title: Text(trs.translate('settings') ?? 'settings'),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is LoadingSettingsState) {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<SettingsBloc>(context).add(
                  LoadSettingsEvent(),
                );
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      alignment: Alignment.center,
                      height: height * 0.89,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SettingsLoadedState) {
            List<AppLanguage> langs = state.getAppLanguages;
            _selectedPrintType = state.getSelectedPrintType;
            AppLanguage lang =
                langs.firstWhere((element) => element.langCode == (BlocProvider.of<LanguageBloc>(context).state).locale.languageCode);
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<SettingsBloc>(context).add(
                  LoadSettingsEvent(),
                );
              },
              child: ListView(
                children: [
                  Container(
                    child: Column(
                      children: langs.map((e) {
                        return Container(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Radio<AppLanguage>(
                                value: e,
                                groupValue: lang,
                                onChanged: (AppLanguage? value) {
                                  BlocProvider.of<LanguageBloc>(context).add(
                                    LanguageSelected(value?.langCode ?? "tk"),
                                  );
                                },
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () {
                                BlocProvider.of<LanguageBloc>(context).add(
                                  LanguageSelected(e.langCode),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.langName.toString()),
                                    SvgPicture.asset(
                                      'assets/svgs/${e.countryCode.toLowerCase()}.svg',
                                      height: 25,
                                      width: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8.0),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    height: 50,
                    // padding: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'APP VERSION: ' + state.version,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          trs.translate('dbConnectionType') ?? 'Database connection type',
                          style: TextStyle(fontSize: 16),
                        ),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(trs.translate('dbConnectionTypeDirect') ?? 'Direct connection'),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Radio<int>(
                                    value: 0,
                                    groupValue: state.selectedDbConnectionType,
                                    onChanged: (int? value) {
                                      BlocProvider.of<SettingsBloc>(context).add(
                                        NewDbConnectionType(0),
                                      );
                                    },
                                  ),
                                ),
                                onTap: (){
                                  BlocProvider.of<SettingsBloc>(context).add(
                                      NewDbConnectionType(0));
                                },
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(trs.translate('dbConnectionTypeApi') ?? 'API'),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Radio<int>(
                                    value: 1,
                                    groupValue: state.selectedDbConnectionType,
                                    onChanged: (int? value) {
                                      BlocProvider.of<SettingsBloc>(context).add(
                                        NewDbConnectionType(1),
                                      );
                                    },
                                  ),
                                ),
                                onTap: (){
                                  BlocProvider.of<SettingsBloc>(context).add(
                                      NewDbConnectionType(1));
                                },
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            trs.translate('main_computer_ip') ?? 'main_computer_ip',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.5,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              showTextFieldDialog(
                                context,
                                state.baseUrl,
                                trs,
                                NewUrlEvent(''),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lan,
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      state.baseUrl.isNotEmpty ? state.baseUrl : '',
                                      textAlign: TextAlign.right,
                                      style: Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (state.selectedDbConnectionType == 0)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).cardColor,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      showTextFieldDialog(
                                        context,
                                        state.dbUName,
                                        trs,
                                        NewDbUNameEvent(''),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_box,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              state.dbUName.isNotEmpty ? state.dbUName : '',
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context).textTheme.headline6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).cardColor,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1.5,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      showTextFieldDialog(context, state.dbUPass, trs, NewDbUPassEvent(''), obscureText: true);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.password,
                                          color: Colors.black,
                                        ),
                                        Expanded(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              state.dbUPass.isNotEmpty ? state.dbUPass.replaceAll(RegExp(r"."), "*") : ' ',
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context).textTheme.headline6,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (state.selectedDbConnectionType == 0)
                          Container(
                            height: 50,
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                showTextFieldDialog(
                                  context,
                                  state.dbName,
                                  trs,
                                  NewDbNameEvent(''),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.title,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        state.dbName.isNotEmpty ? state.dbName : '',
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      trs.translate('locale_address') ?? 'locale_address',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          showTextFieldDialog(
                            context,
                            state.address,
                            trs,
                            NewAddressEvent(address: ''),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Text(
                                state.address.isEmpty ? 'empty' : state.address,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      trs.translate('phone_number') ?? 'phone_number',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1.5,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          showTextFieldDialog(
                            context,
                            state.phoneNumber,
                            trs,
                            NewPhoneNumberEvent(number: ''),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  state.phoneNumber.isEmpty ? 'empty' : state.phoneNumber,
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      trs.translate('printType') ?? 'Print type',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(trs.translate('printTypeDirect') ?? 'Direct print'),
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Radio<int>(
                                value: 0,
                                groupValue: state.getSelectedPrintType,
                                onChanged: (int? value) {
                                  BlocProvider.of<SettingsBloc>(context).add(
                                    NewPrintType(0),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(trs.translate('Socket') ?? 'Socket'),
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Radio<int>(
                                value: 1,
                                groupValue: state.getSelectedPrintType,
                                onChanged: (int? value) {
                                  BlocProvider.of<SettingsBloc>(context).add(
                                    NewPrintType(1),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (_selectedPrintType == 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            trs.translate('default_printer_ip') ?? 'default_printer_ip',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                changePrinterAddress(
                                  context,
                                  state.defaultPrinter,
                                  trs,
                                  NewDefaultPrinterEvent(
                                    ip: '',
                                    port: '',
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        state.defaultPrinter.ip + ':' + state.defaultPrinter.port,
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            trs.translate('cash_printer_ip') ?? 'cash_printer_ip',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                changePrinterAddress(
                                  context,
                                  state.cashPrinter,
                                  trs,
                                  NewCashPrinterEvent(
                                    ip: '',
                                    port: '',
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        state.cashPrinter.ip + ':' + state.cashPrinter.port,
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              trs.translate('printers') ?? 'printers',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1.5,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              changePrinterAddress(
                                context,
                                PrinterAddress(
                                  ip: '',
                                  port: '',
                                ),
                                trs,
                                NewPrinterEvent(
                                  ip: '',
                                  port: '',
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.black),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    trs.translate('add_printer_address') ?? 'add_printer_address',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemBuilder: (context, index) => CustomPrinterAddress(
                              address: state.printers[index],
                              delete: () async {
                                bool result = await askToConfirmDialog('do_you_want_to_delete');
                                if (result) {
                                  BlocProvider.of<SettingsBloc>(context).add(
                                    RemovePrinterEvent(
                                      address: state.printers[index],
                                    ),
                                  );
                                }
                              },
                            ),
                            itemCount: state.printers.length,
                          ),
                        )
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            trs.translate('socket_address') ?? 'Socket address',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).cardColor,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                showTextFieldDialog(
                                  context,
                                  state.socketAddress,
                                  trs,
                                  NewSocketAddressEvent(socketAddress: state.socketAddress),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        (state.socketAddress.length == 0) ? ' ' : state.socketAddress,
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<SettingsBloc>(context).add(
                  LoadSettingsEvent(),
                );
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      height: height * 0.9,
                      child: Center(
                        child: Text('Unkown Error'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
