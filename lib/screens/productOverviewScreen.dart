import 'package:ShopApp/providers/product_overview_model.dart';
import 'package:ShopApp/providers/products_provider.dart';
import 'package:ShopApp/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(
        context); // its not the list of products, but the object based on the class. And this how we create a listener.
    // this will now listen to changes in the Provider class we provided in the root widget i.e. MyApp in main.dart.
    // it is important to mention which provider class we need to listen to in 'of<>'
    final productsList = isFav
        ? products.favitemsget
        : products
            .itemsget; // this is a list as we called the getter that we defined in the Provider class.
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == 1) {
                  isFav = true;
                } else {
                  isFav = false;
                }
              });
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('All'),
                  value: 0,
                ),
                PopupMenuItem(
                  child: Text('Favorites'),
                  value: 1,
                ),
              ];
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          )
        ],
        centerTitle: true,
        title: Text(
          'ShopNSell',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'JosefinSans',
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: productsList.isEmpty
          ? Center(
              child: Text('No Products, Try adding some'),
            )
          : GridView.builder(
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                  // we provide another Provider because we want to listen to the changes in every items isFav property.
                  //we are using .value because in grids when your item goes of the screen, flutter disposes them and then when they
                  // reappear on the screen, it shows a bug, but if we use .value flutter recycles them.
                  // also . value can be used if the Provider don't have to do anything with the context argument.
                  value: productsList[index],
                  child: ProductItem(),
                );
              },
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width - 20,
                mainAxisSpacing: 20,
                crossAxisSpacing: 0,
              ),
            ),
    );
  }
}
