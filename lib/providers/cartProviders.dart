import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({this.id, this.title, this.price, this.quantity, this.imageUrl});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items =
      {}; // we did this because every cart item will have different id than product. So we map cartitem with
  // a string which will be product id.

  Map<String, CartItem> get cartItem {
    return {..._items};
  }

  int get numberOfItems {
    int count = 0;
    _items.forEach((key, cartItem) {
      count += cartItem.quantity;
    });
    return count;
  }

  double get getTotal {
    double total=0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem (String id){
    _items.removeWhere((key, cartItem) {
      return cartItem.id == id;
    });
    notifyListeners();
  }

  void addCartItem(
    String productId,
    double price,
    String title,
    String imageUrl,
  ) {
    if (_items.containsKey(productId)) {
      // We did this check so that if the cart item already exist then we will just increase
      // the quantity.
      _items.update(
        productId,
        (existingobject) {
          return CartItem(
            title: existingobject.title,
            id: existingobject.id,
            price: existingobject.price,
            quantity: existingobject.quantity + 1,
            imageUrl: imageUrl,
          );
        },
      );
    } else {
      _items.putIfAbsent(
        productId,
        () {
          return CartItem(
            id: 'cId' + productId,
            price: price,
            quantity: 1,
            title: title,
            imageUrl: imageUrl,
          );
        },
      );
    }
    notifyListeners();
  }

  void clearCart () {
    _items = {};
    notifyListeners();
  }
}
