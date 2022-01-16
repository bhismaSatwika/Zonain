import 'package:flutter/material.dart';
import 'package:zonain/Screens/Login/login_screen.dart';
import 'package:zonain/Screens/Signup/signup_screen.dart';
import 'package:zonain/Screens/Welcome/welcome_screen.dart';
import 'package:zonain/common/navigation.dart';
import 'package:zonain/model/user_details.dart';
import 'package:zonain/ui/home_page.dart';
import 'package:zonain/ui/profile_page.dart';
import 'package:zonain/ui/report_map_page.dart';
import 'package:zonain/ui/see_reports_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zonain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomeScreen.routeName,
      navigatorKey: navigatorKey,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        ReportMapPage.routeName: (context) => const ReportMapPage(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        SeeReportsPage.routeName: (context) => const SeeReportsPage(),
        Profile.routeName: (context) => Profile(
            user: (ModalRoute.of(context)?.settings.arguments as UserDetails))
      },
    );
  }
}
