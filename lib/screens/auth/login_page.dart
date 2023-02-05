import 'package:flutter/material.dart';
import 'package:sumilao/widgets/button_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';

class LoginPage extends StatelessWidget {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 600,
            width: 600,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextBold(text: 'LOGIN', fontSize: 24, color: Colors.black),
              TextRegular(
                  text: 'Welcome back! Please enter your details',
                  fontSize: 16,
                  color: Colors.black),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Username or Email: ', controller: emailController),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  label: 'Password: ', controller: passwordController),
              TextButton(
                  onPressed: (() {}),
                  child: TextBold(
                      text: 'Forgot Password?',
                      fontSize: 12,
                      color: Colors.black)),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: ButtonWidget(
                    label: 'Login',
                    onPressed: (() {
                      Navigator.pushReplacementNamed(context, '/homescreen');
                    })),
              )
            ],
          ),
        ],
      ),
    );
  }
}
