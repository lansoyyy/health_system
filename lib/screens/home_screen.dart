import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/screens/tabs/about_us_tab.dart';
import 'package:sumilao/screens/tabs/map_tab.dart';
import 'package:sumilao/screens/tabs/news_tab.dart';
import 'package:sumilao/screens/tabs/patient_list_tab.dart';
import 'package:sumilao/services/local_storage.dart';
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
                    height: 100,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 750,
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
                          // Tab(
                          //   text: 'STATISTICS',
                          // ),
                        ]),
                  ),
                  ButtonWidget(
                      fontSize: 12,
                      width: 100,
                      label: 'Add New Patient',
                      onPressed: (() {
                        Navigator.pushNamed(context, '/patientscreen');
                      })),
                  const SizedBox(
                    width: 15,
                  ),
                  box.read('user') == 'Admin'
                      ? ButtonWidget(
                          fontSize: 12,
                          width: 100,
                          label: 'Add User',
                          onPressed: (() {
                            Navigator.pushNamed(context, '/userscreen');
                          }))
                      : const SizedBox(),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                      onPressed: (() {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                    'Logout Confirmation',
                                    style: TextStyle(
                                        fontFamily: 'QBold',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: const Text(
                                    'Are you sure you want to Logout?',
                                    style: TextStyle(fontFamily: 'QRegular'),
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
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.pushReplacementNamed(
                                            context, '/loginpage');
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
                      }),
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
                const MapTab(),
                NewsTab(),
                AboutUsTab(),
                // ReportTab(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
