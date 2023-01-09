import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'models.dart';

class LoginResult {
  const LoginResult(this.user, this.token);
  final User user;
  final String token;
}

class Session extends StateNotifier<LoginResult?> {
  Session() : super(null);

  void logIn(LoginResult r) {
    state = r;
  }
}

final sessionProvider = StateNotifierProvider((ref) => Session());
