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
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AdsEditingScreen extends StatefulWidget {
  static const routeName = '/orderl-detail';
  final String id;
  final String title;
   String description;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final String price;
  final String phone;
  final String website;
  final String address;

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
  });
  @override
  _AdsEditingScreenState createState() => _AdsEditingScreenState();
//TODO: Add fields of edited ads and set downloaded data in appropriate places

}

class _AdsEditingScreenState extends State<AdsEditingScreen> {
  PlaceLocation _pickedLocation;
  String _pickedImage;
  String _pickedImage2;
  String _pickedImage3;

  bool isPhoto = false;
  bool isCamera = false;
  bool isLoading = false;

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
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
     descriptionController.text = widget.description;
     titleController.text = widget.title;
     priceController.text = widget.price;
     phoneNumberController.text = widget.phone;
     websiteController.text = widget.website;

     _pickedImage = widget.imageUrl1;
     _pickedImage2 = widget.imageUrl2;
     _pickedImage3 = widget.imageUrl3;

    var address ;
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
                    right: 20,
                    left: 230,
                    bottom: 0,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.save,
                        color: settings.isDark
                            ? Color(0xFFF79E1B)
                            : Color(0xEEC31331),
                        size: 45,
                      ),
                      onPressed: () {
                       
                      }),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left:  50),
              child: Container(
                height: 350,
                width: MediaQuery.of(context).size.width * 1,
                child:
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    new Swiper.children(
                  customLayoutOption:
                      CustomLayoutOption(startIndex: -1, stateCount: 3),
                  autoplay: false,
                  pagination: new SwiperPagination(
                      margin: new EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 30.0),
                      builder: SwiperPagination.rect,
                      // builder: new DotSwiperPaginationBuilder(
                      //     color: Colors.white30,
                      //     activeColor: Colors.white,
                      //     size: 20.0,
                      //     activeSize: 20.0)
                      ),
                  children: <Widget>[
                    new Stack(children: [
                      Positioned(
                        child: _pickedImage == null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0x40C31331)),
                                  borderRadius: BorderRadius.circular(30),
                                  color: settings.isDark
                                      ? Color(0xFF303250)
                                      : Color(0xFF0D276B),
                                ),
                                height: 300,
                                width: 300, //MediaQuery.of(context).size.width,
                                child: Padding(
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
                                     // _onAlertButtonsPressed(context, 1);
                                    },
                                  ),
                                ))
                            : Container(
                                decoration: BoxDecoration(
                                  //border: Border.all(color: Color(0x40C31331)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 300,
                                width: 300,
                                child: Image.network(
                                  _pickedImage,
                                  //fit: BoxFit.fill,
                                ),
                                //fit: BoxFit.fill,
                              ),
                      )
                    ]),
/////////////////////////////////////////////////////////////////////
                    new Stack(children: [
                      Positioned(
                        child: _pickedImage2 == null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0x40C31331)),
                                  borderRadius: BorderRadius.circular(30),
                                  color: settings.isDark
                                      ? Color(0xFF303250)
                                      : Color(0xFF0D276B),
                                ),
                                height: 300,
                                width: 300, //MediaQuery.of(context).size.width,
                                child: Padding(
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
                                     // _onAlertButtonsPressed(context, 2);
                                    },
                                  ),
                                ))
                            : Container(
                                decoration: BoxDecoration(
                                  //border: Border.all(color: Color(0x40C31331)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 300,
                                width: 300,
                                child: Image.network(
                                  _pickedImage2,
                                  //fit: BoxFit.fill,
                                ),
                                //fit: BoxFit.fill,
                              ),
                      ),
                    ]),
/////////////////////////////////////////////////////////////////////////
                    new Stack(children: [
                      Positioned(
                        child: _pickedImage3 == null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0x40C31331)),
                                  borderRadius: BorderRadius.circular(30),
                                  color: settings.isDark
                                      ? Color(0xFF303250)
                                      : Color(0xFF0D276B),
                                ),
                                height: 300,
                                width: 300, //MediaQuery.of(context).size.width,
                                child: Padding(
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
                                     // _onAlertButtonsPressed(context, 3);
                                    },
                                  ),
                                ))
                            : Container(
                                decoration: BoxDecoration(
                                  //border: Border.all(color: Color(0x40C31331)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 300,
                                width: 300,
                                child: Image.network(
                                  _pickedImage3,
                                  //fit: BoxFit.fill,
                                ),
                                //fit: BoxFit.fill,
                              ),
                      ),
                    ]),
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  ],
                ),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateTitle,
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF0D276B) , fontSize: 17),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validatePrice,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF0D276B) , fontSize: 17),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateDescription,
                      maxLines: 5,
                      style: TextStyle(color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF0D276B) , fontSize: 17),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validatePhone,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF0D276B) , fontSize: 17),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateWebsite,
                      keyboardType: TextInputType.url,
                      textAlign: TextAlign.start,
                      cursorColor: Color(0xFFF79E1B),
                      style: TextStyle(color: settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF0D276B) , fontSize: 17),
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       primary: buttonReady ? Colors.grey :Color(0xEEC31331) ,
            //       shape: BeveledRectangleBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(10)),
            //       ),
            //     ),
            //     onPressed: ((_pickedImage == null) ||
            //             (_pickedImage2 == null) ||
            //             (_pickedImage3 == null) ||
            //             titleController.text.isEmpty ||
            //             priceController.text.isEmpty ||
            //             descriptionController.text.isEmpty ||
            //             phoneNumberController.text.isEmpty ||
            //             websiteController.text.isEmpty)
            //         //TODO display some info about check your inputs while button is diasbled!
            //         ? null //buttonReady = false
            //         : () async {
            //             setState(() {
            //               isLoading = true;
            //               buttonReady = true;
            //             });
            //             _addorder(
            //                 address); //Addres field mus be passed as argument!!!
            //           },
            //     child: isLoading
            //         ? SpinKitWave(
            //             color: Color(0xFFF79E1B),
            //           )
            //         : Text(
            //             'Add advertisment',
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 22,
            //             ),
            //           ),
            //   ),
            // ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}