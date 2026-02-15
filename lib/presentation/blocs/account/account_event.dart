import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class AccountFetchRequested extends AccountEvent {}

class AccountCreditRequested extends AccountEvent {
  final double amount;

  const AccountCreditRequested(this.amount);

  @override
  List<Object> get props => [amount];
}

class AccountDebitRequested extends AccountEvent {
  final double amount;

  const AccountDebitRequested(this.amount);

  @override
  List<Object> get props => [amount];
}

class AccountReset extends AccountEvent {}
