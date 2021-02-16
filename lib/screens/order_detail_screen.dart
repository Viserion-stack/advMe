import 'package:advMe/widgets/orders_item.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = '/orderl-detail';

  @override
  Widget build(BuildContext context) {
    final OrdersItem args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFF79E1B),
        ),
        backgroundColor: Color(0xFF171923),
        title: Text('Detail of ' + args.description),
      ),
      backgroundColor: Color(0x40303250),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(args.imageUrl),
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
              args.description,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 28,
              ),
            ),
            SizedBox(height: 5),
            //LocationInput(),
             SizedBox(height: 5,),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.phone_outlined, color: Colors.white54,),
                  onPressed: () {



                  },
                ),
                IconButton(
                  icon: Icon(Icons.map_outlined, color: Colors.white54,),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.navigation_outlined, color: Colors.white54,),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
