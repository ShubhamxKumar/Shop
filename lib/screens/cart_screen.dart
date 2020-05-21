import 'package:ShopApp/providers/cartProviders.dart';
import 'package:ShopApp/providers/orderProvider.dart';
import 'package:ShopApp/screens/orderScreen.dart';
import 'package:ShopApp/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final _cartitems = cart.cartItem;
    final order = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Your Cart',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'JosefinSans',
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: (cart.getTotal == 0.0)
          ? Center(
              child: Text('No items in the cart, try adding some'),
            )
          : ListView(
              children: <Widget>[
                Card(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('${cart.getTotal}'),
                        FlatButton(
                          onPressed: () {
                            order.addOrder(cart.getTotal, _cartitems.values.toList());
                            cart.clearCart();
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => OrderScreen()));
                          },
                          child: Text('Order NOW'),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: _cartitems.values.map((citem) {
                    return CartItemWidget(
                      imageUrl: citem.imageUrl,
                      price: citem.price,
                      quantity: citem.quantity,
                      title: citem.title,
                      id: citem.id,
                    );
                  }).toList(),
                )
              ],
            ),
    );
  }
}
