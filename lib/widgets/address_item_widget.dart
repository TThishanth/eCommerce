import 'package:eCommerce/providers/address_provider.dart';
import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/providers/orders_provider.dart';
import 'package:eCommerce/screens/user/place_order_splash_screen.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddressCardWidget extends StatefulWidget {
  final Address address;
  final int currentIndex;
  AddressCardWidget({this.address, this.currentIndex});

  @override
  _AddressCardWidgetState createState() => _AddressCardWidgetState();
}

class _AddressCardWidgetState extends State<AddressCardWidget> {
  final _userId = FirebaseAuth.instance.currentUser.uid;
  String _orderId = Uuid().v4();
  var _isLoading = false;
 

  _placeOrder(addressId, cart) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Orders>(context, listen: false)
        .addOrder(
      cart.items.values.toList(),
      cart.totalAmount,
      _userId,
      _orderId,
      addressId,
    )
        .then((_) {
      cart.clear();
      Navigator.of(context).pushReplacementNamed(OrderSplashScreen.routeName);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: GestureDetector(
        onTap: () => _placeOrder(widget.address.id, cart),
        child: _isLoading ? circularProgress() : Card(
          elevation: 5.0,
          color: Colors.blueGrey,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Province Name: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.address.provinceName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'City Name: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.address.cityName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Street Name: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.address.streetName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Postal Code: ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.address.postalCode.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
