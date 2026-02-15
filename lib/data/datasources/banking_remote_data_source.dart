import 'package:afric/core/network/api_endpoints.dart';
import 'package:afric/core/network/dio_client.dart';
import 'package:afric/data/models/account_model.dart';
import 'package:afric/data/models/auth_response_model.dart';
import 'package:afric/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class BankingRemoteDataSource {
  Future<AuthResponseModel> register(
    String name,
    String email,
    String password,
    String currency,
  );
  Future<AuthResponseModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getUser();
  Future<AccountModel> credit(double amount);
  Future<AccountModel> debit(double amount);
}

@LazySingleton(as: BankingRemoteDataSource)
class BankingRemoteDataSourceImpl implements BankingRemoteDataSource {
  final DioClient _dioClient;

  BankingRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponseModel> register(
    String name,
    String email,
    String password,
    String currency,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'currency': currency,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.dio.post(
        ApiEndpoints.logout,
        options: Options(headers: {'Accept': 'application/json'}),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.user);
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  @override
  Future<AccountModel> credit(double amount) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.credit,
        data: {'amount': amount},
      );
      getUser();
      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  @override
  Future<AccountModel> debit(double amount) async {
    try {
      final response = await _dioClient.dio.post(
        ApiEndpoints.debit,
        data: {'amount': amount},
      );
      return AccountModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  dynamic _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final message = e.response?.data['message'];
      if (message != null) return message;
    }
    return e.message ?? 'An unexpected error occurred';
  }
}
