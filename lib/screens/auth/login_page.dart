import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          image:  DecorationImage(image: AssetImage('assets/images/background.png'),),
        ),
      ),
    );
    
  }
}