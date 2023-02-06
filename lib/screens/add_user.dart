import 'package:flutter/material.dart';
import 'package:sumilao/widgets/appbar_widget.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar('User Management'),
    );
  }
}
