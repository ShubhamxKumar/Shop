import 'package:ShopApp/providers/cartProviders.dart';
import 'package:ShopApp/providers/orderProvider.dart';
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
    return MultiProvider(
      // this widget is used if we have more than one providers
      providers: [
        ChangeNotifierProvider(  // .value method should not be used when providing a brand new provider .
          create: (context) {
            return ProductsProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return CartProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return OrderProvider();
          },
        )
      ], // this here takes a list of providers to which the child can listen to
      child: MaterialApp(
        title: 'MyShop',
        home: ProductOverviewScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
