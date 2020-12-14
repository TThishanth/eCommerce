import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eCommerce/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _timestamp = DateTime.now();

  // FirebaseAuth Sign In
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User _user = userCredential.user;

    if (_user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    }

    notifyListeners();
  }

  // FirebaseAuth Sign Up
  Future<void> signUp(String userName, String email, String password,
      BuildContext context) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    User _user = userCredential.user;

    if (_user != null) {
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
        'uid': _user.uid,
        'userName': userName,
        'email': email,
        'profilePhoto': 'https://ui-avatars.com/api/?name=$userName&background=FF5500&color=fff&length=1%27',
        'role': 'user', // user for normal users, admin for admin
        'timestamp': _timestamp,
      }).whenComplete(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      });
    }

    notifyListeners();
  }

  // Forgot Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);

    notifyListeners();
  }

  // FirebaseAuth SignOut
  Future<void> signOut() async {
    await _auth.signOut();

    notifyListeners();
  }
}
