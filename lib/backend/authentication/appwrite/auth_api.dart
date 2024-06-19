

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/frontend/widgets/loading_spin.dart';

// Class for all authentication method to AppWrite
class AuthApi {

  final Client _client = Client()
      .setEndpoint(appwriteUrl)
      .setProject(appwriteProjectId)
      .setSelfSigned(status: true);
  late final Account _account;

  // Constructor
  AuthApi() {
    _account = Account(_client);
  }

  // Method to sign in with an email and a password
  Future<bool> signIn(String email, String password,
      BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      LoadingSpin.closeLoadingSpin(context);
      return false;
    }
  }

  // Method to login with the email and password
  Future<bool> emailPasswordLogin(String email, String password,
      BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.createEmailPasswordSession(
          email: email,
          password: password);
      return true;
    } catch (e) {
      LoadingSpin.closeLoadingSpin(context);
      print(e);
      return false;
    }
  }

  // Method to login with google
  Future<bool> googleLogin(BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.createOAuth2Session(
        provider: OAuthProvider.google,
        scopes: ['profile', 'email'],
      );
      return true;
    } catch (e) {
      LoadingSpin.closeLoadingSpin(context);
      print(e);
      return false;
    }
  }

  // Method to logout from AppWrite
  Future<void> logout(BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch(e) {
      LoadingSpin.closeLoadingSpin(context);
      throw Exception('Failed to logout: $e');
    }
  }

  // Method to get the current user, if he is logged in
  Future<User?> getCurrentUser() async {
    try {
      // User is logged in
      return await _account.get();
    } catch(e) {
      // User isn't logged in
      return null;
    }
  }

  // Method to send a verification email to the user. Returns true if the email is submitted successfully
  Future<bool> sendVerificationMail() async {
    try {
      await _account.createVerification(
        url: 'http://reset-password-and-verify-email.onrender.com/verify',
      );
      return true;
    } catch(e) {
      return false;
    }
  }

  // Method to send a recovery email to reset the password. Returns true if the email is submitted successfully
  Future<bool> sendRecoveryMail(String email) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'http://reset-password-and-verify-email.onrender.com/recovery',
      );
      return true;
    } catch(e) {
      return false;
    }
  }
}