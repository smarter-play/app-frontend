import 'package:app_frontend/io/http.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'models.dart';

class LoginResult {
  const LoginResult(this.token);
  final String token;
}

class Session extends StateNotifier<LoginResult?> {
  Session() : super(null);

  void logIn(LoginResult r) {
    setAuthHeader(r.token);
    state = r;
  }

  void logOut() {
    resetAuthHeaders();
    state = null;
  }
}

final sessionProvider =
    StateNotifierProvider<Session, LoginResult?>((ref) => Session());
