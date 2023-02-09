import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:sumilao/screens/add_patient.dart';
import 'package:sumilao/screens/add_user.dart';
import 'package:sumilao/screens/auth/login_page.dart';
import 'package:sumilao/screens/home_screen.dart';
import 'package:sumilao/screens/patient_screen.dart';
import 'package:sumilao/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC-I141Uc0F_xzjysZvIGMgMyTG58Q4FZs",
          appId: "1:794218852632:web:6fb1035f78b9f65c1e6e6d",
          messagingSenderId: "794218852632",
          projectId: "healthcare-system-59e3f",
          storageBucket: "healthcare-system-59e3f.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: ((context, child) {
        return ResponsiveWrapper.builder(child,
            maxWidth: 1500,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(480, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Colors.white));
      }),
      title: 'Municipaliy of Sumilao',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        Routes.loginpage: (context) => LoginPage(),
        Routes.homescreen: (context) => HomeScreen(),
        Routes.userscreen: (context) => UserManagementScreen(),
        Routes.patientscreen: (context) => AddPatient(),
        Routes.patient: (context) => PatientScreen(),
      },
    );
  }
}
