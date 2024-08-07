// author: Lukas Horst

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/appwrite/auth_api.dart';
import 'package:secret_hitler/backend/authentication/user_state_notifier.dart';
import 'package:secret_hitler/backend/database/appwrite/database_api.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_room_state_notifier.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/timer.dart';
import 'package:secret_hitler/backend/riverpod/qr_code/qr_code_notifier.dart';

// The provider for the auth api
final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi();
});

// The provider for the user state notifier
final userStateProvider = StateNotifierProvider<UserStateNotifier, UserState>((ref) {
  final authApi = ref.watch(authApiProvider);
  return UserStateNotifier(authApi);
});

// The provider for the database api
final databaseApiProvider = Provider<DatabaseApi>((ref) {
  final authApi = ref.watch(authApiProvider);
  return DatabaseApi(authApi);
});

// The provider for the time which updates the online status from the user
final timerProvider = Provider<CustomTimer>((ref) {
  return CustomTimer();
});

// The provider for the game room state notifier. The game room will be set later
final gameRoomStateProvider = StateNotifierProvider<GameRoomStateNotifier, GameRoomState>((ref) {
  final authApi = ref.watch(authApiProvider);
  final databaseApi = ref.watch(databaseApiProvider);
  return GameRoomStateNotifier(databaseApi, authApi.getClient());
});

// The provider for the qr code notifier
final qrCodeProvider = StateNotifierProvider<QrCodeNotifier, QrCodeState>((ref) {
  return QrCodeNotifier();
});

// The provider for the game state notifier
final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  final authApi = ref.watch(authApiProvider);
  final databaseApi = ref.watch(databaseApiProvider);
  return GameStateNotifier(databaseApi, authApi.getClient());
});