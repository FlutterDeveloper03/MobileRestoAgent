import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:mobile_resto_agent/bloc/CategoryBloc.dart' as c;
import 'package:mobile_resto_agent/bloc/MaterialBloc.dart';
import 'package:mobile_resto_agent/bloc/RejectBloc.dart';
import 'package:mobile_resto_agent/bloc/ReportBloc.dart';
import 'package:mobile_resto_agent/bloc/SalesmansBloc.dart';
import 'package:mobile_resto_agent/bloc/SettingsBloc.dart';
import 'package:mobile_resto_agent/bloc/TableBloc.dart';
import 'package:mobile_resto_agent/bloc/TableCategoryBloc.dart';
import 'package:mobile_resto_agent/model/imageModel.dart';
import 'package:mobile_resto_agent/screens/LoginScreen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'bloc/LanguageBloc.dart';
import 'Helpers/localization.dart';
import 'bloc/LoginBloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    final path = await path_provider.getApplicationDocumentsDirectory();
    print('Print path is ' + path.path);
    Hive..init(path.path);
  }
  await Hive.openBox('menu');
  Hive.registerAdapter(ImageModelAdapter());
  await Hive.openBox('images');

  runApp(
    MultiBlocProvider(
      providers: [
        // LoginBloc for salesman login, waiter login with name and password
        BlocProvider(
          create: (_) => LoginBloc(),
        ),
        // LanguageBloc for localization
        BlocProvider(
          create: (_) => LanguageBloc()..add(LanguageLoadStarted()),
        ),
        // SettingsBloc for loading settings and sharedpreference things
        BlocProvider(
          create: (_) => SettingsBloc()..add(LoadSettingsEvent()),
        ),
        // TableBloc for loading tables(saleDiscCards with arap)
        BlocProvider(
          create: (_) => TableBloc()..add(LoadEvent()),
        ),
        // CategoryBloc for Loading Categories(with all preference)
        // CategoryBloc is must for MaterialBloc
        BlocProvider(
          create: (_) => c.CategoryBloc()..add(c.LoadEvent()),
        ),
        BlocProvider(
          create: (_) => MaterialBloc()..add(GetMaterialEvent()),
        ),
        // ReportBloc is for loading orders check data
        BlocProvider(
          create: (_) => ReportBloc(),
        ),
        // RejectBloc is for loading order reject data
        BlocProvider(
          create: (_) => RejectBloc(),
        ),
        BlocProvider(
          create: (_) => TableCategoryBloc()..add(LoadTableCategoriesEvent()),
        ),
        BlocProvider(
          create: (_) => SalesmansBloc()..add(LoadSalesmansEvent()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return MaterialApp(
          title: 'Mobile Resto Agent',
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.grey,
            primaryColor: Colors.black,
            primaryColorDark: Colors.grey.shade700,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.black,
              secondary: Colors.orange,
            ),
            cardColor: Colors.grey,
            primaryColorLight: Colors.black54,
            scaffoldBackgroundColor: Colors.grey.shade900,
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
          ),
          locale: languageState.locale,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            TkMaterialLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ru', 'RU'),
            Locale('tk', 'TM'),
          ],
          // home: MainScreen(),
          home: LoginScreen(),
        );
      },
    );
  }
}
