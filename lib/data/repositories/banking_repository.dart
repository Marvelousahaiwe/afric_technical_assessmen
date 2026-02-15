import 'package:afric/core/network/secure_storage_service.dart';
import 'package:afric/data/datasources/banking_remote_data_source.dart';
import 'package:afric/data/models/account_model.dart';
import 'package:afric/data/models/auth_response_model.dart';
import 'package:afric/data/models/user_model.dart';

import 'package:injectable/injectable.dart';

abstract class BankingRepository {
  Future<AuthResponseModel> register(
    String name,
    String email,
    String password,
    String currency,
  );
  Future<AuthResponseModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getUser({bool forceRefresh = false});
  Future<AccountModel> credit(double amount);
  Future<AccountModel> debit(double amount);
}

@LazySingleton(as: BankingRepository)
class BankingRepositoryImpl implements BankingRepository {
  final BankingRemoteDataSource _remoteDataSource;
  final SecureStorageService _storageService;

  BankingRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<AuthResponseModel> register(
    String name,
    String email,
    String password,
    String currency,
  ) async {
    try {
      final response = await _remoteDataSource.register(
        name,
        email,
        password,
        currency,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _remoteDataSource.login(email, password);
      await _storageService.saveToken(response.authorization!.token!);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
      await _storageService.clearAll();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cachedUser = await _storageService.getUser();
        if (cachedUser != null) return cachedUser;
      }

      final user = await _remoteDataSource.getUser();
      await _storageService.saveUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AccountModel> credit(double amount) async {
    try {
      final account = await _remoteDataSource.credit(amount);
      await getUser(forceRefresh: true); // Force Sync local user/balance
      return account;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AccountModel> debit(double amount) async {
    try {
      final account = await _remoteDataSource.debit(amount);
      await getUser(forceRefresh: true); // Force Sync local user/balance
      return account;
    } catch (e) {
      rethrow;
    }
  }
}
