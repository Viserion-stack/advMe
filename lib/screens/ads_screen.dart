import 'dart:io';

import 'package:advMe/providers/ad_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key}) : super(key: key);

  static const routeName = '/adsScreen';

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  File _pickedImage;
  bool isPhoto = false;

  void _pickImage() async {
    // ignore: deprecated_member_use
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      //maxWidth: 450,
      //maxHeight: 450,
    );
    setState(() {
      _pickedImage = pickedImageFile;
    });
    isPhoto = true;
    //widget.imagePickFn(pickedImageFile);
  }

  final descriptionController = TextEditingController();
  final titleController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171923),
      //drawer: Drawer(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.chevron_left,
                          color: Color(0xFFF79E1B),
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Color(0x40F79E1B),
                            //       offset: Offset(2.0, 2.0),
                            //       blurRadius: 5.0,
                            //       spreadRadius: 1.0),
                            //   BoxShadow(
                            //       color: Color(0x40F79E1B),
                            //       offset: Offset(-2.0, -2.0),
                            //       blurRadius: 5.0,
                            //       spreadRadius: 1.0),
                            // ],
                            color: Color(0x40303250))),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),

              height: 300,
              width: 300, //MediaQuery.of(context).size.width,
              child: _pickedImage == null
                  ? Center(
                      child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _pickImage,
                    ))
                  : FittedBox(
                      child: Image.file(
                        _pickedImage,
                        //scale: 50,
                      ),
                      fit: BoxFit.fill,
                    ),
            ),
            Container(
                child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Tilte', hintStyle: TextStyle(color: Colors.white)),
              controller: titleController,
            )),
            SizedBox(height: 50),
            Container(
                child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.white)),
              controller: descriptionController,
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            addPost(new DateTime.now(), titleController.text.toString(),
                descriptionController.text.toString(), _pickedImage);
          }),
    );
  }
}
