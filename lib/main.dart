import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
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
      builder: ((context, child) {
        return ResponsiveWrapper.builder(child,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(480, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Colors.white));
      }),
      title: 'Municipaliy of Sumilao',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        Routes.loginpage: (context) => LoginPage(),
        Routes.homescreen: (context) => HomeScreen(),
      },
    );
  }
}
