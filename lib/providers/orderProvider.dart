import 'package:ShopApp/providers/cartProviders.dart';
import 'package:flutter/material.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime datetime;
  OrderItem({this.datetime, this.id, this.products, this.total});
}

class OrderProvider with ChangeNotifier {
  List<OrderItem> _items = [];
  List<OrderItem> get getOrders {
    return [..._items];
  }

  void addOrder(
    double total,
    List<CartItem> products,
  ) {
    _items.insert(
      0,
      OrderItem(
        datetime: DateTime.now(),
        id: 'OrId' + _items.length.toString(),
        total: total,
        products: products,
      ),
    );
  }
}
