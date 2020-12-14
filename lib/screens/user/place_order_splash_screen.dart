import 'dart:async';

import 'package:eCommerce/screens/user/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OrderSplashScreen extends StatefulWidget {
  static const routeName = '/place-order';
  @override
  _OrderSplashScreenState createState() => _OrderSplashScreenState();
}

class _OrderSplashScreenState extends State<OrderSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context)
          .pushReplacementNamed(ProductsOverviewScreen.routeName);
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
              child: Lottie.asset('animation/home-delivery.json'),
            ),
            RichText(
              text: TextSpan(
                text: 'Cash',
                style: GoogleFonts.galada(
                  textStyle: TextStyle(
                    fontSize: 56.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                children: [
                  TextSpan(
                    text: 'On',
                    style: TextStyle(
                      fontSize: 56.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  TextSpan(
                    text: 'Delivery',
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
