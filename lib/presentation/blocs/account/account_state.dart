import 'package:afric/data/models/account_model.dart';
import 'package:afric/data/models/user_model.dart';

import 'package:equatable/equatable.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountSuccess extends AccountState {
  final Account account;
  final List<AccountJournal> transactions;

  const AccountSuccess(this.account, {this.transactions = const []});

  @override
  List<Object?> get props => [account, transactions];
}

class AccountFailure extends AccountState {
  final String message;

  const AccountFailure(this.message);

  @override
  List<Object?> get props => [message];
}
