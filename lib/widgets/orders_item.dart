import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersItem extends StatelessWidget {
  final String id;
  final String description;
  final bool isFavorite;
  final String imageUrl;

  OrdersItem({
    @required this.id,
    @required this.description,
    @required this.isFavorite,
    @required this.imageUrl,
  });

 
  @override
  Widget build(BuildContext context) {
     var username = FirebaseAuth.instance.currentUser.displayName.toString();
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(left:15.0, right: 15.0),
        child: Card(
          color: Color(0x40303250),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: EdgeInsets.all(5),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      
                      SizedBox(height: 20),
                      Container(
                        color: Color(0x40303250),
                        child: Text(
                          description,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ))
              ],
          ),
        ),
      ),
    );
  }
}
