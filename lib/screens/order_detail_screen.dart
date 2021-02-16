import 'package:advMe/widgets/orders_item.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/orderl-detail';

  String id;
  String description;
  bool isFavorite;
  String imageUrl;

  OrderDetailScreen(
    this.id,
    this.description,
    this.isFavorite,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
    //final OrdersItem args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFF79E1B),
        ),
        backgroundColor: Color(0xFF171923),
        title: Text('Detail of ' + description),
      ),
      backgroundColor: Color(0x40303250),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(imageUrl),
            SizedBox(
              height: 50,
            ),
            Text(
              'Description:',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 15,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
