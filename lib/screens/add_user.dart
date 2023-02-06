import 'package:flutter/material.dart';
import 'package:sumilao/widgets/appbar_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';

import '../utils/colors.dart';
import '../widgets/button_widget.dart';

class UserManagementScreen extends StatefulWidget {
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
                                  onPressed: (() {
                                    showToast('User added succesfully!');
                                    Navigator.pop(context);
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
      appBar: customAppbar('User Management'),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                          TextBold(
                              text: '(0)', fontSize: 18, color: Colors.black),
                          const VerticalDivider(),
                          TextRegular(
                              text: 'Administrator ',
                              fontSize: 18,
                              color: Colors.grey),
                          TextBold(
                              text: '(0)', fontSize: 18, color: Colors.black),
                          const VerticalDivider(),
                          TextRegular(
                              text: 'Doctors ',
                              fontSize: 18,
                              color: Colors.grey),
                          TextBold(
                              text: '(0)', fontSize: 18, color: Colors.black),
                          const VerticalDivider(),
                          TextRegular(
                              text: 'Nurse ', fontSize: 18, color: Colors.grey),
                          TextBold(
                              text: '(0)', fontSize: 18, color: Colors.black),
                        ],
                      ),
                    ),
                    TextFieldWidget(
                        width: 250,
                        label: 'Search user',
                        controller: userController)
                  ],
                ),
                DataTable(columns: [
                  DataColumn(
                      label: TextBold(
                          text: 'Username', fontSize: 18, color: Colors.black)),
                  DataColumn(
                      label: TextBold(
                          text: 'Name', fontSize: 18, color: Colors.black)),
                  DataColumn(
                      label: TextBold(
                          text: 'Email', fontSize: 18, color: Colors.black)),
                  DataColumn(
                      label: TextBold(
                          text: 'Role', fontSize: 18, color: Colors.black)),
                  DataColumn(
                      label: TextBold(
                          text: '', fontSize: 18, color: Colors.black)),
                  DataColumn(
                      label:
                          TextBold(text: '', fontSize: 18, color: Colors.black))
                ], rows: [
                  for (int i = 0; i < 100; i++)
                    DataRow(cells: [
                      DataCell(
                        TextRegular(
                            text: 'John123', fontSize: 14, color: Colors.grey),
                      ),
                      DataCell(
                        TextRegular(
                            text: 'John Doe', fontSize: 14, color: Colors.grey),
                      ),
                      DataCell(
                        TextRegular(
                            text: 'doe@gmail.com',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                      DataCell(
                        TextRegular(
                            text: 'Admin', fontSize: 14, color: Colors.grey),
                      ),
                      DataCell(ButtonWidget(
                          width: 75,
                          height: 40,
                          fontSize: 14,
                          label: 'Edit Role',
                          onPressed: (() {}))),
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
                                        style:
                                            TextStyle(fontFamily: 'QRegular'),
                                      ),
                                      actions: <Widget>[
                                        MaterialButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(
                                                fontFamily: 'QRegular',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () async {
                                            showToast(
                                                'User deleted succesfully!');
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Continue',
                                            style: TextStyle(
                                                fontFamily: 'QRegular',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ));
                          }))),
                    ])
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
