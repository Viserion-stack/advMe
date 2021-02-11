import 'dart:io';
import 'package:advMe/providers/ad_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key}) : super(key: key);

  static const routeName = '/adsScreen';

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  File _pickedImage;
  bool isPhoto = false;
  bool isCamera = false;

  _onAlertButtonsPressed(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "PLEASE SELECT",
      desc: "Take photo from gallery or camera?",
      buttons: [
        DialogButton(
          child: Text(
            "Gallery",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            setState(() {
              isCamera = false;
            });

            _pickImage(isCamera);

            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Camera",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            setState(() {
              isCamera = true;
            });

            _pickImage(isCamera);
            Navigator.pop(context);
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  void _pickImage(bool isCamera) async {
    // ignore: deprecated_member_use
    final pickedImageFile = await ImagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
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
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: RichText(
                    text: TextSpan(
                        text: 'add',
                        style: GoogleFonts.ubuntu(
                          color: Color(0xFFCBB2AB),
                          fontSize: 30.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Advice',
                            style: GoogleFonts.ubuntu(
                              color: Color(0xFFF79E1B),
                              fontSize: 30.0,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0x40C31331)),
                borderRadius: BorderRadius.circular(30),
                color: Color(0x40303250),
              ),

              height: 300,
              width: 300, //MediaQuery.of(context).size.width,
              child: _pickedImage == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 60,
                          color: Color(0xFFF79E1B),
                        ),
                        onPressed: () {
                          _onAlertButtonsPressed(context);
                        },
                      ),
                    )
                  : FittedBox(
                      child: Image.file(
                        _pickedImage,
                        //scale: 50,
                      ),
                      fit: BoxFit.fill,
                    ),
            ),
            SizedBox(height: 30),
            Container(
                decoration: BoxDecoration(
                    color: Color(0x40303250),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    cursorColor: Color(0xFFF79E1B),
                    style: TextStyle(color: Color(0xFFCBB2AB), fontSize: 20),
                    decoration: InputDecoration(
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xFF464656),
                          ),
                        ),
                        hintText: 'Tilte',
                        hintStyle: TextStyle(color: Color(0xFFCBB2AB))),
                    controller: titleController,
                  ),
                )),
            SizedBox(height: 30),
            Container(
                decoration: BoxDecoration(
                    color: Color(0x40303250),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextFormField(
                    maxLines: 5,
                    style: TextStyle(color: Color(0xFFCBB2AB), fontSize: 20),
                    decoration: InputDecoration(
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                          borderSide: BorderSide(
                            color: Color(0xFF464656),
                          ),
                        ),
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Color(0xFFCBB2AB))),
                    controller: descriptionController,
                  ),
                )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => {},
                child: Container(
                  child: Center(
                    child: Text(
                      'Add advertisment',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xEEC31331),
                      borderRadius: BorderRadius.circular(30)),
                  height: 40,
                  width: 280,
                  // decoration:
                  //     BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  // color: Color(0xEEC31331),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Color(0xEEC31331),
      //     child: Icon(Icons.add),
      //     onPressed: () {
      //       addPost(new DateTime.now(), titleController.text.toString(),
      //           descriptionController.text.toString(), _pickedImage);
      //     }),
    );
  }
}
