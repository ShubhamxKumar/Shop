import 'package:ShopApp/providers/products_provider.dart';
import 'package:ShopApp/screens/edit.dart';
import 'package:ShopApp/widgets/userItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsItem extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<ProductsProvider>(context).getProductsfromServer();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context)
        .itemsget; // we attached a listener.
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditScreen(null)));
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          'Manage Products',
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
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
              child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return UserItem(
              imageUrl: products[index].imageUrl,
              title: products[index].name,
              id: products[index].id,
            );
          },
        ),
      ),
    );
  }
}
