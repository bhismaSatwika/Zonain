import 'package:flutter/material.dart';
import 'package:zonain/Screens/Welcome/components/body.dart';
import 'package:zonain/constants.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackground,
      body: Body(),
    );
  }
}
