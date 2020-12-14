import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatefulWidget {
  final String id;
  final String title;
  final String status;
  final String price;
  final String imageUrl;
  UserProductItem({
    this.id,
    this.title,
    this.status,
    this.price,
    this.imageUrl,
  });

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  TextEditingController _productStatus = TextEditingController();
  TextEditingController _productPrice = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _productStatus.text = widget.status;
      _productPrice.text = widget.price;
    });
  }

  _submitEditForm(productId) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .editProduct(
      productId,
      _productStatus.text.trim(),
      _productPrice.text.trim(),
    )
        .then((_) {
      Navigator.of(context).pop();

      setState(() {
        _isLoading = false;
        _productStatus.clear();
        _productPrice.clear();
      });
    });
  }

  @override
  void dispose() {
    _productStatus.dispose();
    _productPrice.dispose();
    super.dispose();
  }

  _editProduct(context) {
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
                'Edit Product',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Positioned(
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.timesCircle,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          content: Column(
            children: [
              Container(
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _productStatus,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.hourglassStart),
                        hintText: 'Product Status',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter new product status';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _productPrice,
                      decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.moneyBill),
                        hintText: 'Product Price',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter new product price';
                        }
                        return null;
                      },
                    ),
                    Divider(),
                    _isLoading
                        ? circularProgress()
                        : Container(
                            child: RaisedButton.icon(
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
                              onPressed: () => _submitEditForm(widget.id),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: ListTile(
        title: Text(widget.title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.imageUrl),
        ),
        trailing: Container(
          width: 100.0,
          child: Row(
            children: [
              Container(
                child: IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: () => _editProduct(context),
                ),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {
                    try {
                      Provider.of<Products>(context, listen: false)
                          .deleteProduct(widget.id);
                    } catch (error) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Deleting failed!'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
