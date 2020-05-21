import 'package:ShopApp/providers/product_overview_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // a package used for sending http requests.
import 'dart:convert'; // used to convert maps to json so that we can send post requests.

// 'with' keywords are used to use mixins which is used in merging
//some features of the extended class within ours but just not returning it in the instance of the extended class.
class ProductsProvider with ChangeNotifier {
// ChangeNotifier class is a inherited class used to build communication tunnels behind the scenes .
// We turned it into a provider beacuse we need to listen to the changes to the list, like add or remove or like that.
  List<ProdOverview> _items = [
    /* ProdOverview(
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
    ), */
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

  Future<void> addProduct(ProdOverview prod) async {
    // we use async keyword in front of code that we want to make asynchronous.
    try {
      // try is wrapped around the code which we think might fail during runtime due to some error.
      const url = "https://flutter-40711.firebaseio.com/products.json";
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': prod.name,
            'description': prod.description,
            'price': prod.price,
            'isFav': prod.isFav,
            'imageUrl': prod.imageUrl,
          },
        ),
      );
      final newProd = ProdOverview(
        name: prod.name,
        description: prod.description,
        price: prod.price,
        imageUrl: prod.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProd);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // an alternative method to async and await.

  /* Future<void> addProduct(ProdOverview prod) {
    // now this addProduct function returns a Future, but nothing special in futurethat we need so that's why void, which we will use in the edit screen
    const url =
        "https://flutter-40711.firebaseio.com/products.json"; // just a url to which we send http requests. '.json' is important For Just Firebase
    return http // since then also returns a future hence we return the block.
        .post(
      url,
      body: json.encode(
        // we cant directly pass the prod, because it converts only maps to json.
        {
          'title': prod.name,
          'description': prod.description,
          'price': prod.price,
          'isFav': prod.isFav,
          'imageUrl': prod.imageUrl,
          'id': prod.id,
        },
      ),
      // http.post returns a future, meaning a method that fires a function when the request is complete.
    )
        .then(
      (response) {
        // this function recieves a response argument from the server.
        // now this function will execute when the post request get complete.
        final newProd = ProdOverview(
          name: prod.name,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl,
          id: json.decode(response.body)['name'],
        );
        _items.add(newProd);
        /* _items.add(value); */
        notifyListeners(); // we want the app widget who are listening that the data has changed and that it needs to be rebuild.
      },
    ).catchError((err) {
      print(err);
      // the code in '.then' will be skipped if a error id found 
      throw err;
      // throw is used to throw another error and in this case we are throwing the same error again so that we acn catch it
      // again in the edit screen.
    });
  }
 */

  Future<void> getProductsfromServer() async {
    print('running');
    const url = "https://flutter-40711.firebaseio.com/products.json";
    try {
      final response =
          await http.get(url); // we need to wait for this code to happen.
      print(json.decode(response.body));
      final extractedData = json.decode(response.body)
          as Map<String, dynamic>; // now extractedData will give back us a map;
      List<ProdOverview> _loadedProd = [];
      extractedData.forEach(
        (prodId, data) {
          _loadedProd.add(
            ProdOverview(
              id: prodId,
              description: data['description'],
              name: data['title'],
              imageUrl: data['imageUrl'],
              isFav: data['isFav'],
              price: data['price'],
            ),
          );
        },
      );
      _items = _loadedProd;
      notifyListeners();
      print('finished');
    } catch (err) {
      throw err;
    }
  }

  ProdOverview findById(String id) {
    return _items.firstWhere((it) {
      return it.id == id;
    });
  }

  Future<void> deleteProd(String id) async {
    final url = "https://flutter-40711.firebaseio.com/products/$id.json";
    final deletedproductind = _items.indexWhere((e) {return e.id == id;});
    var deletedproduct = _items[deletedproductind];
    _items.removeAt(deletedproductind);
    // delete and patch request unlike other request in http package do not throw error, so even if we get an error we would not know it.
    // hence we need to check the status code.
    http.delete(url).then((response) {
      if(response.statusCode >= 400){
        // 400 and 500 are for errors by users and servers.
        throw response;
      }
      deletedproduct = null;
    }).catchError((err) {
      _items.insert(deletedproductind, deletedproduct);
      notifyListeners();
    });
    notifyListeners();
    // all this checks because id deleted request fails then the product dont get deleted from memory also.
  }

  Future<void> updateProd(ProdOverview prod, String id) async {
    var index = _items.indexWhere((element) => element.id == id);
    print(index);
    final url =
        "https://flutter-40711.firebaseio.com/products/$id.json"; // it helps to send the specific id which we want
    // to update.
    try {
      await http.patch(url,
          body: json.encode({
            'title': prod.name,
            'description': prod.description,
            'price': prod.price,
            'imageUrl': prod.imageUrl,
          }));
      _items[index] = prod;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}
