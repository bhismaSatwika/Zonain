import 'package:flutter/material.dart';
import 'package:zonain/Screens/Login/login_screen.dart';
import 'package:zonain/Screens/Signup/signup_screen.dart';
import 'package:zonain/Screens/Welcome/components/background.dart';
import 'package:zonain/components/rounded_button.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              "WELCOME TO ZONAIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 110),
              child: Image.asset(
                "assets/icons/ZONAIN1.png",
                height: size.height * 0.45,
              ),
            ),
            const SizedBox(height: 20),
            RoundedButton(
              color: const Color(0xFF665EFF),
              text: "LOGIN",
              press: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: const Color(0xFFE4E7E9),
              textColor: Colors.black,
              press: () {
                Navigator.pushNamed(context, SignUpScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
