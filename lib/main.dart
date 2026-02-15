import 'package:afric/core/di/injection.dart';
import 'package:afric/core/theme/app_theme.dart';
import 'package:afric/presentation/blocs/account/account_bloc.dart';
import 'package:afric/presentation/blocs/auth/auth_bloc.dart';
import 'package:afric/presentation/blocs/auth/auth_event.dart';
import 'package:afric/presentation/pages/login_page.dart';
import 'package:afric/presentation/widgets/session_timeout_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => getIt<AccountBloc>()),
      ],
      child: MaterialApp(
        title: 'Banking App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        builder: (context, child) {
          return SessionTimeoutWrapper(child: child ?? const SizedBox.shrink());
        },
        home: const LoginPage(),
      ),
    );
  }
}
