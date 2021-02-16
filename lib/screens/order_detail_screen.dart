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
            SizedBox(height: 5),
            //LocationInput(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xEEC31331),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.phone_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFCBB2AB),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.map_outlined,
                        color: Color(0xFF303250),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF79E1B),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.navigation_outlined,
                        color: Color(0xFF303250),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
