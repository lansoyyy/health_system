import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/services/local_storage.dart';
import 'package:sumilao/widgets/button_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextBold(
                  text: 'Sumilao Health System',
                  fontSize: 38,
                  color: Colors.black),
              Container(
                height: 300,
                width: 600,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ],
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
                  inPassword: true,
                  isObscure: true,
                  label: 'Password: ',
                  controller: passwordController),
              // TextButton(
              //     onPressed: (() {}),
              //     child: TextBold(
              //         text: 'Forgot Password?',
              //         fontSize: 12,
              //         color: Colors.black)),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: ButtonWidget(
                    label: 'Login',
                    onPressed: (() async {
                      if (emailController.text == 'admin-username' &&
                          passwordController.text == 'admin-password') {
                        box.write('user', 'Admin');
                        Navigator.pushReplacementNamed(context, '/homescreen');
                      } else {
                        late var isDeleted;
                        late var role;
                        try {
                          var collection = FirebaseFirestore.instance
                              .collection('User')
                              .where('email', isEqualTo: emailController.text);

                          var querySnapshot = await collection.get();
                          var user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);

                          setState(() {
                            for (var queryDocumentSnapshot
                                in querySnapshot.docs) {
                              Map<String, dynamic> data =
                                  queryDocumentSnapshot.data();
                              isDeleted = data['isDeleted'];
                              role = data['role'];
                            }
                          });

                          if (isDeleted == true) {
                            showToast('Your account has been deleted!');
                            await FirebaseAuth.instance.signOut();
                          } else {
                            box.write('user', role);
                            Navigator.pushReplacementNamed(
                                context, '/homescreen');
                          }
                        } catch (e) {
                          showToast(e.toString());
                        }
                      }
                    })),
              )
            ],
          ),
        ],
      ),
    );
  }
}
