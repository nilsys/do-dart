import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:do_api/api.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../services/auth_service.dart';
import '../models/auth_status.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required AuthService authService})
      : assert(authService != null),
        _authService = authService,
        super(const AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _authService.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  final AuthService _authService;
  StreamSubscription<AuthStatus> _authenticationStatusSubscription;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStatusChanged) {
      yield await _mapAuthenticationStatusChangedToState(event);
    } else if (event is AuthenticationLogoutRequested) {
      _authService.logOut();
    }
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription?.cancel();
    _authService.dispose();
    return super.close();
  }

  Future<AuthenticationState> _mapAuthenticationStatusChangedToState(
    AuthenticationStatusChanged event,
  ) async {
    switch (event.status) {
      case AuthStatus.unauthenticated:
        return const AuthenticationState.unauthenticated();
      case AuthStatus.authenticated:
        final user = await _tryGetUser();
        return user != null
            ? AuthenticationState.authenticated(user)
            : const AuthenticationState.unauthenticated();
      default:
        return const AuthenticationState.unknown();
    }
  }

  Future<OAuthResult> _tryGetUser() async {
    try {
      final user = OAuthResult.fromJson({});
      return user;
    } on Exception {
      return null;
    }
  }
}
