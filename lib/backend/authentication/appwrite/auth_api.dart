

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

  AuthApi() {
    _account = Account(_client);
  }

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

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch(e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      // User is logged in
      return await _account.get();
    } catch(e) {
      // User isn't logged in
      return null;
    }
  }
}