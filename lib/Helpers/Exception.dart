import 'package:equatable/equatable.dart';

class CustomException extends Equatable implements Exception {
  @override
  List<Object> get props {
    return [];
  }
}

class UserNotFounException extends CustomException {}
class TableNotFounException extends CustomException {}
class DeviceNotFounException extends CustomException {}
class DbSettingsRequiredException extends CustomException {}
