import 'package:flutter/material.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key}) : super(key: key);

  static const routeName = '/adsScreen';

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171923),
      //drawer: Drawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFF79E1B),
        ), //change your color here
        backgroundColor: Color(0xFF171923),
      ),
    );
  }
}
