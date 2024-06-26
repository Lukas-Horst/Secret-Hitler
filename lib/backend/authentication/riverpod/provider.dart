// author: Lukas Horst

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/appwrite/auth_api.dart';
import 'package:secret_hitler/backend/authentication/riverpod/user_state_notifier.dart';

// The provider for the auth api
final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi();
});

// The provider for the user state notifier
final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  final authApi = ref.watch(authApiProvider);
  return UserStateNotifier(authApi);
});