import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:mobile_resto_agent/data/local/FromHiveBox.dart';
import 'package:mobile_resto_agent/model/appLanguage.dart';
import 'package:mobile_resto_agent/model/printerAddress.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region Events

class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class NewUrlEvent extends SettingsEvent {
  final String baseUrl;

  NewUrlEvent(this.baseUrl);

  @override
  List<Object> get props => [baseUrl];
}

class NewPrintType extends SettingsEvent {
  final int selectedPrintType;

  NewPrintType(this.selectedPrintType);

  @override
  List<Object> get props => [selectedPrintType];
}

class NewDbConnectionType extends SettingsEvent {
  final int selectedDbConnectionType;

  NewDbConnectionType(this.selectedDbConnectionType);

  @override
  List<Object> get props => [selectedDbConnectionType];
}

class NewCashPrinterEvent extends SettingsEvent {
  final String ip;
  final String port;

  NewCashPrinterEvent({required this.ip, required this.port});

  List<Object> get props => [ip, port];
}

class NewDefaultPrinterEvent extends SettingsEvent {
  final String ip;
  final String port;

  NewDefaultPrinterEvent({required this.ip, required this.port});

  List<Object> get props => [ip, port];
}

class NewPrinterEvent extends SettingsEvent {
  final String ip;
  final String port;

  NewPrinterEvent({required this.ip, required this.port});

  List<Object> get props => [ip, port];
}

class RemovePrinterEvent extends SettingsEvent {
  final PrinterAddress address;

  RemovePrinterEvent({required this.address});

  List<Object> get props => [address];
}

class NewAddressEvent extends SettingsEvent {
  final String address;

  NewAddressEvent({required this.address});

  List<Object> get props => [address];
}

class NewSocketAddressEvent extends SettingsEvent {
  final String socketAddress;

  NewSocketAddressEvent({required this.socketAddress});

  List<Object> get props => [socketAddress];
}

class NewDbNameEvent extends SettingsEvent {
  final String dbName;

  NewDbNameEvent(this.dbName);

  List<Object> get props => [dbName];
}

class NewDbUNameEvent extends SettingsEvent {
  final String dbUName;

  NewDbUNameEvent(this.dbUName);

  List<Object> get props => [dbUName];
}

class NewDbUPassEvent extends SettingsEvent {
  final String dbUPass;

  NewDbUPassEvent(this.dbUPass);

  List<Object> get props => [dbUPass];
}

class NewPhoneNumberEvent extends SettingsEvent {
  final String number;

  NewPhoneNumberEvent({required this.number});

  List<Object> get props => [number];
}

//endregion Events

//region States
class SettingsState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadingSettingsState extends SettingsState {}

class SettingsLoadedState extends SettingsState {
  final List<AppLanguage> _languages;
  final String baseUrl;
  final PrinterAddress defaultPrinter;
  final PrinterAddress cashPrinter;
  final List<PrinterAddress> printers;
  final String phoneNumber;
  final String address;
  final String version;
  final int selectedPrintType;
  final String socketAddress;
  final int selectedDbConnectionType;
  final String dbName;
  final String dbUName;
  final String dbUPass;

  SettingsLoadedState(this._languages,
      {required this.baseUrl,
      required this.defaultPrinter,
      required this.cashPrinter,
      required this.printers,
      required this.address,
      required this.phoneNumber,
      required this.version,
      required this.selectedPrintType,
      required this.socketAddress,
      required this.dbName,
      required this.dbUName,
      required this.dbUPass,
      required this.selectedDbConnectionType});

  List<AppLanguage> get getAppLanguages => _languages;

  int get getSelectedPrintType => selectedPrintType;

  String get getSocketAddress => socketAddress;

  @override
  List<Object> get props => [
        _languages,
        baseUrl,
        defaultPrinter,
        cashPrinter,
        printers,
        address,
        phoneNumber,
        version,
        selectedPrintType,
        socketAddress,
        dbName,
        dbUPass,
        dbUName,
        selectedDbConnectionType
      ];
}

//endregion States

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(LoadingSettingsState());
  FromHive hive = FromHive();

  @override
  void onTransition(Transition<SettingsEvent, SettingsState> transition) {
    super.onTransition(transition);
    print(transition);
  }

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    final _sharedPref = await SharedPreferences.getInstance();
    if (event is LoadSettingsEvent) {
      yield* _mapLoadSettingsToState();
    } else if (event is NewUrlEvent) {
      _sharedPref.setString(SharedPrefKeys.baseUrl, event.baseUrl);
      yield* _mapLoadSettingsToState();
    } else if (event is NewCashPrinterEvent) {
      PrinterAddress printer = PrinterAddress(ip: event.ip, port: event.port);
      _sharedPref.setString(SharedPrefKeys.cashPrinter, printer.toJson());
      yield* _mapLoadSettingsToState();
    } else if (event is NewDefaultPrinterEvent) {
      PrinterAddress printer = PrinterAddress(ip: event.ip, port: event.port);
      _sharedPref.setString(SharedPrefKeys.defaultPrinter, printer.toJson());
      yield* _mapLoadSettingsToState();
    } else if (event is NewAddressEvent) {
      _sharedPref.setString(SharedPrefKeys.address, event.address);
      yield* _mapLoadSettingsToState();
    } else if (event is NewPrintType) {
      _sharedPref.setInt(SharedPrefKeys.selectedPrintType, event.selectedPrintType);
      yield* _mapLoadSettingsToState();
    } else if (event is NewPhoneNumberEvent) {
      _sharedPref.setString(SharedPrefKeys.phoneNumber, event.number);
      yield* _mapLoadSettingsToState();
    } else if (event is NewSocketAddressEvent) {
      _sharedPref.setString(SharedPrefKeys.socketAddress, event.socketAddress);
      yield* _mapLoadSettingsToState();
    } else if (event is NewDbConnectionType){
      _sharedPref.setInt(SharedPrefKeys.selectedDbConnectionType, event.selectedDbConnectionType);
      yield* _mapLoadSettingsToState();
    } else if (event is NewDbNameEvent){
      _sharedPref.setString(SharedPrefKeys.DbName, event.dbName);
      yield* _mapLoadSettingsToState();
    } else if (event is NewDbUNameEvent){
      _sharedPref.setString(SharedPrefKeys.DbUName, event.dbUName);
      yield* _mapLoadSettingsToState();
    } else if (event is NewDbUPassEvent){
      _sharedPref.setString(SharedPrefKeys.DbUPass, event.dbUPass);
      yield* _mapLoadSettingsToState();
    } else if (event is NewPrinterEvent) {
      List<PrinterAddress> printers;
      try {
        printers = await hive.getPrinterAddresses();
        printers.add(PrinterAddress(ip: event.ip, port: event.port));
      } catch (e) {
        print('Print hive settings get printer addresses error: $e');
        printers = [];
      }

      try {
        hive.putPrinterAdresses(printers);
      } catch (e) {
        print('Print hive settings put printer addresses error: $e');
      }
      yield* _mapLoadSettingsToState();
    } else if (event is RemovePrinterEvent) {
      List<PrinterAddress> printers;
      try {
        printers = await hive.getPrinterAddresses();
        printers.removeWhere(
          (element) => element == event.address,
        );
      } catch (e) {
        print('Print hive settings get printer addresses error: $e');
        printers = [];
      }

      try {
        hive.putPrinterAdresses(printers);
      } catch (e) {
        print('Print hive settings put printer addresses error: $e');
      }
      yield* _mapLoadSettingsToState();
    }
  }

  Stream<SettingsState> _mapLoadSettingsToState() async* {
    yield LoadingSettingsState();

    List<AppLanguage> appLanguages = [];
    final _sharedPref = await SharedPreferences.getInstance();
    String baseUrl = _sharedPref.getString(SharedPrefKeys.baseUrl) ?? SharedPrefKeys.defaultUrl;
    PrinterAddress cashPrinter;
    PrinterAddress defaultPrinter;
    String phoneNumber = _sharedPref.getString(SharedPrefKeys.phoneNumber) ?? '';
    String address = _sharedPref.getString(SharedPrefKeys.address) ?? '';
    String socketAddress = _sharedPref.getString(SharedPrefKeys.socketAddress) ?? '';
    int selectedPrintType = _sharedPref.getInt(SharedPrefKeys.selectedPrintType) ?? 0;
    int selectedDbConnectionType = _sharedPref.getInt(SharedPrefKeys.selectedDbConnectionType) ?? 0;
    String dbUName = _sharedPref.getString(SharedPrefKeys.DbUName) ?? SharedPrefKeys.defaultDbUName;
    String dbUPass = _sharedPref.getString(SharedPrefKeys.DbUPass) ?? '';
    String dbName = _sharedPref.getString(SharedPrefKeys.DbName) ?? SharedPrefKeys.defaultDbName;

    List<PrinterAddress> printers;
    String version = await getVersion();

    try {
      String? defaultJson = _sharedPref.getString(SharedPrefKeys.defaultPrinter);
      defaultPrinter = defaultJson != null ? PrinterAddress.fromJson(defaultJson) : PrinterAddress(ip: SharedPrefKeys.printerUrl, port: '9100');

      String? cahsJson = _sharedPref.getString(SharedPrefKeys.cashPrinter);
      cashPrinter = cahsJson != null ? PrinterAddress.fromJson(cahsJson) : PrinterAddress(ip: SharedPrefKeys.cashUrl, port: '9100');
    } catch (e) {
      print('Print sharedPreference settings get printer addresses error: $e');
      defaultPrinter = PrinterAddress(ip: SharedPrefKeys.printerUrl, port: '9100');
      cashPrinter = PrinterAddress(ip: SharedPrefKeys.cashUrl, port: '9100');
    }

    try {
      printers = await hive.getPrinterAddresses();
    } catch (e) {
      print('Print hive settings get printer addresses error: $e');
      printers = [];
    }

    //region Languages
    appLanguages.add(AppLanguage('Türkmen', 'tk', 'TM'));
    appLanguages.add(AppLanguage('Русский', 'ru', 'RU'));
    appLanguages.add(AppLanguage('English', 'en', 'US'));

    //endregion Languages

    yield SettingsLoadedState(appLanguages,
        baseUrl: baseUrl,
        defaultPrinter: defaultPrinter,
        cashPrinter: cashPrinter,
        printers: printers,
        address: address,
        phoneNumber: phoneNumber,
        version: version,
        selectedPrintType: selectedPrintType,
        socketAddress: socketAddress,
        dbName: dbName,
        dbUName: dbUName,
        dbUPass: dbUPass,
        selectedDbConnectionType: selectedDbConnectionType);
  }
}
