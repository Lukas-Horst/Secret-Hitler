

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';

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
  Future<User> signIn(String email, String password) async {
    try {
      final user = _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return user;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Method to login with the email and password
  Future<User> emailPasswordLogin(String email, String password) async {
    try {
      final session = await _account.createEmailPasswordSession(
          email: email,
          password: password);
      return _account.get();
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  // Method to logout from AppWrite
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch(e) {
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