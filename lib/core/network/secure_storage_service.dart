import 'dart:convert';
import 'package:afric/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_details';

  SecureStorageService(this._storage);

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: userJson);
  }

  Future<UserModel?> getUser() async {
    final userJson = await _storage.read(key: _userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null;
  }
}
