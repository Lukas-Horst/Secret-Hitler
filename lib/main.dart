import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:secret_hitler/login_page.dart';

import 'constants/screen_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client()
      .setEndpoint('http://192.168.178.51:666/v1')
      .setProject('66113781000fbb8b35da');
  Account account = Account(client);

  runApp(MaterialApp(
    home: MyApp(account: account),
  ));
}

class MyApp extends StatelessWidget {
  final Account account;

  MyApp({required this.account});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);  // initialize the screen size to get it global
    return const MaterialApp(
      home: Login(),
    );
  }
}
