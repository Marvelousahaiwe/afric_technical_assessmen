// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:afric/core/di/modules.dart' as _i485;
import 'package:afric/core/network/dio_client.dart' as _i1030;
import 'package:afric/core/network/secure_storage_service.dart' as _i569;
import 'package:afric/data/datasources/banking_remote_data_source.dart'
    as _i195;
import 'package:afric/data/repositories/banking_repository.dart' as _i695;
import 'package:afric/presentation/blocs/account/account_bloc.dart' as _i265;
import 'package:afric/presentation/blocs/auth/auth_bloc.dart' as _i242;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => registerModule.storage);
    gh.lazySingleton<_i569.SecureStorageService>(
      () => _i569.SecureStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i1030.DioClient>(
      () => _i1030.DioClient(gh<_i361.Dio>(), gh<_i569.SecureStorageService>()),
    );
    gh.lazySingleton<_i195.BankingRemoteDataSource>(
      () => _i195.BankingRemoteDataSourceImpl(gh<_i1030.DioClient>()),
    );
    gh.lazySingleton<_i695.BankingRepository>(
      () => _i695.BankingRepositoryImpl(
        gh<_i195.BankingRemoteDataSource>(),
        gh<_i569.SecureStorageService>(),
      ),
    );
    gh.factory<_i265.AccountBloc>(
      () => _i265.AccountBloc(gh<_i695.BankingRepository>()),
    );
    gh.factory<_i242.AuthBloc>(
      () => _i242.AuthBloc(gh<_i695.BankingRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i485.RegisterModule {}
