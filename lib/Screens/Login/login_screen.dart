import 'package:flutter/material.dart';
import 'package:zonain/Screens/Login/components/body.dart';
import 'package:zonain/constants.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login_page.dart';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackground,
      body: Body(),
    );
  }
}
