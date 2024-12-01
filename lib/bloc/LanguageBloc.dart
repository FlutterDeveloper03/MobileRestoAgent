import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_resto_agent/Helpers/SharedPrefKeys.dart';
import 'package:shared_preferences/shared_preferences.dart';

//region Events
class LanguageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LanguageLoadStarted extends LanguageEvent {}

class LanguageSelected extends LanguageEvent {
  final String languageCode;

  LanguageSelected(this.languageCode) : assert(languageCode.isNotEmpty);

  @override
  List<Object> get props => [languageCode];
}
//endRegion Events

//region States

class LanguageState extends Equatable {
  final Locale locale;
  const LanguageState(this.locale);

  @override
  List<Object> get props => [locale];
}

//endRegion

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  String loadedLanguageCode = "tk";

  LanguageBloc() : super(LanguageState(Locale('tk', 'TM')));

  @override
  Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
    if (event is LanguageLoadStarted) {
      yield* _mapLanguageLoadStartedToState();
    } else if (event is LanguageSelected) {
      yield* _mapLanguageSelectedToState(event.languageCode);
    }
  }

  Stream<LanguageState> _mapLanguageSelectedToState(
      String selectedLanguage) async* {
    final _sharedPref = await SharedPreferences.getInstance();
    loadedLanguageCode =
        _sharedPref.getString(SharedPrefKeys.languageCode) ?? "tk";

    if (selectedLanguage == 'en' && loadedLanguageCode != 'en') {
      yield* _loadLanguage(_sharedPref, 'en', 'US');
    } else if (selectedLanguage == 'ru' && loadedLanguageCode != 'ru') {
      yield* _loadLanguage(_sharedPref, 'ru', 'RU');
    } else if (selectedLanguage == 'tk' && loadedLanguageCode != 'tk') {
      yield* _loadLanguage(_sharedPref, 'tk', 'TM');
    }
  }

  Stream<LanguageState> _mapLanguageLoadStartedToState() async* {
    final _sharedPref = await SharedPreferences.getInstance();
    loadedLanguageCode =
        _sharedPref.getString(SharedPrefKeys.languageCode) ?? "tk";

    Locale locale;

    if (loadedLanguageCode.isEmpty) {
      locale = Locale('ru', 'RU');
      await _sharedPref.setString(
          SharedPrefKeys.languageCode, locale.languageCode);
    } else {
      locale = Locale(loadedLanguageCode);
    }

    yield LanguageState(locale);
  }

  Stream<LanguageState> _loadLanguage(SharedPreferences sharedPreferences,
      String languageCode, String countryCode) async* {
    final locale = Locale(languageCode, countryCode);
    await sharedPreferences.setString(
        SharedPrefKeys.languageCode, locale.languageCode);
    yield LanguageState(locale);
  }
}
