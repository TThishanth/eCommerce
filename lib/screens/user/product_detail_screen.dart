import 'dart:async';

import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/screens/user/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String cartId = Uuid().v4();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _addCart(product, cart, context) {
    cart.addItem(
      product.id,
      product.price,
      product.title,
      cartId,
    );

    SnackBar snackBar = SnackBar(
      content: Text(
        'Added item to cart',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.white,
        onPressed: () {
          cart.removeSingleItem(product.id);
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );

    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);

    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context)
          .pushReplacementNamed(ProductsOverviewScreen.routeName),
    );

    setState(() {
      cartId = Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(product.title),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300.0,
                width: double.infinity,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                child: Text(
                  product.shortInfo,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price}',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Text(
                      product.status,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: double.infinity,
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: RaisedButton.icon(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: Text(
                    'ADD TO CART',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => _addCart(product, cart, context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
