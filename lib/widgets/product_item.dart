import 'package:ShopApp/providers/cartProviders.dart';
import 'package:ShopApp/providers/product_overview_model.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedProduct = Provider.of<ProdOverview>(context,
        listen: false); // this is a listener.
    /* Now this type of listener is fine but, what it does is that whenever the data changes it rebuilds the entire widget
    and what if only one part of that widget is actually concerned with the changes and not the other one, here in this case
    only the favorite button is concerned with the chnages in the data and no other container is concerned. so thats why
    we can also use Consumer approach which wraps arounds a widget which is concerned with the data.
    Also we can wrap thw whole widget here with Consumer too. But as we are going to wrap only the Icon button but then all the 
    other containers needs data too, thats why we will use the Provider listener too but with listen = false so that it atleast
    once listen to the data.
     */
    final cartObject = Provider.of<CartProvider>(context);
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Card(
        elevation: 0,
        child: Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProductDetailScreen(selectedProduct.id)));
                },
                child: Container(
                  child: Image.network(selectedProduct.imageUrl,
                      fit: BoxFit.cover),
                  width: MediaQuery.of(context).size.width - 20,
                  height: 250,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Center(
                      child: Text(
                        selectedProduct.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Consumer<ProdOverview>(
                      // this is syntax of Consumer method, a lot similar to the Provider method above.
                      // this method helps with performance in larger apps.
                      builder: (context, selectedProduct, child) {
                        return IconButton(
                          icon: Icon(
                            selectedProduct.isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          color: Colors.amber,
                          onPressed: () {
                            selectedProduct.favoriteToggler(selectedProduct.id);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                      ),
                      color: Colors.amber,
                      onPressed: () {
                        cartObject.addCartItem(selectedProduct.id, selectedProduct.price, selectedProduct.name, selectedProduct.imageUrl);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
