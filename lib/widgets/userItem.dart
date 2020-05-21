import 'package:ShopApp/providers/products_provider.dart';
import 'package:ShopApp/screens/edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;
  UserItem({this.imageUrl, this.title, this.id});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            imageUrl), // Circle avatar only takes this type of image
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.black,
              onPressed: () {
                print(id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditScreen(id),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.black,
              onPressed: () async {
                try {
                  await Provider.of<ProductsProvider>(context, listen: false)
                      .deleteProd(id);
                } catch (err) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deletion failed due to some error!!'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
