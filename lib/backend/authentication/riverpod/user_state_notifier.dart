// author: Lukas Horst

import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/appwrite/auth_api.dart';

class UserState {
  final User? user;
  final bool firstCheck;
  final bool withoutVerification;

  UserState({required this.user, required this.firstCheck,
    required this.withoutVerification});
}

// Notifier to check if the user is logged in or not
class UserStateNotifier extends StateNotifier<UserState> {
  late final AuthApi _authApi;

  UserStateNotifier(this._authApi) :super(UserState(user: null,
      firstCheck: false, withoutVerification: false)) {
    checkUserStatus();
  }

  // Method to check if the user is logged in
  Future<void> checkUserStatus() async {
    final user = await _authApi.getCurrentUser();
    state = UserState(user: user, firstCheck: true,
        withoutVerification: state.withoutVerification);
  }

  // Method to change the without verification variable (when true the email
  // verification page will be skipped).
  Future<void> changeVerificationState() async {
    state = UserState(user: state.user, firstCheck: state.firstCheck,
        withoutVerification: !state.withoutVerification);
  }
}