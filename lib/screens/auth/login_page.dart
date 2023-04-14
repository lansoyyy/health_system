import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/services/local_storage.dart';
import 'package:sumilao/utils/colors.dart';
import 'package:sumilao/widgets/button_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              opacity: 400,
              image: AssetImage('assets/images/new.png'),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBold(text: 'GeoFinds', fontSize: 75, color: primary),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 450,
                      width: 600,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/sumi.png'),
                            fit: BoxFit.fitHeight),
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
                        label: 'Username or Email: ',
                        controller: emailController),
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
                              Navigator.pushReplacementNamed(
                                  context, '/homescreen');
                            } else {
                              late var isDeleted;
                              late var role;
                              try {
                                var collection = FirebaseFirestore.instance
                                    .collection('User')
                                    .where('email',
                                        isEqualTo: emailController.text);

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
            const Expanded(child: SizedBox()),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 400, right: 400, bottom: 20),
                child: TextRegular(
                    text:
                        'Republic Act No. 10173, otherwise known as the Data Privacy Act is a law that seeks to protect all forms of information, be it private, personal, or sensitive. It is meant to cover both natural and juridical persons involved in the processing of personal information.',
                    fontSize: 12,
                    color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
