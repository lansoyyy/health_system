import 'package:flutter/material.dart';
import 'package:sumilao/screens/auth/login_page.dart';
import 'package:sumilao/screens/home_screen.dart';
import 'package:sumilao/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        Routes.loginpage: (context) => LoginPage(),
        Routes.homescreen: (context) => const HomeScreen(),
      },
    );
  }
}
