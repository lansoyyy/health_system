import 'package:cloud_firestore/cloud_firestore.dart';

Future addUser(username, name, email, password, role) async {
  final docUser = FirebaseFirestore.instance.collection('User').doc();

  final json = {
    'username': username,
    'name': name,
    'email': email,
    'password': password,
    'role': role,
    'isDeleted': false
  };

  await docUser.set(json);
}
