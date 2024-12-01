import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* === === === === === === === === STATES === === === === === === === === */

abstract class CashierState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmptyState extends CashierState {}

class LoadingState extends CashierState {}

class LoadedState extends CashierState {
  // final PrinterCashier cash;
  // LoadedState({required this.cash});
}

/* === === === === === === === === Events === === === === === === === === */

abstract class CashierEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddCashierEvent extends CashierEvent {
  // final List<PrinterCashier> cash;
  // AddCashierEvent({required this.cash});
}

class RefreshEvent extends CashierEvent {}

/*  === === === === === === === === BLoC === === === === === === === === */

class CashierBloc extends Bloc<CashierEvent, CashierState> {
  CashierBloc() : super(EmptyState());

  Stream<CashierState> mapEventToState(CashierEvent event) async* {}
}
