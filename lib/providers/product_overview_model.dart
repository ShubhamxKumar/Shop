import 'package:flutter/foundation.dart';
// We turned it into a Provider because we need to listen to the changes in the isFav bool variable;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProdOverview with ChangeNotifier {
  @required
  final String name;
  @required
  final String id;
  @required
  final String description;
  final String imageUrl;
  @required
  final double price;
  @required
  bool isFav;

  ProdOverview({
    @required this.name,
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    this.isFav = false,
    @required this.price,
  });

  Future<void> favoriteToggler(String id) async {
    final url = "https://flutter-40711.firebaseio.com/products/$id";
    isFav = !isFav;
    notifyListeners(); // this is as usual use to notify the Provider and the listeners of any changes .
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          'isFav': isFav,
        }),
      );
      if(response.statusCode >= 400){
        throw response;
      }
    } catch (err) {
      print(err);
      isFav = !isFav;
      notifyListeners();
    }
  }
}
