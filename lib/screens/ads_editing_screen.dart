import 'dart:io';
import 'package:advMe/helpers/location_helper.dart';
import 'package:advMe/helpers/validators.dart';
import 'package:advMe/models/place.dart';
import 'package:advMe/providers/order.dart';
import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/screens/home_screen.dart';
import 'package:advMe/widgets/all_orders.dart';
import 'package:advMe/widgets/location_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdsEditingScreen extends StatefulWidget {
  static const routeName = '/orderl-detail';
  final String id;
  final String title;
  final String description;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final String price;
  final String phone;
  final String website;
  final String address;
  double rating;
  int countRating;
  double sumRating;

  AdsEditingScreen({
    this.id,
    this.title,
    this.description,
    this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.price,
    this.phone,
    this.website,
    this.address,
    this.rating,
    this.countRating,
    this.sumRating,
  });
  @override
  _AdsEditingScreenState createState() => _AdsEditingScreenState();
// ignore: todo
//TODO: Add fields of edited ads and set downloaded data in appropriate places

}

class _AdsEditingScreenState extends State<AdsEditingScreen> {
  // ignore: unused_field
  PlaceLocation _pickedLocation;
  File _pickedImage;
  File _pickedImage2;
  File _pickedImage3;

  bool isPhoto = false;
  bool isCamera = false;
  bool isLoading = false;

  // ignore: unused_local_variable

  var descriptionController = TextEditingController();
  var titleController = TextEditingController();
  var priceController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var websiteController = TextEditingController();

  String valueChoose = 'Construction';
  List<String> listItem = [
    'Construction',
    'Renovation',
    'Transport',
    'Mechanic',
  ];

  String lok;

  Future<void> _selectPlace(double lat, double lng) async {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
    String place = await LocationHelper.getPlaceAddress(lat, lng);
    setState(() {
      lok = place;
    });
  }

  @override
  void initState() {
    descriptionController = TextEditingController.fromValue(
      new TextEditingValue(
        text: widget.description,
        selection: new TextSelection.collapsed(
          offset: widget.description.length,
        ),
      ),
    );
    titleController = TextEditingController.fromValue(
      new TextEditingValue(
        text: widget.title,
        selection: new TextSelection.collapsed(
          offset: widget.title.length,
        ),
      ),
    );
    priceController = TextEditingController.fromValue(
      new TextEditingValue(
        text: widget.price,
        selection: new TextSelection.collapsed(
          offset: widget.price.length - 1,
        ),
      ),
    );
    phoneNumberController = TextEditingController.fromValue(
      new TextEditingValue(
        text: widget.phone,
        selection: new TextSelection.collapsed(
          offset: widget.phone.length - 1,
        ),
      ),
    );
    websiteController = TextEditingController.fromValue(
      new TextEditingValue(
        text: widget.website,
        selection: new TextSelection.collapsed(
          offset: widget.website.length,
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    priceController.dispose();
    phoneNumberController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  _onAlertButtonsPressed(int index, bool isDark) {
    //final settings = Provider.of<SettingsUser>(context);
    Alert(
      style: AlertStyle(
        //alertBorder: ,
        overlayColor: isDark ? Color(0xDD3C3C3C) : Color(0xDBEEEEEE),
        backgroundColor: isDark ? Color(0xFF565656) : Colors.white,
        titleStyle: GoogleFonts.quicksand(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        descStyle: GoogleFonts.quicksand(
          color: isDark ? Colors.white : Colors.black,
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
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                "Gallery",
                style: TextStyle(color: Colors.white, fontSize: 16),
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
          color: isDark ? Color(0xFF00D1CD) : Color(0xFFF8BB06),
        ),
        DialogButton(
          radius: BorderRadius.circular(27),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(children: [
              Icon(
                Icons.photo_camera,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                "Camera",
                style: TextStyle(color: Colors.white, fontSize: 16),
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
          color: isDark ? Color(0xFF00D1CD) : Color(0xFFF8BB06),
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

  Future<void> _saveChanges(String address) async {
    var uid = FirebaseAuth.instance.currentUser.uid;

    if (_pickedImage != null) {
      String itemToDelete = widget.title + '.jpg';

      var storageReferance = FirebaseStorage.instance.ref();
      storageReferance.child('allAds/$uid/$itemToDelete').delete().then((_) {
        print("Deleting image1 from Storage success!");
      });
    }
    if (_pickedImage2 != null) {
      String itemToDelete = widget.title + '2.jpg';

      var storageReferance = FirebaseStorage.instance.ref();
      storageReferance.child('allAds/$uid/$itemToDelete').delete().then((_) {
        print("Deleting image2 from Storage success!");
      });
    }
    if (_pickedImage3 != null) {
      String itemToDelete = widget.title + '3.jpg';

      var storageReferance = FirebaseStorage.instance.ref();
      storageReferance.child('allAds/$uid/$itemToDelete').delete().then((_) {
        print("Deleting image3 from Storage success!");
      });
    }
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
      imageUrl1: _pickedImage == null ? widget.imageUrl1 : url1,
      imageUrl2: _pickedImage2 == null ? widget.imageUrl1 : url2,
      imageUrl3: _pickedImage3 == null ? widget.imageUrl1 : url3,
      date: DateTime.now(),
      phone: phoneNumberController.text.toString().trim(),
      website: websiteController.text.toString().trim(),
      address: widget.address, ///////////////////////////do edycji
      category: valueChoose.toString(),
      rating: widget.rating,
      countRating: widget.countRating,
      sumRating: widget.sumRating,
      //isFavorite: false,
    );
    await Provider.of<Orders>(context, listen: false)
        .updateProduct(widget.id, newOrder)
        .then((void nothing) {
      setState(() {
        isLoading = false;
      });
      print('succes update in allAds and user_order');
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var address;
    // ignore: unused_local_variable
    final settings = Provider.of<user.User>(context, listen: false);
    return Scaffold(
      backgroundColor: settings.isDark ? Color(0xFF3C3C3C) : Color(0xFFF3F3F3),
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
                          color: settings.isDark
                              ? Color(0xFF00D1CD)
                              : Color(0xFFF8BB06),
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
                        text: 'Edit ',
                        style: GoogleFonts.quicksand(
                          color: settings.isDark ? Colors.white : Colors.black,
                          fontSize: 28.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Advertisment',
                            style: GoogleFonts.quicksand(
                              color: settings.isDark
                                  ? Color(0xFF00D1CD)
                                  : Color(0xFFF8BB06),
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
                    onTap: () => _onAlertButtonsPressed(1, settings.isDark),
                    child: Container(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: _pickedImage == null
                              ? Image.network(
                                  widget.imageUrl1,
                                  fit: BoxFit.cover,
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
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color:
                            settings.isDark ? Color(0xFF565656) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: settings.isDark
                                ? Color(0x0000001A)
                                : Colors.grey[300],
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
                  child: GestureDetector(
                    onTap: () => _onAlertButtonsPressed(2, settings.isDark),
                    child: Container(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: _pickedImage2 == null
                              ? Image.network(
                                  widget.imageUrl2,
                                  fit: BoxFit.cover,
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
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color:
                            settings.isDark ? Color(0xFF565656) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: settings.isDark
                                ? Color(0x0000001A)
                                : Colors.grey[300],
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
                    onTap: () => _onAlertButtonsPressed(3, settings.isDark),
                    child: Container(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: _pickedImage3 == null
                              ? Image.network(
                                  widget.imageUrl3,
                                  fit: BoxFit.cover,
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
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color:
                            settings.isDark ? Color(0xFF565656) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: settings.isDark
                                ? Color(0x0000001A)
                                : Colors.grey[300],
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
                          color: settings.isDark
                              ? Color(0xFF8E8E8E)
                              : Color(0xFFCECECE),
                          size: 75,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Add photo',
                            style: TextStyle(
                              fontSize: 18,
                              color: settings.isDark
                                  ? Color(0xFF8E8E8E)
                                  : Color(0xFFCECECE),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: settings.isDark ? Color(0xFF565656) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: settings.isDark
                              ? Color(0x0000001A)
                              : Colors.grey[300],
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
                      color: settings.isDark
                          ? Color(0x00000029)
                          : Colors.grey[300],
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: settings.isDark ? Color(0xFF565656) : Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Center(
                    child: DropdownButton(
                      dropdownColor:
                          settings.isDark ? Color(0xFF8E8E8E) : Colors.white,
                      style: TextStyle(
                        color: Color(0xFFCECECE),
                        fontSize: 15,
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
                          color: settings.isDark
                              ? Color(0xFF565656)
                              : Color(0xFFCECECE),
                        ),
                      ),
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color:
                            settings.isDark ? Color(0xFF565656) : Colors.white,
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
                      color: settings.isDark
                          ? Color(0x00000029)
                          : Colors.grey[300],
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: settings.isDark ? Color(0xFF565656) : Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateTitle,
                      //textAlign: TextAlign.start,
                      cursorColor:
                          settings.isDark ? Colors.white : Colors.black,
                      style: TextStyle(
                          color: settings.isDark ? Colors.white : Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
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
                            fontSize: 20,
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
                        color: settings.isDark
                            ? Color(0x00000029)
                            : Colors.grey[300],
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: settings.isDark ? Color(0xFF565656) : Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePrice,
                        keyboardType: TextInputType.number,
                        //textAlign: TextAlign.start,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
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
                        // onChanged: (text) {
                        //   priceController.text = text;
                        // },
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
                      color: settings.isDark
                          ? Color(0x00000029)
                          : Colors.grey[300],
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                  color: settings.isDark ? Color(0xFF565656) : Colors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateDescription,
                      maxLines: 5,
                      cursorColor:
                          settings.isDark ? Colors.white : Colors.black,
                      style: TextStyle(
                          color: settings.isDark ? Colors.white : Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
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
                        color: settings.isDark
                            ? Color(0x00000029)
                            : Colors.grey[300],
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: settings.isDark ? Color(0xFF565656) : Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePhone,
                        keyboardType: TextInputType.number,
                        //textAlign: TextAlign.start,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
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
                        // onChanged: (text) {
                        //   phoneNumberController.text = text;
                        // }
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
                        color: settings.isDark
                            ? Color(0x00000029)
                            : Colors.grey[300],
                        blurRadius: 8,
                        spreadRadius: 0,
                        offset: Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: settings.isDark ? Color(0xFF565656) : Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validateWebsite,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
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
                    primary:
                        settings.isDark ? Color(0xFF009494) : Color(0xFFF8BB06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onPressed:
                      // ((_pickedImage == null) ||
                      //         (_pickedImage2 == null) ||
                      //         (_pickedImage3 == null) ||
                      //         titleController.text.isEmpty ||
                      //         priceController.text.isEmpty ||
                      //         descriptionController.text.isEmpty ||
                      //         phoneNumberController.text.isEmpty ||
                      //         websiteController.text.isEmpty)
                      //     // ignore: todo
                      //     //TODO display some info about check your inputs while button is diasbled!
                      //     ? null //buttonReady = false
                      //     :
                      () async {
                    setState(() {
                      isLoading = true;
                      // buttonReady = true;
                      print('Widget ID =' + widget.id);
                    });
                    _saveChanges(widget.address).then((void nothig) {
                      // Navigator.of(context).pop();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AllOrders()),
                        ModalRoute.withName('/'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order hanges has beed saved!'),
                        ),
                      );
                    });
                  },
                  child: isLoading
                      ? SpinKitWave(
                          color: Color(0xFF00D1CD),
                        )
                      : Text(
                          'Save Advertisment',
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
