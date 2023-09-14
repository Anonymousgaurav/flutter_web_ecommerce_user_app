import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import 'package:user_app/utils/Fonts.dart';

const SPLASH_IMAGE = "assets/images/welcome.png";

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 4), () async {
      if (firebaseAuth.currentUser != null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent,
            Colors.redAccent,
          ],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(SPLASH_IMAGE),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Order Food Online With iFood',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: Fonts.primaryFontFamily,
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    "World's Largest & No.1 Food Delivery App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: Fonts.secondaryFontFamily,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
