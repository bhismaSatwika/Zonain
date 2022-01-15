import 'package:flutter/material.dart';
import 'package:zonain/Screens/Welcome/components/body.dart';
import 'package:zonain/constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Body(),
    );
  }
}
