import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/services/add_user.dart';
import 'package:sumilao/widgets/appbar_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import '../utils/colors.dart';
import '../widgets/button_widget.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final userController = TextEditingController();

  final usernameController = TextEditingController();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  var roles = ['Admin', 'Doctor', 'Nurse'];

  var dropValue = 0;

  String role = 'Admin';
  String nameSearched = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: primary,
          onPressed: (() {
            showDialog(
                context: context,
                builder: ((context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return Dialog(
                      child: SizedBox(
                        height: 550,
                        width: 320,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBold(
                                  text: 'Input User Details',
                                  fontSize: 24,
                                  color: Colors.black),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Username',
                                  controller: usernameController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Full Name',
                                  controller: nameController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  label: 'Email', controller: emailController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFieldWidget(
                                  inPassword: true,
                                  isObscure: true,
                                  label: 'Password',
                                  controller: passwordController),
                              const SizedBox(
                                height: 10,
                              ),
                              TextRegular(
                                  text: 'Role',
                                  fontSize: 16,
                                  color: Colors.black),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.black,
                                    )),
                                child: Center(
                                  child: DropdownButton(
                                      dropdownColor: Colors.white,
                                      value: dropValue,
                                      items: [
                                        for (int i = 0; i < roles.length; i++)
                                          DropdownMenuItem(
                                              onTap: (() {
                                                role = roles[i];
                                              }),
                                              value: i,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50, right: 50),
                                                child: TextRegular(
                                                    text: roles[i],
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ))
                                      ],
                                      onChanged: ((value) {
                                        setState(() {
                                          dropValue =
                                              int.parse(value.toString());
                                        });
                                      })),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ButtonWidget(
                                  label: 'Continue',
                                  onPressed: (() async {
                                    try {
                                      showToast('User added succesfully!');
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                      addUser(
                                          usernameController.text,
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                          role);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      showToast(e.toString());
                                    }
                                  }))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                }));
          }),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.jpg',
                          height: 100,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextBold(
                            text: 'GeoFinds', fontSize: 24, color: primary),
                      ],
                    ),
                    TextBold(
                        text: 'USER MANAGEMENT',
                        fontSize: 58,
                        color: Colors.black),
                    const SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                customAppbar('User Management'),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          TextRegular(
                              text: 'All ', fontSize: 18, color: Colors.grey),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .where('isDeleted', isEqualTo: false)

                                  // .orderBy('name')

                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  print('error');

                                  print(snapshot.error);
                                  return const Center(child: Text('Error'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                    )),
                                  );
                                }

                                final data = snapshot.requireData;
                                return TextBold(
                                    text: '(${data.size})',
                                    fontSize: 18,
                                    color: Colors.black);
                              }),
                          const VerticalDivider(),
                          TextRegular(
                              text: 'Administrator ',
                              fontSize: 18,
                              color: Colors.grey),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .where('isDeleted', isEqualTo: false)
                                  .where('role', isEqualTo: 'Admin')

                                  // .orderBy('name')

                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  print('error');

                                  print(snapshot.error);
                                  return const Center(child: Text('Error'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                    )),
                                  );
                                }

                                final data = snapshot.requireData;
                                return TextBold(
                                    text: '(${data.size})',
                                    fontSize: 18,
                                    color: Colors.black);
                              }),
                          const VerticalDivider(),
                          TextRegular(
                              text: 'Doctors ',
                              fontSize: 18,
                              color: Colors.grey),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .where('isDeleted', isEqualTo: false)
                                  .where('role', isEqualTo: 'Doctor')

                                  // .orderBy('name')

                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  print('error');

                                  print(snapshot.error);
                                  return const Center(child: Text('Error'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                    )),
                                  );
                                }

                                final data = snapshot.requireData;
                                return TextBold(
                                    text: '(${data.size})',
                                    fontSize: 18,
                                    color: Colors.black);
                              }),
                          const VerticalDivider(),
                          TextRegular(
                              text: 'Nurse ', fontSize: 18, color: Colors.grey),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('User')
                                  .where('isDeleted', isEqualTo: false)
                                  .where('role', isEqualTo: 'Nurse')

                                  // .orderBy('name')

                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  print('error');

                                  print(snapshot.error);
                                  return const Center(child: Text('Error'));
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 50),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                    )),
                                  );
                                }

                                final data = snapshot.requireData;
                                return TextBold(
                                    text: '(${data.size})',
                                    fontSize: 18,
                                    color: Colors.black);
                              }),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextRegular(
                            text: 'Search user',
                            fontSize: 16,
                            color: Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            onChanged: ((value) {
                              setState(() {
                                nameSearched = value;
                              });
                            }),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: 'Search by name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .where('isDeleted', isEqualTo: false)
                        .where('name',
                            isGreaterThanOrEqualTo:
                                toBeginningOfSentenceCase(nameSearched))
                        .where('name',
                            isLessThan:
                                '${toBeginningOfSentenceCase(nameSearched)}z')
                        // .orderBy('name')

                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print('error');

                        print(snapshot.error);
                        return const Center(child: Text('Error'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.black,
                          )),
                        );
                      }

                      final data = snapshot.requireData;
                      return DataTable(columns: [
                        DataColumn(
                            label: TextBold(
                                text: 'Username',
                                fontSize: 18,
                                color: Colors.black)),
                        DataColumn(
                            label: TextBold(
                                text: 'Name',
                                fontSize: 18,
                                color: Colors.black)),
                        DataColumn(
                            label: TextBold(
                                text: 'Email',
                                fontSize: 18,
                                color: Colors.black)),
                        DataColumn(
                            label: TextBold(
                                text: 'Role',
                                fontSize: 18,
                                color: Colors.black)),
                        DataColumn(
                            label: TextBold(
                                text: '', fontSize: 18, color: Colors.black)),
                        DataColumn(
                            label: TextBold(
                                text: '', fontSize: 18, color: Colors.black))
                      ], rows: [
                        for (int i = 0; i < data.size; i++)
                          DataRow(cells: [
                            DataCell(
                              TextRegular(
                                  text: data.docs[i]['username'],
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                            DataCell(
                              TextRegular(
                                  text: data.docs[i]['name'],
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                            DataCell(
                              TextRegular(
                                  text: data.docs[i]['email'],
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                            DataCell(
                              TextRegular(
                                  text: data.docs[i]['role'],
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                            DataCell(ButtonWidget(
                                width: 75,
                                height: 40,
                                fontSize: 14,
                                label: 'Edit Role',
                                onPressed: (() {
                                  showDialog(
                                      context: context,
                                      builder: ((context) {
                                        return Dialog(
                                          child: SizedBox(
                                            height: 220,
                                            width: 150,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ButtonWidget(
                                                    width: 150,
                                                    fontSize: 14,
                                                    label: 'Change to Admin',
                                                    onPressed: (() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('User')
                                                          .doc(data.docs[i].id)
                                                          .update({
                                                        'role': 'Admin'
                                                      });
                                                      showToast(
                                                          'Role updated succesfully!');
                                                      Navigator.pop(context);
                                                    })),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                ButtonWidget(
                                                    width: 150,
                                                    fontSize: 14,
                                                    label: 'Change to Doctor',
                                                    onPressed: (() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('User')
                                                          .doc(data.docs[i].id)
                                                          .update({
                                                        'role': 'Doctor'
                                                      });
                                                      showToast(
                                                          'Role updated succesfully!');
                                                      Navigator.pop(context);
                                                    })),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                ButtonWidget(
                                                    width: 150,
                                                    fontSize: 12,
                                                    label:
                                                        'Change to Nurse/BHW',
                                                    onPressed: (() async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('User')
                                                          .doc(data.docs[i].id)
                                                          .update({
                                                        'role': 'Nurse'
                                                      });
                                                      showToast(
                                                          'Role updated succesfully!');
                                                      Navigator.pop(context);
                                                    })),
                                              ],
                                            ),
                                          ),
                                        );
                                      }));
                                }))),
                            DataCell(ButtonWidget(
                                color: Colors.red,
                                width: 75,
                                height: 40,
                                fontSize: 14,
                                label: 'Delete',
                                onPressed: (() {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Delete Confirmation',
                                              style: TextStyle(
                                                  fontFamily: 'QBold',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this user?',
                                              style: TextStyle(
                                                  fontFamily: 'QRegular'),
                                            ),
                                            actions: <Widget>[
                                              MaterialButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text(
                                                  'Close',
                                                  style: TextStyle(
                                                      fontFamily: 'QRegular',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  showToast(
                                                      'User deleted succesfully!');
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('User')
                                                      .doc(data.docs[i].id)
                                                      .update(
                                                          {'isDeleted': true});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Continue',
                                                  style: TextStyle(
                                                      fontFamily: 'QRegular',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ));
                                }))),
                          ])
                      ]);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
