import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import 'package:user_app/utils/DeviceUtils.dart';
import 'package:user_app/utils/Fonts.dart';

const SPLASH_IMAGE = "assets/images/welcome.png";

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  @override
  void initState() {
    super.initState();
    spalshScreenWaitingTime();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.blueAccent,
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
              padding: EdgeInsets.all(_DIMENS.PADDING_ALL),
              child: Image.asset(SPLASH_IMAGE),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(_DIMENS.PADDING_BOTTOM),
              child: Column(
                children: [
                  Text(
                    'Order Food Online',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: DeviceUtils.fractionWidth(context,fraction: 35.0),
                      fontFamily: Fonts.primaryFontFamily,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Food Delivery App",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: DeviceUtils.fractionWidth(context,fraction: 40.0),
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
    ),);
  }

  spalshScreenWaitingTime() {
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

}

abstract class _DIMENS {
  static double PADDING_ALL = 8.0;
  static double PADDING_BOTTOM = 12.0;
}
