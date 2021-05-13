import 'package:advMe/helpers/location_helper.dart';
import 'package:advMe/helpers/validators.dart';
import 'package:advMe/models/place.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
// ignore: todo
//TODO: Add fields of edited ads and set downloaded data in appropriate places

}

class _AdsEditingScreenState extends State<AdsEditingScreen> {
  // ignore: unused_field
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

  void updateAds() {
    // ignore: todo
    //TODO: update given information in database and array in provider
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double widthSize = MediaQuery.of(context).size.width;
    descriptionController.text = widget.description;
    titleController.text = widget.title;
    priceController.text = widget.price;
    phoneNumberController.text = widget.phone;
    websiteController.text = widget.website;

    _pickedImage = widget.imageUrl1;
    _pickedImage2 = widget.imageUrl2;
    _pickedImage3 = widget.imageUrl3;

    // ignore: unused_local_variable
    var address;
    // ignore: unused_local_variable
   final settings = Provider.of<user.User>(context,listen: false);
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
                          color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFF8BB06),
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
                              color: settings.isDark ? Color(0xFF00D1CD) : Color(0xFFF8BB06),
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
                      //onTap: () => _onAlertButtonsPressed(1),
                      child: Container(
                    child: _pickedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                                size: 75,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Add photo',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          )
                        : Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                widget.imageUrl1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: settings.isDark ? Color(0xFF565656) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: settings.isDark ? Color(0x0000001A) : Colors.grey[300],
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
                    // onTap: () => _onAlertButtonsPressed(2),
                    child: Container(
                      child: _pickedImage2 == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                                  size: 75,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Add photo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )
                          : Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  _pickedImage2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: settings.isDark ? Color(0xFF565656) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: settings.isDark ? Color(0x0000001A) : Colors.grey[300],
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
                    //onTap: () => _onAlertButtonsPressed(3),
                    child: Container(
                      child: _pickedImage3 == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                                  size: 75,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Add photo',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )
                          : Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  widget.imageUrl3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: settings.isDark ? Color(0xFF565656) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: settings.isDark ? Color(0x0000001A) : Colors.grey[300],
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
                          color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                          size: 75,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Add photo',
                            style: TextStyle(
                              fontSize: 18,
                              color: settings.isDark ? Color(0xFF8E8E8E): Color(0xFFCECECE),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: settings.isDark ? Color(0xFF565656) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: settings.isDark ? Color(0x0000001A) : Colors.grey[300],
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
                      color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                      dropdownColor: settings.isDark ? Color(0xFF8E8E8E): Colors.white,
                      style: TextStyle(
                        color: Color(0xFFCECECE),fontSize: 15,
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
                          color: settings.isDark ? Color(0xFF565656) : Color(0xFFCECECE),
                        ),
                      ),
                      elevation: 16,
                      underline: Container(
                        height: 0,
                        color: settings.isDark ? Color(0xFF565656) : Colors.white,
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
                      color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                      cursorColor: settings.isDark ? Colors.white : Colors.black,
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
                        color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                        cursorColor: settings.isDark ? Colors.white : Colors.black,
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
                      color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                      cursorColor: settings.isDark ? Colors.white : Colors.black,
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
                        color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                        cursorColor: settings.isDark ? Colors.white : Colors.black,
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
                        color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                        cursorColor: settings.isDark ? Colors.white : Colors.black,
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
                    primary: settings.isDark ? Color(0xFF009494) : Color(0xFFF8BB06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            // buttonReady = true;
                          });
                          // _addorder(
                          //   address); //Addres field mus be passed as argument!!!
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
            // ignore: todo
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
