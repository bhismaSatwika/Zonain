import 'package:flutter/material.dart';
import 'package:zonain/Screens/Login/login_screen.dart';
import 'package:zonain/Screens/Signup/signup_screen.dart';
import 'package:zonain/Screens/Welcome/components/background.dart';
import 'package:zonain/components/rounded_button.dart';
import 'package:zonain/constants.dart';
import 'package:zonain/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              "WELCOME TO ZONAIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 110),
              child: Image.asset(
                "assets/icons/ZONAIN1.png",
                height: size.height * 0.45,
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
              color: Color(0xFF665EFF),
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: Color(0xFFE4E7E9),
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
