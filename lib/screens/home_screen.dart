import 'package:flutter/material.dart';
import 'package:sumilao/screens/tabs/patient_list_tab.dart';
import 'package:sumilao/utils/colors.dart';
import 'package:sumilao/widgets/button_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(80, 20, 30, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.jpg',
                    height: 75,
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: TabBar(
                        indicatorColor: primary,
                        unselectedLabelColor: Colors.grey,
                        labelColor: primary,
                        labelStyle: TextStyle(
                            color: primary, fontFamily: 'QBold', fontSize: 14),
                        tabs: const [
                          Tab(
                            text: 'PATIENT LIST',
                          ),
                          Tab(
                            text: 'MAP',
                          ),
                          Tab(
                            text: 'NEWS & UPDATE',
                          ),
                          Tab(
                            text: 'ABOUT US',
                          ),
                        ]),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  ButtonWidget(
                      fontSize: 12,
                      width: 100,
                      label: 'Add New Patient',
                      onPressed: (() {})),
                  const SizedBox(
                    width: 15,
                  ),
                  ButtonWidget(
                      fontSize: 12,
                      width: 100,
                      label: 'Add User',
                      onPressed: (() {})),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                      onPressed: (() {}),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.grey,
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(children: [
                PatientListTab(),
                for (int i = 0; i < 3; i++)
                  Center(
                    child: Text(i.toString()),
                  ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
