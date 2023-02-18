import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/io/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';

import 'models.dart';

class UserSession {
  UserSession(this.user, this.token);

  final User user;
  final String token;

  UserSession copyWith({User? user}) {
    return UserSession(user ?? this.user, token);
  }
}

class Session extends StateNotifier<UserSession?> {
  Session() : super(null);

  Future<void> logIn(String r) async {
    setAuthHeader(r);
    final session = UserSession(await backend.getCurrentUser(), r);
    saveSession(r);
    state = session;
  }

  void logOut() async {
    await deleteSession();
    resetAuthHeaders();
    state = null;
  }

  bool get isLoggedIn => state != null;

  Future<void> updateProfile() async {
    state = state!.copyWith(user: await backend.getCurrentUser());
  }
}

final sessionProvider =
    StateNotifierProvider<Session, UserSession?>((ref) => Session());
