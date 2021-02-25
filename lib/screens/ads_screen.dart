import 'dart:io';
import 'package:advMe/helpers/location_helper.dart';
import 'package:advMe/models/place.dart';
import 'package:advMe/providers/ad_order_provider.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/widgets/location_input.dart';
//import 'package:advMe/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
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

  _onAlertButtonsPressed(context) {
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

            _pickImage(isCamera);

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

            _pickImage(isCamera);
            Navigator.pop(context);
          },
          color: Color(0xFFF79E1B),
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
    //var product = Provider.of<Products>(context, listen: false);
    var address = lok;
    final settings = Provider.of<SettingsUser>(context);

    return Scaffold(
      backgroundColor: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
      //Color(0xFF171923),
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
                          color: settings.isDark ? Color(0xFFF79E1B) : Color(0xFFFFC03D),
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
                            color: settings.isDark ? Color(0x40303250) : Color(0xFF0D276B))),
                    //Color(0x40303250))),
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
                          color: settings.isDark ? Color(0xFFCBB2AB) :  Color(0xFF0D276B),
                          //Color(0xFFCBB2AB),
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
            SizedBox(height: 50),
            Stack(children: [
              Container(
                decoration: BoxDecoration(
                  //border: Border.all(color: Color(0x40C31331)),
                  borderRadius: BorderRadius.circular(30),
                  color: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
                ),
                height: 350,
                width: 350,
              ),
              if(!settings.isDark)Positioned(
                left: 50,
                right:50,
                top: MediaQuery.of(context).size.width * .17,
                child: Container(
                  decoration: BoxDecoration(
                    //border: Border.all(color: Color(0x40C31331)),
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0x33303250),
                  ),
                  height: 250,
                  width: 250,
                ),
              ),
              Positioned(
                left: 25,
                right: 25,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0x40C31331)),
                    borderRadius: BorderRadius.circular(30),
                    color: settings.isDark ? Color(0x40303250) : Color(0xFF0D276B),
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
                              color: settings.isDark ? Color(0xFFF79E1B) : Color(0xFFF79E1B),
                              //Color(0xFFF79E1B),
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
              ),
            ]),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFFFFC03D),
                  //Color(0xFFF79E1B),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: DropdownButton(
                    dropdownColor:Color(0xAAFFC03D),
                    //Color(0xEEF79E1B),
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
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark ? Color(0x40303250) : Color(0x80FFC03D),
                      //Color(0x40303250),
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
                            color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF432344),
                            //Color(0xFFCBB2AB),
                          )),
                      controller: titleController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark ? Color(0x40303250) : Color(0x80FFC03D),
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
                            color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF432344),
                            //Color(0xFFCBB2AB),
                          )),
                      controller: priceController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark ? Color(0x40303250) : Color(0x80FFC03D),
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
                            color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF432344),
                            //Color(0xFFCBB2AB),
                          )),
                      controller: descriptionController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark ? Color(0x40303250) : Color(0x80FFC03D),
                      //Color(0x40303250),
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
                            color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF432344),
                            //Color(0xFFCBB2AB),
                          )),
                      controller: phoneNumberController,
                    ),
                  )),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: settings.isDark ? Color(0x40303250) : Color(0x80FFC03D),
                      //Color(0x40303250),
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
                            color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF432344),
                            //Color(0xFFCBB2AB),
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
                //Colors.white54,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  addPost(
                          new DateTime.now(),
                          titleController.text.toString(),
                          descriptionController.text.toString(),
                          _pickedImage,
                          priceController.text.toString(),
                          phoneNumberController.text.toString(),
                          websiteController.text.toString(),
                          address)
                      .then((void nothing) {
                    print("done");
                    setState(() {
                      isLoading = false;
                    });
                  }).catchError((e) => print(e));
                  //product.fetchAndSetProducts();
                },
                child: isLoading
                    ? SpinKitWave(color: Color(0xFFF79E1B),)
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
                        // decoration:
                        //     BoxDecoration(borderRadius: BorderRadius.circular(30)),
                        // color: Color(0xEEC31331),
                      ),
              ),
            ),
            SizedBox(height: 20),
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
