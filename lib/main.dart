// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/hive_database.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/login_register_switch.dart';
import 'package:secret_hitler/frontend/pages/home/homepage/new_game_page.dart';
import 'package:secret_hitler/frontend/pages/home/page_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveDatabase.init();

  // Initialize the language
  await AppLanguage.init();

  // Initialize the design
  await AppDesign.init();

  // Connection to AppWrite
  Client client = Client()
      .setEndpoint('http://192.168.178.51:666/v1')
      .setProject('66113781000fbb8b35da');
  Account account = Account(client);

  runApp(MaterialApp(
    home: MyApp(account: account),
  ));
}

class MyApp extends StatefulWidget {
  final Account account;

  MyApp({required this.account});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);  // Initialize the screen size
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppDesign.getTertiaryColor()
        ),
      ),
      // home: const NewGame(),
      // home: const PageNavigation(),
      home: const LoginRegisterSwitch(),
    );
  }
}
