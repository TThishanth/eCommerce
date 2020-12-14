import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/screens/user/user_address_screen.dart';
import 'package:eCommerce/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  Container emptyCartScreen(isPotrait) {
    return Container(
      margin: EdgeInsets.only(top: isPotrait ? 100.0 : 10.0),
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            Container(
              child: SvgPicture.asset(
                'assets/images/empty_cart.svg',
                height: isPotrait ? 200.0 : 120.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Text(
                'Cart Empty',
                style: TextStyle(
                  fontSize: isPotrait ? 30.0 : 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      child: Text(
                        'PROCEED',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(AddressScreen.routeName);
                      },
                    )

                    //FlatButton(
                    //  child: _isLoading ? circularProgress() : Text('PROCEED'),
                    //  onPressed: (cart.totalAmount <= 0 || _isLoading)
                    //      ? null
                    //      : () {
                    //          setState(() {
                    //            _isLoading = true;
                    //          });
                    //          Provider.of<Orders>(context, listen: false)
                    //              .addOrder(
                    //            cart.items.values.toList(),
                    //            cart.totalAmount,
                    //            userId,
                    //            cartId,
                    //          )
                    //              .then((_) {
                    //            cart.clear();
                    //            Navigator.of(context).pushReplacementNamed(AddressScreen.routeName);
                    //            setState(() {
                    //              _isLoading = false;
                    //              cartId = Uuid().v4();
                    //            });
                    //          });
                    //        },
                    //  textColor: Theme.of(context).primaryColor,
                    //),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: cart.items.isEmpty
                  ? emptyCartScreen(isPotrait)
                  : ListView.builder(
                      itemCount: cart.itemCount,
                      itemBuilder: (context, index) => CartItemWidget(
                        id: cart.items.values.toList()[index].id,
                        productId: cart.items.keys.toList()[index],
                        price: cart.items.values.toList()[index].price,
                        quantity: cart.items.values.toList()[index].quantity,
                        title: cart.items.values.toList()[index].title,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
