import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:advMe/helpers/google_map_aplication_helper.dart';


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

 Future<void> _launchURL() async {
  const url = 'https://flutter.dev';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> _makePhoneCall() async {
  const url = 'tel:723091700';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    //final OrdersItem args = ModalRoute.of(context).settings.arguments;

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure? '),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Are you sure to delete this Adevert? Press Yes to confirm or No to reject.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('YES'),
                onPressed: () async {
                  var firebaseUser = FirebaseAuth.instance.currentUser.uid;

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(firebaseUser)
                      .collection("user_orders")
                      .doc(id)
                      .delete()
                      .then((_) {
                    print("success!");
                  });
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color(0xFFF79E1B),
          ),
          backgroundColor: Color(0xFF171923),
          title: Text('Detail of ' + description),
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showMyDialog();
                }),
          ]),
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
                      onPressed: _makePhoneCall,
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
                        Icons.open_in_browser_outlined,
                        color: Color(0xFF303250),
                      ),
                      onPressed: 
                        _launchURL,
                      
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
                      onPressed:(){
                        MapUtils.openMap(50.2433277,21.7754563);
                      }
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

