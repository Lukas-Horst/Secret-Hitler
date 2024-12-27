// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secret_hitler/backend/authentication/appwrite/auth_api.dart';
import 'package:secret_hitler/backend/database/appwrite/collections/user_collection_functions.dart';

class UserState {
  final User? user;
  final bool firstCheck;
  final bool withoutVerification;
  final bool isGuest;
  final String? provider;

  UserState({required this.user, required this.firstCheck,
    required this.withoutVerification, required this.isGuest,
    required this.provider});
}

// Notifier to check if the user is logged in or not
class UserStateNotifier extends StateNotifier<UserState> {
  late final AuthApi _authApi;
  late RealtimeSubscription _subscription;
  bool _isSubscribed = false;

  UserStateNotifier(this._authApi) :super(UserState(user: null,
      firstCheck: false, withoutVerification: false, isGuest: false,
      provider: null)) {
    checkUserStatus();
  }

  // Method to check if the user is logged in
  Future<void> checkUserStatus({WidgetRef? ref}) async {
    final user = await _authApi.getCurrentUser();
    bool newVerificationState = state.withoutVerification;
    bool isGuest = false;
    if (user != null) {
      // If the user hasn't an email, he is a guest
      if (user.email.isEmpty) {
        isGuest = true;
      }
      // Setting the verification state equal to the email verification value
      if (!state.withoutVerification) {
        newVerificationState = user.emailVerification;
      }
    }
    String? provider;
    if (!isGuest && user != null) {
      provider = await _authApi.getAuthProvider();
    }
    state = UserState(user: user, firstCheck: true,
        withoutVerification: newVerificationState, isGuest: isGuest,
        provider: provider);
    if (ref != null && user != null) {
      await createUser(ref, isGuest);
    }
  }

  // Method which starts a stream to any changes from the user account
  void subscribeUserUpdates() {
    if (!_isSubscribed) {
      _isSubscribed = true;
      Realtime realtime = Realtime(_authApi.getClient());
      _subscription = realtime.subscribe(['account']);
      _subscription.stream.listen((response) {
        checkUserStatus();
      });
    }
  }

  // Method to close the user subscription
  void unsubscribeUserUpdates() {
    if (_isSubscribed) {
      _subscription.close();
      _isSubscribed = false;
    }
  }

  // Method to change the without verification variable (when true the email
  // verification page will be skipped).
  Future<void> changeVerificationState() async {
    state = UserState(user: state.user, firstCheck: state.firstCheck,
        withoutVerification: !state.withoutVerification,
        isGuest: state.isGuest, provider: state.provider);
  }
}