import 'package:ShopApp/providers/products_provider.dart';
import 'package:ShopApp/screens/productOverviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider is a class provided by the Provider Package which help us to create a Provider(A data store)
    // and a listener to which all the child widget can listen to.
    return ChangeNotifierProvider(
      create: (ctx) {
        return ProductsProvider(); // it provides an instance of the class to all the child widget
        // we are not using .value approach because everytime the Provider changes we want to pass on a new instance of the Provider
        // and dispose the old one not recycle it. 
      },
      child: MaterialApp(
        title: 'MyShop',
        home: ProductOverviewScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
