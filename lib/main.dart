import 'package:eCommerce/providers/address_provider.dart';
import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/providers/orders_provider.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:eCommerce/screens/admin/admin_product_upload_screen.dart';
import 'package:eCommerce/screens/splash_screen.dart';
import 'package:eCommerce/screens/user/cart_screen.dart';
import 'package:eCommerce/screens/user/orders_screen.dart';
import 'package:eCommerce/screens/user/place_order_splash_screen.dart';
import 'package:eCommerce/screens/user/product_detail_screen.dart';
import 'package:eCommerce/screens/user/product_overview_screen.dart';
import 'package:eCommerce/screens/user/user_address_screen.dart';
import 'package:eCommerce/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Authentication(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: Addresses(),
        ),
      ],
      child: MaterialApp(
        title: 'Easy Buy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          AdminHomeScreen.routeName: (ctx) => AdminHomeScreen(),
          AdminUploadScreen.routeName: (ctx) => AdminUploadScreen(),
          AddressScreen.routeName: (ctx) => AddressScreen(),
          OrderSplashScreen.routeName: (ctx) => OrderSplashScreen(),
        },
      ),
    );
  }
}
