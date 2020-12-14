import 'dart:async';

import 'package:eCommerce/screens/auth/auth_screen.dart';
import 'package:eCommerce/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User _user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5), () {
      if (_user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AuthScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: _isPortrait ? 200.0 : 200.0,
              child: Lottie.asset('animation/splash.json'),
            ),
            RichText(
              text: TextSpan(
                text: 'Easy',
                style: GoogleFonts.galada(
                  textStyle: TextStyle(
                    fontSize: 56.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                children: [
                  TextSpan(
                    text: 'Buy',
                    style: TextStyle(
                      fontSize: 56.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
