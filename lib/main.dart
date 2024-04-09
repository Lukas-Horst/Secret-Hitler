// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:secret_hitler/app_language/app_language.dart';
import 'package:secret_hitler/database/hive_database.dart';
import 'package:secret_hitler/login_page.dart';

import 'constants/screen_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveDatabase.init();

  // Initialize the language
  await AppLanguage.init();

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
    return const MaterialApp(
      home: Login(),
    );
  }
}
