import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/providers/product_provider.dart';
import 'package:eCommerce/screens/user/product_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProductItem extends StatefulWidget {
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final ownerId = FirebaseAuth.instance.currentUser.uid;
  String cartId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: Container(
          padding: EdgeInsets.only(top: 48.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        header: GridTileBar(
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.deepOrange,
              onPressed: () {
                product.toggleFavoriteStatus(
                    productId: product.id, userId: ownerId);
              },
            ),
          ),
          title: Text(
            '\$' + product.price.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              cart.addItem(
                product.id,
                product.price,
                product.title,
                cartId,
              );

              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Theme.of(context).primaryColor,
                  action: SnackBarAction(
                    label: 'UNDO',
                    textColor: Colors.white,
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );

              setState(() {
                cartId = Uuid().v4();
              });
            },
          ),
        ),
      ),
    );
  }
}
