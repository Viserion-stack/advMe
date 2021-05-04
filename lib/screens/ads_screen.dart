import 'dart:io';
import 'package:advMe/helpers/location_helper.dart';
import 'package:advMe/helpers/validators.dart';
import 'package:advMe/models/place.dart';
import 'package:advMe/providers/order.dart';
import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/widgets/location_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key}) : super(key: key);

  static const routeName = '/adsScreen';

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

enum categories {
  Construction,
  Renovation,
  Transport,
  Mechanic,
}

class _AdsScreenState extends State<AdsScreen> {
  // ignore: unused_field
  PlaceLocation _pickedLocation;
  File _pickedImage;
  File _pickedImage2;
  File _pickedImage3;

  bool isPhoto = false;
  bool isCamera = false;
  bool isLoading = false;

  String lok;

  Future<void> _selectPlace(double lat, double lng) async {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    String place = await LocationHelper.getPlaceAddress(lat, lng);
    setState(() {
      lok = place;
    });
  }

  _onAlertButtonsPressed(int index) {
    Alert(
      style: AlertStyle(
        //alertBorder: ,
        overlayColor: Color(0xDBEEEEEE),
        backgroundColor: Colors.white,
        titleStyle: GoogleFonts.quicksand(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        descStyle: GoogleFonts.quicksand(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      context: context,
      type: AlertType.none,
      title: 'Please select',
      desc: "Take photo from Gallery or Camera?",
      buttons: [
        DialogButton(
          radius: BorderRadius.circular(27),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(children: [
              Icon(
                Icons.collections,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                "Gallery",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ]),
          ),
          onPressed: () {
            setState(() {
              isCamera = false;
            });

            _pickImage(isCamera, index);

            Navigator.pop(context);
          },
          color: Color(0xFFF8BB06),
        ),
        DialogButton(
          radius: BorderRadius.circular(27),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(children: [
              Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                "Camera",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ]),
          ),
          onPressed: () {
            setState(() {
              isCamera = true;
            });

            _pickImage(isCamera, index);
            Navigator.pop(context);
          },
          color: Color(0xFFF8BB06),
        )
      ],
    ).show();
  }

  void _pickImage(bool isCamera, int index) async {
    // ignore: deprecated_member_use
    final pickedImageFile = await ImagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      if (index == 1)
        _pickedImage = pickedImageFile;
      else if (index == 2)
        _pickedImage2 = pickedImageFile;
      else if (index == 3) _pickedImage3 = pickedImageFile;
    });
    isPhoto = true;
  }

  Future<void> _addorder(String address) async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child('allAds')
        .child(uid)
        .child(titleController.text.toString() + '1.jpg');
    await ref.putFile(_pickedImage);

    final ref2 = FirebaseStorage.instance
        .ref()
        .child('allAds')
        .child(uid)
        .child(titleController.text.toString() + '2.jpg');
    await ref2.putFile(_pickedImage2);

    final ref3 = FirebaseStorage.instance
        .ref()
        .child('allAds')
        .child(uid)
        .child(titleController.text.toString() + '3.jpg');
    await ref3.putFile(_pickedImage3);

    final url1 = await ref.getDownloadURL();
    final url2 = await ref2.getDownloadURL();
    final url3 = await ref3.getDownloadURL();

    var newOrder = Order(
      userId: uid.trim(),
      id: uid.trim(),
      title: titleController.text.toString().toLowerCase().trim(),
      price: priceController.text.toString(),
      description: descriptionController.text.toString().trim(),
      imageUrl1: url1,
      imageUrl2: url2,
      imageUrl3: url3,
      date: DateTime.now(),
      phone: phoneNumberController.text.toString().trim(),
      website: websiteController.text.toString().trim(),
      address: address,
      category: valueChoose.toString(),
    );
    await Provider.of<Orders>(context, listen: false)
        .addOrder(newOrder)
        .then((void nothing) {
      print("Order Added to cloud firestore");
      setState(() {
        isLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order has been added!'),
          ),
        );
      });
    }).catchError((e) => print(e));
  }

  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final websiteController = TextEditingController();

  bool buttonReady = false;

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    priceController.dispose();
    phoneNumberController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  String valueChoose = 'Construction';
  List<String> listItem = [
    'Construction',
    'Renovation',
    'Transport',
    'Mechanic',
  ];

  @override
  Widget build(BuildContext context) {
    var address = lok;
    // ignore: unused_local_variable
    final settings = Provider.of<SettingsUser>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF3F3F3),
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
                          color: Color(0xFFF8BB06),
                          size: 46,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 18,
                  ),
                  child: RichText(
                    text: TextSpan(
                        text: 'Add',
                        style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 28.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Advertisment',
                            style: GoogleFonts.quicksand(
                              color: Color(0xFFF8BB06),
                              fontSize: 28.0,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06),
                  child: GestureDetector(
                      onTap: () => _onAlertButtonsPressed(1),
                      child: Container(
                        child: _pickedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Color(0xFFCECECE),
                                    size: 75,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Add photo',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFFCECECE),
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              )
                            : Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    _pickedImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.height * 0.23,
                        width: MediaQuery.of(context).size.width * 0.4,
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.07),
                  child: GestureDetector(
                    onTap: () => _onAlertButtonsPressed(2),
                    child: Container(
                      child: _pickedImage2 == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color(0xFFCECECE),
                                  size: 75,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Add photo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFCECECE),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )
                          : Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  _pickedImage2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.23,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.04),
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06),
                  child: GestureDetector(
                    onTap: () => _onAlertButtonsPressed(3),
                    child: Container(
                      child: _pickedImage3 == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color(0xFFCECECE),
                                  size: 75,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Add photo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFFCECECE),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )
                          : Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  _pickedImage3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.23,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.07),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Color(0xFFCECECE),
                          size: 75,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Add photo',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFCECECE),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height * 0.23,
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.87,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Center(
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      style: TextStyle(
                        color: Color(0xFFCECECE),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFFCECECE),
                        size: 35,
                      ),
                      hint: Text(
                        '   Select category                                  ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFCECECE),
                        ),
                      ),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      value: valueChoose,
                      onChanged: (String value) {
                        setState(() {
                          valueChoose = value;
                        });
                      },
                      items: listItem.map((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 22),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.87,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateTitle,
                      //textAlign: TextAlign.start,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                      decoration: InputDecoration(

                          //filled: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.transparent,
                          )),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          hintText: 'Tilte',
                          hintStyle: TextStyle(
                            color: Color(0xFFCECECE),
                            fontSize: 18,
                          )),
                      controller: titleController,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.87,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePrice,
                        keyboardType: TextInputType.number,
                        //textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        decoration: InputDecoration(

                            //filled: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.transparent,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            hintText: 'Price',
                            hintStyle: TextStyle(
                              color: Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        controller: priceController,
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.87,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateDescription,
                      maxLines: 5,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                      decoration: InputDecoration(
                          //filled: true,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.transparent,
                          )),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          hintText: 'Description',
                          hintStyle: TextStyle(
                            color: Color(0xFFCECECE),
                            fontSize: 18,
                          )),
                      controller: descriptionController,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.87,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePhone,
                        keyboardType: TextInputType.number,
                        //textAlign: TextAlign.start,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        decoration: InputDecoration(

                            //filled: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.transparent,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            hintText: 'Phone',
                            hintStyle: TextStyle(
                              color: Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        controller: phoneNumberController,
                      ),
                    ),
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.87,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validateWebsite,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        decoration: InputDecoration(

                            //filled: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.transparent,
                            )),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            hintText: 'Website',
                            hintStyle: TextStyle(
                              color: Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        controller: websiteController,
                      ),
                    ),
                  ),
                )),
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
              ),
              //height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.87,
              child: LocationInput(_selectPlace),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.87,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: buttonReady ? Colors.grey : Color(0xFFFFD320),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  onPressed: ((_pickedImage == null) ||
                          (_pickedImage2 == null) ||
                          (_pickedImage3 == null) ||
                          titleController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          phoneNumberController.text.isEmpty ||
                          websiteController.text.isEmpty)
                      // ignore: todo
                      //TODO display some info about check your inputs while button is diasbled!
                      ? null //buttonReady = false
                      : () async {
                          setState(() {
                            isLoading = true;
                            buttonReady = true;
                          });
                          _addorder(
                              address); //Addres field mus be passed as argument!!!
                        },
                  child: isLoading
                      ? SpinKitWave(
                          color: Color(0xFFF79E1B),
                        )
                      : Text(
                          'Add Advertisment',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
