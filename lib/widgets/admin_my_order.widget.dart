import 'dart:math';
import 'package:eCommerce/providers/address_provider.dart';
import 'package:eCommerce/providers/orders_provider.dart';
import 'package:eCommerce/screens/admin/admin_home_screen.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminMyOrderWidget extends StatefulWidget {
  final OrderItem order;
  AdminMyOrderWidget({this.order});

  @override
  _AdminMyOrderWidgetState createState() => _AdminMyOrderWidgetState();
}

class _AdminMyOrderWidgetState extends State<AdminMyOrderWidget> {
  String userName;
  int mobileNo;
  String countryName;
  String provinceName;
  String cityName;
  String streetName;
  int postalCode;
  var _expanded = false;
  var _isLoading = false;
  var _isButtonLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Addresses>(
      context,
      listen: false,
    ).getOrderAddress(widget.order.ownerId, widget.order.addressId).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _addressData = Provider.of<Addresses>(context).addressData;
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
              height: min(widget.order.products.length * 20.0 + 400, 500),
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
                        //color: Colors.black,
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
                  Divider(),
                  Container(
                    child: _isLoading
                        ? circularProgress()
                        : Card(
                            elevation: 5.0,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Icon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        color: Colors.blueGrey,
                                        size: 20.0,
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
                                                  'Customer Name: ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _addressData.userName,
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                                                  'Mobile Number: ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _addressData.mobileNo
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                                                  'Country Name: ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _addressData.countryName,
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                                                  'Province Name: ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _addressData.provinceName,
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _addressData.cityName,
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _addressData.streetName,
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                                                    color: Colors.black,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _addressData.postalCode
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(),
                  _isButtonLoading
                      ? circularProgress()
                      : RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Conform Shipment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isButtonLoading = true;
                            });
                            Provider.of<Orders>(context, listen: false)
                                .conformShipment(
                              widget.order.ownerId,
                              widget.order.id,
                            )
                                .then((_) {
                              Navigator.of(context).pushReplacementNamed(AdminHomeScreen.routeName);
                              setState(() {
                                _isButtonLoading = false;
                              });
                            });
                          },
                        ),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
