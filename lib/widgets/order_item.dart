import 'package:ShopApp/providers/orderProvider.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem item;
  OrderItemWidget(this.item);
  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Total'),
              subtitle: Text(widget.item.id),
              trailing: Text(widget.item.total.toString()),
            ),
            Divider(),
            Container(
              height: 90,
              child: ListView(
                children: widget.item.products.map((prod) {
                  return Row(
                    children: <Widget>[
                      Text(prod.title),
                      Text(prod.quantity.toString() + 'x'),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
