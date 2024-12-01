import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/model/printerReport.dart';

/* === === === === === === === === STATES === === === === === === === === */

abstract class ReportState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyState extends ReportState {}

class LoadingState extends ReportState {}

class LoadedState extends ReportState {
  final PrinterReport report;
  LoadedState({required this.report});
}

/* === === === === === === === === Events === === === === === === === === */

abstract class ReportEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddReportEvent extends ReportEvent {
  final List<PrinterReport> reports;
  AddReportEvent({required this.reports});
}

class NextReportEvent extends ReportEvent {}

class RefreshEvent extends ReportEvent {}

/* === === === === === === === === BLoC === === === === === === === === */

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(EmptyState());
  List<PrinterReport> reports = [];

  Stream<ReportState> mapEventToState(ReportEvent event) async* {
    if (event is AddReportEvent) {
      yield LoadingState();
      reports = event.reports;
      if (reports.isNotEmpty) {
        PrinterReport report = reports.first;
        yield LoadedState(report: report);
      } else {
        yield EmptyState();
      }
    } else if (event is NextReportEvent) {
      yield LoadingState();
      if (reports.isNotEmpty) {
        reports.removeAt(0);
      }
      if (reports.isNotEmpty) {
        PrinterReport report = reports.first;
        yield LoadedState(report: report);
      } else {
        yield EmptyState();
      }
    } else if (event is RefreshEvent) {
      yield LoadingState();
      if (reports.isNotEmpty) {
        PrinterReport report = reports.first;
        yield LoadedState(report: report);
      } else {
        yield EmptyState();
      }
    }
  }
}
