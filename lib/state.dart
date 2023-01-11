import 'package:app_frontend/io/http.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'models.dart';

class Session extends StateNotifier<String?> {
  Session() : super(null);

  void logIn(String r) {
    setAuthHeader(r);
    state = r;
  }

  void logOut() {
    resetAuthHeaders();
    state = null;
  }

  bool get isLoggedIn => state != null;
}

final sessionProvider =
    StateNotifierProvider<Session, String?>((ref) => Session());
