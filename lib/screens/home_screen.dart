import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:eCommerce/screens/user/product_overview_screen.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final usersAddress = FirebaseFirestore.instance.collection('addresses');
final userProductOrders = FirebaseFirestore.instance.collection('userOrders');

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: usersRef.doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return circularProgress();
            break;
          default:
            return checkRole(snapshot.data);
        }
      },
    );
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data()['role'] == 'admin') {
      return AdminHomeScreen();
    } else {
      return ProductsOverviewScreen();
    }
  }
}
