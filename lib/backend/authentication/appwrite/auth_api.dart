// author: Lukas Horst

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/appwrite_constants.dart';
import 'package:secret_hitler/frontend/widgets/components/useful_widgets/text_form_field.dart';
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

  Client getClient() {
    return _client;
  }

  // Method to register with an email and a password
  Future<bool> register(String email, String password, BuildContext context,
      String name, GlobalKey<CustomTextFormFieldState> emailTextFieldKey,
      GlobalKey<CustomTextFormFieldState> passwordTextFieldKey,
      GlobalKey<CustomTextFormFieldState> confirmPasswordTextFieldKey) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      return true;
    } on AppwriteException catch(e) {
      print(e.message);
      if (e.message!.contains('Invalid `email` param')) {
        emailTextFieldKey.currentState?.showError(AppLanguage.getLanguageData()['Invalid email format']);
      }
      LoadingSpin.closeLoadingSpin(context);
      return false;
    } catch(e) {
      print(e);
      LoadingSpin.closeLoadingSpin(context);
      return false;
    }
  }

  // Method to login with the email and password
  Future<bool> emailPasswordLogin(String email, String password,
      BuildContext context,
      GlobalKey<CustomTextFormFieldState> emailTextFieldKey,
      GlobalKey<CustomTextFormFieldState> passwordTextFieldKey) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.createEmailPasswordSession(
          email: email,
          password: password);
      return true;
    } on AppwriteException catch(e) {
      print(e.message);
      print(e);
      if (e.message!.contains('Invalid `email` param')) {
        emailTextFieldKey.currentState?.showError(
            AppLanguage.getLanguageData()['Invalid email format']);
      }
      if (e.message!.contains('Invalid `password`')) {
        passwordTextFieldKey.currentState?.showError(
            AppLanguage.getLanguageData()['Wrong password']);
      }
      if (e.message!.contains('Invalid credentials')) {
        emailTextFieldKey.currentState?.showError(
            AppLanguage.getLanguageData()['Invalid credentials']);
        passwordTextFieldKey.currentState?.showError(
            AppLanguage.getLanguageData()['Invalid credentials']);
      }
      LoadingSpin.closeLoadingSpin(context);
      return false;
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

  // Method to login as a guest
  Future<bool> guestLogin(BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.createAnonymousSession();
      return true;
    } catch (e) {
      LoadingSpin.closeLoadingSpin(context);
      print(e);
      return false;
    }
  }

  // Method to logout from AppWrite
  Future<bool> logout(BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.deleteSession(sessionId: 'current');
      return true;
    } catch(e) {
      LoadingSpin.closeLoadingSpin(context);
      print(e);
      return false;
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

  // Method to send a verification email to the user. Returns true if the email
  // is submitted successfully
  Future<bool> sendVerificationMail(BuildContext context) async {
    LoadingSpin.openLoadingSpin(context);
    try {
      await _account.createVerification(
        url: 'http://reset-password-and-verify-email.onrender.com/verify',
      );
      LoadingSpin.closeLoadingSpin(context);
      return true;
    } catch(e) {
      LoadingSpin.closeLoadingSpin(context);
      return false;
    }
  }

  // Method to send a recovery email to reset the password. Returns true if the
  // email is submitted successfully
  Future<bool> sendRecoveryMail(String email) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'http://reset-password-and-verify-email.onrender.com/recovery',
      );
      return true;
    } catch(e) {
      print(e);
      return false;
    }
  }

  // Method to update the email address if possible
  Future<bool> updateEmail(String email, String password, BuildContext context,
      GlobalKey<CustomTextFormFieldState> passwordTextFieldKey) async {
    try {
      await _account.updateEmail(email: email, password: password);
      return true;
    } catch (e) {
      LoadingSpin.closeLoadingSpin(context);
      if (e.toString().contains('Invalid `password`')) {
        print(true);
      }
      print(e);
      return false;
    }
  }

  // Method to update the user name
  Future<bool> updateUserName(String userName) async {
    try {
      await _account.updateName(name: userName);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Method to return the name of the provider
  Future<String?> getAuthProvider() async {
    var identities = await _account.listIdentities();
    for (var identity in identities.identities) {
      return identity.provider;
    }
    return null;
  }

}