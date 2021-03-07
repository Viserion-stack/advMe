import 'dart:io';
import 'package:advMe/helpers/location_helper.dart';
import 'package:advMe/models/place.dart';
import 'package:advMe/providers/order.dart';
import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/widgets/location_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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

  _onAlertButtonsPressed(context, int index) {
    Alert(
      style: AlertStyle(
        backgroundColor: Color(0x40303250),
        titleStyle: TextStyle(
          color: Color(0xFFCBB2AB),
        ),
        descStyle: TextStyle(
          color: Color(0xFFCBB2AB),
        ),
      ),
      context: context,
      type: AlertType.none,
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

            _pickImage(isCamera, index);

            Navigator.pop(context);
          },
          color: Color(0xEEC31331),
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

            _pickImage(isCamera, index);
            Navigator.pop(context);
          },
          color: Color(0xFFF79E1B),
        )
      ],
    ).show();
  }

  void _pickImage(bool isCamera, int index) async {
    // ignore: deprecated_member_use
    final pickedImageFile = await ImagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 100,
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
    );
    await Provider.of<Orders>(context, listen: false)
        .addOrder(newOrder)
        .then((void nothing) {
      print("Order Added to cloud firestore");
      setState(() {
        isLoading = false;
      });
    }).catchError((e) => print(e));
  }

  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final websiteController = TextEditingController();

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
    final settings = Provider.of<SettingsUser>(context);
    return Scaffold(
      backgroundColor: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
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
                              ? Color(0xFFF79E1B)
                              : Color(0xFFFFC03D),
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: settings.isDark
                                ? Color(0x40303250)
                                : Color(0xFF0D276B))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                  ),
                  child: RichText(
                    text: TextSpan(
                        text: 'add',
                        style: GoogleFonts.ubuntu(
                          color: settings.isDark
                              ? Color(0xFFCBB2AB)
                              : Color(0xFF0D276B),
                          fontSize: 28.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Advertisment',
                            style: GoogleFonts.ubuntu(
                              color: Color(0xFFF79E1B),
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
            SizedBox(height: 20),
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width * 1,
              child:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  new Swiper.children(
                autoplay: false,
                pagination: new SwiperPagination(
                    margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.white30,
                        activeColor: Colors.white,
                        size: 20.0,
                        activeSize: 20.0)),
                children: <Widget>[
                  new Stack(children: [
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0x40C31331)),
                          borderRadius: BorderRadius.circular(30),
                          color: settings.isDark
                              ? Color(0xFF303250)
                              : Color(0xFF0D276B),
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
                                    color: settings.isDark
                                        ? Color(0xFFF79E1B)
                                        : Color(0xFFF79E1B),
                                  ),
                                  onPressed: () {
                                    _onAlertButtonsPressed(context, 1);
                                  },
                                ),
                              )
                            : FittedBox(
                                child: Image.file(
                                  _pickedImage,
                                ),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ]),
/////////////////////////////////////////////////////////////////////
                  new Stack(children: [
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0x40C31331)),
                          borderRadius: BorderRadius.circular(30),
                          color: settings.isDark
                              ? Color(0xFF303250)
                              : Color(0xFF0D276B),
                        ),
                        height: 300,
                        width: 300, //MediaQuery.of(context).size.width,
                        child: _pickedImage2 == null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 60,
                                    color: settings.isDark
                                        ? Color(0xFFF79E1B)
                                        : Color(0xFFF79E1B),
                                  ),
                                  onPressed: () {
                                    _onAlertButtonsPressed(context, 2);
                                  },
                                ),
                              )
                            : FittedBox(
                                child: Image.file(
                                  _pickedImage2,
                                  //scale: 50,
                                ),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ]),
/////////////////////////////////////////////////////////////////////////
                  new Stack(children: [
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0x40C31331)),
                          borderRadius: BorderRadius.circular(30),
                          color: settings.isDark
                              ? Color(0xFF303250)
                              : Color(0xFF0D276B),
                        ),
                        height: 300,
                        width: 300, //MediaQuery.of(context).size.width,
                        child: _pickedImage3 == null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    size: 60,
                                    color: settings.isDark
                                        ? Color(0xFFF79E1B)
                                        : Color(0xFFF79E1B),
                                  ),
                                  onPressed: () {
                                    _onAlertButtonsPressed(context, 3);
                                  },
                                ),
                              )
                            : FittedBox(
                                child: Image.file(
                                  _pickedImage3,
                                  //scale: 50,
                                ),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ]),
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFFFFC03D),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: DropdownButton(
                    dropdownColor: Color(0xAAFFC03D),
                    style: TextStyle(
                      color: Color(0xFF303250),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    hint: Text(
                      'Select category',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF303250),
                      ),
                    ),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Color(0xFFFFC03D),
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark
                          ? Color(0x40303250)
                          : Color(0x80FFC03D),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: Color(0xFFCBB2AB), fontSize: 17),
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
                          hintStyle: TextStyle(
                            color: settings.isDark
                                ? Color(0xFFCBB2AB)
                                : Color(0xFF432344),
                          )),
                      controller: titleController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark
                          ? Color(0x40303250)
                          : Color(0x80FFC03D),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: Color(0xFFCBB2AB), fontSize: 17),
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
                          hintText: 'Price',
                          hintStyle: TextStyle(
                            color: settings.isDark
                                ? Color(0xFFCBB2AB)
                                : Color(0xFF432344),
                          )),
                      controller: priceController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark
                          ? Color(0x40303250)
                          : Color(0x80FFC03D),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      maxLines: 5,
                      style: TextStyle(color: Color(0xFFCBB2AB), fontSize: 17),
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
                          hintStyle: TextStyle(
                            color: settings.isDark
                                ? Color(0xFFCBB2AB)
                                : Color(0xFF432344),
                          )),
                      controller: descriptionController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark
                          ? Color(0x40303250)
                          : Color(0x80FFC03D),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: Color(0xFFCBB2AB), fontSize: 17),
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
                          hintText: 'Phone',
                          hintStyle: TextStyle(
                            color: settings.isDark
                                ? Color(0xFFCBB2AB)
                                : Color(0xFF432344),
                            //Color(0xFFCBB2AB),
                          )),
                      controller: phoneNumberController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark
                          ? Color(0x40303250)
                          : Color(0x80FFC03D),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      keyboardType: TextInputType.url,
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: Color(0xFFCBB2AB), fontSize: 17),
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
                          hintText: 'Website',
                          hintStyle: TextStyle(
                            color: settings.isDark
                                ? Color(0xFFCBB2AB)
                                : Color(0xFF432344),
                          )),
                      controller: websiteController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: LocationInput(_selectPlace)),
            SizedBox(height: 10),
            Text(
              address != null ? address : 'Choose loacalization',
              style: TextStyle(
                color: settings.isDark ? Colors.white54 : Color(0xFF0D276B),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  _addorder(
                      address); //Addres field mus be passed as argument!!!
                },
                child: isLoading
                    ? SpinKitWave(
                        color: Color(0xFFF79E1B),
                      )
                    : Container(
                        child: Center(
                          child: Text(
                            'Add advertisment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xEEC31331),
                            borderRadius: BorderRadius.circular(30)),
                        height: 40,
                        width: 280,
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
