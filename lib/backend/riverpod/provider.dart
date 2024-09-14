// author: Lukas Horst

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/appwrite/auth_api.dart';
import 'package:secret_hitler/backend/authentication/user_state_notifier.dart';
import 'package:secret_hitler/backend/database/appwrite/database_api.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_room_state_notifier.dart';
import 'package:secret_hitler/backend/database/appwrite/notifiers/game_state_notifier.dart';
import 'package:secret_hitler/backend/helper/progress_blocker.dart';
import 'package:secret_hitler/backend/helper/timer.dart';
import 'package:secret_hitler/backend/riverpod/qr_code/qr_code_notifier.dart';
import 'package:secret_hitler/frontend/widgets/components/text/game_room_text.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/page_view.dart';

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

// The provider for a key of a custom page view
final customPageViewKeyProvider = Provider<GlobalKey<CustomPageViewState>>((ref) {
  return GlobalKey<CustomPageViewState>();
});

// The provider for the progress blocker notifier for the players and election page
final playersAndElectionProgressBlockerProvider = StateNotifierProvider<
    ProgressBlocker, bool>((ref) {
  return ProgressBlocker();
});

// The provider for the progress blocker notifier for the board overview page
final boardOverviewProgressBlockerProvider = StateNotifierProvider<
    ProgressBlocker, bool>((ref) {
  return ProgressBlocker();
});

// The provider for the game room text key from the board overview page
final boardOverviewGameRoomTextProvider = Provider<GlobalKey<GameRoomTextState>>((ref) {
  return GlobalKey<GameRoomTextState>();
});

// The provider for the game room text key from the player and election page
final playerAndElectionGameRoomTextProvider = Provider<GlobalKey<GameRoomTextState>>((ref) {
  return GlobalKey<GameRoomTextState>();
});