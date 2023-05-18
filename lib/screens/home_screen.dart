import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/screens/tabs/about_us_tab.dart';
import 'package:sumilao/screens/tabs/map_tab.dart';
import 'package:sumilao/screens/tabs/news_tab.dart';
import 'package:sumilao/screens/tabs/patient_list_tab.dart';
import 'package:sumilao/screens/tabs/report_tab.dart';
import 'package:sumilao/services/local_storage.dart';
import 'package:sumilao/utils/colors.dart';
import 'package:sumilao/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBold(text: 'GeoFinds', fontSize: 38, color: primary),
                      SizedBox(
                        width: 750,
                        child: TabBar(
                            indicatorColor: primary,
                            unselectedLabelColor: Colors.grey,
                            labelColor: primary,
                            labelStyle: TextStyle(
                                color: primary,
                                fontFamily: 'QBold',
                                fontSize: 14),
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
                              Tab(
                                text: 'STATISTICS',
                              ),
                            ]),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  box.read('user') == 'Admin'
                      ? PopupMenuButton(
                          icon: const Icon(Icons.menu),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: (() {
                                    Navigator.pushNamed(
                                        context, '/patientscreen');
                                  }),
                                  child: TextBold(
                                      text: 'Add New Patient',
                                      fontSize: 14,
                                      color: primary),
                                ),
                              ),
                              PopupMenuItem(
                                  child: TextButton(
                                      onPressed: (() {
                                        Navigator.pushNamed(
                                            context, '/userscreen');
                                      }),
                                      child: box.read('user') == 'Admin'
                                          ? TextBold(
                                              text: 'Add User',
                                              fontSize: 14,
                                              color: primary)
                                          : const SizedBox())),
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: (() {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Logout Confirmation',
                                                style: TextStyle(
                                                    fontFamily: 'QBold',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to Logout?',
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
                                                    await FirebaseAuth.instance
                                                        .signOut();
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            '/loginpage');
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
                                  }),
                                  child: TextRegular(
                                      text: 'Logout',
                                      fontSize: 12,
                                      color: Colors.red),
                                ),
                              ),
                            ];
                          },
                        )
                      : PopupMenuButton(
                          icon: const Icon(Icons.menu),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: (() {
                                    Navigator.pushNamed(
                                        context, '/patientscreen');
                                  }),
                                  child: TextBold(
                                      text: 'Add New Patient',
                                      fontSize: 14,
                                      color: primary),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextButton(
                                  onPressed: (() {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Logout Confirmation',
                                                style: TextStyle(
                                                    fontFamily: 'QBold',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: const Text(
                                                'Are you sure you want to Logout?',
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
                                                    await FirebaseAuth.instance
                                                        .signOut();
                                                    Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            '/loginpage');
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
                                  }),
                                  child: TextRegular(
                                      text: 'Logout',
                                      fontSize: 12,
                                      color: Colors.red),
                                ),
                              ),
                            ];
                          },
                        )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(children: [
                const PatientListTab(),
                const MapTab(),
                const NewsTab(),
                AboutUsTab(),
                ReportTab(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
