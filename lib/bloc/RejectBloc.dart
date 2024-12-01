/* === === === === === === === === STATES === === === === === === === === */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/model/printerReject.dart';

abstract class RejectState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyState extends RejectState {}

class LoadingState extends RejectState {}

class LoadedState extends RejectState {
  final PrinterReject reject;
  LoadedState({required this.reject});
}

/* === === === === === === === === Events === === === === === === === === */

abstract class RejectEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddRejectEvent extends RejectEvent {
  final List<PrinterReject> rejects;
  AddRejectEvent({required this.rejects});
}

class NextRejectEvent extends RejectEvent {}

class RefreshEvent extends RejectEvent {}

/* === === === === === === === === BLoC === === === === === === === === */

class RejectBloc extends Bloc<RejectEvent, RejectState> {
  RejectBloc() : super(EmptyState());
  List<PrinterReject> rejects = [];

  Stream<RejectState> mapEventToState(RejectEvent event) async* {
    if (event is AddRejectEvent) {
      yield LoadingState();
      rejects = event.rejects;
      print('Print reject ip address:${rejects.first.printer.ip}');
      print('Print rejects.length:${rejects.length}');
      if (rejects.isNotEmpty) {
        PrinterReject reject = rejects.first;
        print('Print reject LoadedState was yielded');
        yield LoadedState(reject: reject);
      } else {
        yield EmptyState();
      }
    } else if (event is NextRejectEvent) {
      yield LoadingState();
      if (rejects.isNotEmpty) {
        rejects.removeAt(0);
        print('Print reject length:${rejects.length}');
      }
      if (rejects.isNotEmpty) {
        PrinterReject report = rejects.first;
        print('Print reject:${report.printer.ip}');
        print('Print reject:${report.fichLines.length}');
        print('Print reject:${report.fichLines.first.materialName}');
        yield LoadedState(reject: report);
      } else {
        yield EmptyState();
      }
    } else if (event is RefreshEvent) {
      yield LoadingState();
      if (rejects.isNotEmpty) {
        PrinterReject report = rejects.first;
        print('Print reject:${report.printer.ip}');
        yield LoadedState(reject: report);
      } else {
        yield EmptyState();
      }
    }
  }
}
