// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/appwrite/auth_api.dart';

// Notifier to check if the user is logged in or not
class UserStateNotifier extends StateNotifier<User?> {
  late final AuthApi authApi;

  UserStateNotifier(this.authApi) : super(null) {
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    final user = await authApi.getCurrentUser();
    state = user;
  }

  Future<void> logout() async {
    await authApi.logout();
    state = null;
  }
}