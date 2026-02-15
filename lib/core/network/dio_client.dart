import 'package:afric/core/network/api_endpoints.dart';
import 'package:afric/core/network/secure_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioClient {
  final Dio _dio;
  final SecureStorageService _storageService;

  DioClient(this._dio, this._storageService) {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null) {
            if (kDebugMode) {
              print('Adding Authorization header: Bearer $token');
            }
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          // Handle common errors like 401 Unauthorized
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
