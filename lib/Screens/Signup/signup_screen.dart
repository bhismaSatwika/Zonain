import 'package:flutter/material.dart';
import 'package:zonain/Screens/Signup/components/body.dart';
import 'package:zonain/constants.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = '/sign_up_page';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackground,
      body: Body(),
    );
  }
}
