import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/screens/auth/auth_screen.dart';
import 'package:eCommerce/screens/home_screen.dart';
import 'package:eCommerce/screens/user/orders_screen.dart';
import 'package:eCommerce/screens/user/product_overview_screen.dart';
import 'package:eCommerce/services/auth_services.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final currentUserId = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(
      context,
      listen: false,
    );
    return FutureBuilder(
      future: usersRef.doc(currentUserId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return circularProgress();
        }
        final userData = snapshot.data;
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  userData['userName'],
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  userData['email'],
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(userData['profilePhoto']),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              ),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.home,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Home'),
                onTap: () {
                  productsContainer.showAll();
                  Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('Wish List'),
                onTap: () {
                  productsContainer.showFavoritesOnly();
                  Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('My Orders'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: Theme.of(context).accentColor,
                ),
                title: Text('LogOut'),
                onTap: () {
                  Provider.of<Authentication>(context, listen: false)
                      .signOut()
                      .whenComplete(
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AuthScreen(),
                          ),
                        ),
                      );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
