import 'package:eCommerce/providers/card_provider.dart';
import 'package:eCommerce/providers/products_provider.dart';
import 'package:eCommerce/screens/user/cart_screen.dart';
import 'package:eCommerce/widgets/drawer_widget.dart';
import 'package:eCommerce/widgets/product_item_widget.dart';
import 'package:eCommerce/widgets/progress_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  TextEditingController _searchController = TextEditingController();
  var userId = FirebaseAuth.instance.currentUser.uid;
  var _isSearch = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  _onSearchChanged() {
    Provider.of<Products>(
      context,
      listen: false,
    ).searchResult(_searchController.text.trim());
  }

  _searchInput() {
    return Container(
      child: TextFormField(
        controller: _searchController,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: 'Search',
        ),
      ),
    );
  }

  AppBar appBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: _isSearch
          ? _searchInput()
          : RichText(
              text: TextSpan(
                text: 'Easy',
                style: GoogleFonts.galada(
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                children: [
                  TextSpan(
                    text: 'Buy',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      actions: [
        IconButton(
          icon: Icon(FontAwesomeIcons.search),
          onPressed: () {
            setState(() {
              _isSearch = !_isSearch;
            });
            if (_isSearch == false) {
              _searchController.clear();
              FocusScope.of(context).unfocus();
            }
          },
        ),
        Stack(
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.shoppingCart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            Positioned(
              top: 6.0,
              right: 4.0,
              child: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue,
                ),
                constraints: BoxConstraints(
                  minHeight: 17,
                  minWidth: 17,
                ),
                child: Consumer<Cart>(
                  builder: (_, cart, ch) {
                    return Text(
                      cart.itemCount.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
      centerTitle: true,
    );
  }

  emptyProductsScreen(isPotrait) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: isPotrait ? 200.0 : 50.0),
        width: double.infinity,
        child: Center(
          child: Column(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/images/no_products.svg',
                  height: isPotrait ? 200.0 : 160.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Text(
                  'Products Not Available',
                  style: TextStyle(
                    fontSize: isPotrait ? 30.0 : 25.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPotrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context),
        drawer: DrawerWidget(),
        body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress();
            }
            return Consumer<Products>(
              builder: (context, productsData, _) => productsData.items.isEmpty
                  ? emptyProductsScreen(isPotrait)
                  : GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: productsData.items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 3 / 2,
                        mainAxisSpacing: 20.0,
                      ),
                      itemBuilder: (context, index) =>
                          ChangeNotifierProvider.value(
                        value: productsData.items[index],
                        child: ProductItem(),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
