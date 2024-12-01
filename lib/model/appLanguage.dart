import 'package:equatable/equatable.dart';

class AppLanguage extends Equatable {
  final String langName;
  final String langCode;
  final String countryCode;
  // final Icon langIcon;

  AppLanguage(this.langName, this.langCode, this.countryCode);

  @override
  List<Object> get props => [langCode, langName, countryCode];
}
