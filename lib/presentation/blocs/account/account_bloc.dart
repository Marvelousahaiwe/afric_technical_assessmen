import 'package:afric/data/models/account_model.dart';
import 'package:afric/data/repositories/banking_repository.dart';
import 'package:afric/presentation/blocs/account/account_event.dart';
import 'package:afric/presentation/blocs/account/account_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final BankingRepository _repository;

  AccountBloc(this._repository) : super(AccountInitial()) {
    on<AccountFetchRequested>(_onFetchRequested);
    on<AccountCreditRequested>(_onCreditRequested);
    on<AccountDebitRequested>(_onDebitRequested);
    on<AccountReset>(_onReset);
  }

  void _onReset(AccountReset event, Emitter<AccountState> emit) {
    emit(AccountInitial());
  }

  Future<void> _onFetchRequested(
    AccountFetchRequested event,
    Emitter<AccountState> emit,
  ) async {
    try {
      final account = await _repository.getUser(forceRefresh: true);
      emit(AccountSuccess(account.user!.account!, transactions: []));
    } catch (e) {
      emit(AccountFailure(e.toString()));
    }
  }

  Future<void> _onCreditRequested(
    AccountCreditRequested event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    List<AccountJournal> currentTransactions = [];
    if (currentState is AccountSuccess) {
      currentTransactions = List.from(currentState.transactions);
    }

    emit(AccountLoading());
    try {
      final response = await _repository.credit(event.amount);
      final user = await _repository.getUser(forceRefresh: true);

      if (response.accountJournal != null) {
        currentTransactions.insert(0, response.accountJournal!);
      }

      emit(
        AccountSuccess(user.user!.account!, transactions: currentTransactions),
      );
    } catch (e) {
      emit(AccountFailure(e.toString()));
    }
  }

  Future<void> _onDebitRequested(
    AccountDebitRequested event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    List<AccountJournal> currentTransactions = [];
    if (currentState is AccountSuccess) {
      currentTransactions = List.from(currentState.transactions);
    }

    emit(AccountLoading());
    try {
      final response = await _repository.debit(event.amount);
      final user = await _repository.getUser(forceRefresh: true);

      if (response.accountJournal != null) {
        currentTransactions.insert(0, response.accountJournal!);
      }

      emit(
        AccountSuccess(user.user!.account!, transactions: currentTransactions),
      );
    } catch (e) {
      emit(AccountFailure(e.toString()));
    }
  }
}
