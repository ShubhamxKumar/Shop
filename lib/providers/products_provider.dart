import 'package:ShopApp/providers/product_overview_model.dart';
import 'package:flutter/material.dart';

// 'with' keywords are used to use mixins which is used in merging
//some features of the extended class within ours but just not returning it in the instance of the extended class.
class ProductsProvider with ChangeNotifier {
// ChangeNotifier class is a inherited class used to build communication tunnels behind the scenes .
// We turned it into a provider beacuse we need to listen to the changes to the list, like add or remove or like that. 
  List<ProdOverview> _items = [
    ProdOverview(
      id: 'p1',
      name: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProdOverview(
      id: 'p2',
      name: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProdOverview(
      id: 'p3',
      name: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProdOverview(
      id: 'p4',
      name: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<ProdOverview> get itemsget {
    return [
      ..._items
    ]; // We return a copy of the data in the the list, becuase we don't want the user to directly interact with the list wherever the list is being provided.
  }

  List<ProdOverview> get favitemsget {
    return _items.where((product) {
      return product.isFav == true;
    }).toList();
  }

  void addProduct() {
    /* _items.add(value); */
    notifyListeners(); // we want the app widget who are listening that the data has changed and that it needs to be rebuild.
  }

  ProdOverview findById(String id) {
    return _items.firstWhere((it) {
      return it.id == id;
    });
  }
}
