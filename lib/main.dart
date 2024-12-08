// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:secret_hitler/backend/app_design/app_design.dart';
import 'package:secret_hitler/backend/app_language/app_language.dart';
import 'package:secret_hitler/backend/constants/screen_size.dart';
import 'package:secret_hitler/backend/database/local/hive_database.dart';
import 'package:secret_hitler/frontend/pages/authentication/switches/login_confirm_email_switch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Loading the .env file for the appwrite id's
  await dotenv.load(fileName: '.env');

  // Initialize Hive
  await HiveDatabase.init();

  // Initialize the language
  await AppLanguage.init();

  // Initialize the design
  await AppDesign.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);  // Initialize the screen size
    return GetMaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppDesign.getTertiaryColor()
        ),
      ),
      home: const LoginConfirmEmailSwitch(),
    );
  }
}
