import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/services/local_storage.dart';
import 'package:sumilao/utils/colors.dart';
import 'package:sumilao/widgets/button_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';

import '../../widgets/text_widget.dart';

class AboutUsTab extends StatelessWidget {
  final newFirstController = TextEditingController();
  final newSecondController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('AboutUs')
        .doc('details')
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: userData,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading'));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          dynamic data = snapshot.data;
          return Scaffold(
            floatingActionButton: box.read('user') == 'admin'
                ? FloatingActionButton(
                    backgroundColor: primary,
                    onPressed: (() {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return Dialog(
                              child: SizedBox(
                                width: 500,
                                height: 640,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 30, 20, 30),
                                  child: Column(
                                    children: [
                                      TextFieldWidget(
                                          maxLine: 7,
                                          height: 200,
                                          width: 500,
                                          hint: data['first'],
                                          label: 'New Details',
                                          controller: newFirstController),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFieldWidget(
                                          maxLine: 7,
                                          height: 200,
                                          width: 500,
                                          hint: data['second'],
                                          label: 'New Details',
                                          controller: newSecondController),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      ButtonWidget(
                                          label: 'Continue',
                                          onPressed: (() async {
                                            await FirebaseFirestore.instance
                                                .collection('AboutUs')
                                                .doc('details')
                                                .update({
                                              'first':
                                                  newFirstController.text == ''
                                                      ? data['first']
                                                      : newFirstController.text,
                                              'second':
                                                  newSecondController.text == ''
                                                      ? data['second']
                                                      : newSecondController
                                                          .text,
                                            });
                                            Navigator.pop(context);
                                            showToast('Updated Succesfully!');
                                          }))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }));
                    }),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ))
                : const SizedBox(),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              image: AssetImage('assets/images/cover.png'),
                              fit: BoxFit.fitWidth,
                              opacity: 1)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                      child: TextRegular(
                          text: data['first'],
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/mapsumil.png',
                      fit: BoxFit.fitWidth,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                      child: TextRegular(
                          text: data['second'],
                          fontSize: 20,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBold(
                                text: "Let's stay in touch",
                                fontSize: 24,
                                color: Colors.black),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.phone),
                                const SizedBox(
                                  width: 10,
                                ),
                                TextRegular(
                                    text: '+(63) 9505937901',
                                    fontSize: 14,
                                    color: Colors.black)
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                TextRegular(
                                    text: '8701 Sumilao, Bukidon',
                                    fontSize: 14,
                                    color: Colors.black)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
