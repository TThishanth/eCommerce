import 'dart:math';

import 'package:eCommerce/providers/orders_provider.dart';
import 'package:eCommerce/screens/user/product_overview_screen.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;
  OrderItemWidget({this.order});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 2.0,
        vertical: 3.0,
      ),
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            color: Colors.blue,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'ID: ' + widget.order.id,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
              height: min(widget.order.products.length * 20.0 + 200, 250),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: widget.order.products
                          .map(
                            (prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${prod.quantity}x \$${prod.price}',
                                  style: TextStyle(
                                    fontSize: 18.8,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(),
                  Container(
                    child: Text(
                      'Total Amount: \$${widget.order.amount.toString()}',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Text(
                      'Ordered Date & Time: ' +
                          DateFormat('dd/MM/yyyy hh:mm')
                              .format(widget.order.dateTime),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Text(
                      'shipping Status: ${widget.order.shippingStatus}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(),
                  _isLoading
                      ? circularProgress()
                      : RaisedButton(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Order Recieved',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            Provider.of<Orders>(context, listen: false)
                                .conformReceived(
                              widget.order.ownerId,
                              widget.order.id,
                            )
                                .then((_) {
                              Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          },
                        ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
