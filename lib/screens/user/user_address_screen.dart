import 'package:eCommerce/providers/address_provider.dart';
import 'package:eCommerce/widgets/address_item_widget.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddressScreen extends StatefulWidget {
  static const routeName = '/address';

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final userId = FirebaseAuth.instance.currentUser.uid;
  TextEditingController _userName = TextEditingController();
  TextEditingController _mobileNo = TextEditingController();
  TextEditingController _provinceName = TextEditingController();
  TextEditingController _cityName = TextEditingController();
  TextEditingController _streetAddress = TextEditingController();
  TextEditingController _countryName = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _addressID = Uuid().v4();
  var _isLoading = false;

  /* ************************************************************* */

  _submitAddForm() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Addresses>(context, listen: false)
          .addAddress(
        id: _addressID,
        userId: userId,
        userName: _userName.text.trim(),
        mobileNo: int.parse(_mobileNo.text.trim()),
        countryName: _countryName.text.trim(),
        provinceName: _provinceName.text.trim(),
        cityName: _cityName.text.trim(),
        streetName: _streetAddress.text.trim(),
        postalCode: int.parse(_postalCode.text.trim()),
      )
          .then((_) {
        Navigator.of(context).pop();

        setState(() {
          _addressID = Uuid().v4();
          _isLoading = false;
          _userName.clear();
          _mobileNo.clear();
          _provinceName.clear();
          _cityName.clear();
          _streetAddress.clear();
          _countryName.clear();
          _postalCode.clear();
        });
      });
    }
  }

  _addAddress(context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add New Address',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Positioned(
                child: IconButton(
                  icon: Icon(FontAwesomeIcons.timesCircle),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userName,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.userCircle),
                        hintText: 'Your Name',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        } else if (value.trim().length < 4) {
                          return 'Username must be atleast 4 letters long';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mobileNo,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.phone),
                        hintText: 'Mobile Number',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _countryName,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.globe),
                        hintText: 'Country Name',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your country name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _provinceName,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.map),
                        hintText: 'Province Name',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your province name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _cityName,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.mapSigns),
                        hintText: 'City Name',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your city name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _streetAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.streetView),
                        hintText: 'Street Name',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your street name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _postalCode,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.code),
                        hintText: 'Postal Code',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your postal code';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                child: _isLoading
                    ? circularProgress()
                    : RaisedButton.icon(
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: _submitAddForm,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /* ********************************************************* */

  Container emptyAddressScreen(isPotrait) {
    return Container(
      margin: EdgeInsets.only(top: isPotrait ? 150.0 : 40.0),
      width: double.infinity,
      child: Center(
        child: Column(
          children: [
            Container(
              child: SvgPicture.asset(
                'assets/images/add_address.svg',
                height: isPotrait ? 200.0 : 180.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              child: Text(
                'Add Delivery Address',
                style: TextStyle(
                  fontSize: isPotrait ? 30.0 : 30.0,
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
    final isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: RichText(
              text: TextSpan(
                text: 'Delivery',
                style: GoogleFonts.galada(
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                children: [
                  TextSpan(
                    text: 'Address',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add_location,
              size: 30.0,
            ),
            onPressed: () => _addAddress(context),
          ),
          body: FutureBuilder(
            future: Provider.of<Addresses>(
              context,
              listen: false,
            ).fetchAndSetAddresses(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return circularProgress();
              }
              return Consumer<Addresses>(
                builder: (context, addressData, child) =>
                    addressData.items.isEmpty
                        ? emptyAddressScreen(isPotrait)
                        : ListView.builder(
                            itemCount: addressData.items.length,
                            itemBuilder: (context, index) => AddressCardWidget(
                              address: addressData.items[index],
                              currentIndex: index,
                            ),
                          ),
              );
            },
          ),
        ),
      ),
    );
  }
}
