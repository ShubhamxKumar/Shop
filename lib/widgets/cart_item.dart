import 'package:ShopApp/providers/cartProviders.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;
  final String id;
  CartItemWidget({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        cart.removeItem(id);
      },
      direction: DismissDirection.endToStart,
      background: Container(color: Colors.red),
      child: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: Card(
          elevation: 0,
          child: Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                  width: MediaQuery.of(context).size.width - 20,
                  height: 250,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text('Price Per Item: $price'),
                      Text('Quantity: $quantity'),
                      Text('Total: ${(quantity * price)}')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
