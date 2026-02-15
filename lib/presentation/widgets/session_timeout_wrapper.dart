import 'dart:async';
import 'package:afric/presentation/blocs/account/account_bloc.dart';
import 'package:afric/presentation/blocs/account/account_event.dart';
import 'package:afric/presentation/blocs/auth/auth_bloc.dart';
import 'package:afric/presentation/blocs/auth/auth_event.dart';
import 'package:afric/presentation/blocs/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionTimeoutWrapper extends StatefulWidget {
  final Widget child;
  final Duration timeout;

  const SessionTimeoutWrapper({
    super.key,
    required this.child,
    this.timeout = const Duration(minutes: 5),
  });

  @override
  State<SessionTimeoutWrapper> createState() => _SessionTimeoutWrapperState();
}

class _SessionTimeoutWrapperState extends State<SessionTimeoutWrapper> {
  Timer? _timer;

  void _resetTimer() {
    _timer?.cancel();
    // Only start timer if user is authenticated
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _timer = Timer(widget.timeout, _handleTimeout);
    }
  }

  void _handleTimeout() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
    context.read<AccountBloc>().add(AccountReset());
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _resetTimer();
        } else {
          _timer?.cancel();
        }
      },
      child: Listener(
        onPointerDown: (_) => _resetTimer(),
        onPointerMove: (_) => _resetTimer(),
        onPointerUp: (_) => _resetTimer(),
        child: widget.child,
      ),
    );
  }
}
