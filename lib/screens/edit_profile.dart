import 'dart:io';
import 'package:advMe/providers/user.dart' as user;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File _pickedImage;

  bool isPhoto = false;
  bool isCamera = false;
  bool isLoading = false;
  _onAlertButtonsPressed(bool isDark) {
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

            _pickImage(isCamera);

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

            _pickImage(isCamera);
            Navigator.pop(context);
          },
          color: isDark ? Color(0xFF00D1CD) : Color(0xFFF8BB06),
        )
      ],
    ).show();
  }

  void _pickImage(bool isCamera) async {
    // ignore: deprecated_member_use
    final pickedImageFile = await ImagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _pickedImage = pickedImageFile;
    });
    isPhoto = true;
  }

  Future<void> _saveChanges() async {
    var uid = FirebaseAuth.instance.currentUser.uid;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('allAds')
          .child(uid)
          .child('userPhotoUrl');
      await ref.putFile(_pickedImage);
      final newUserPhotoUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        //'username': username,
        //'email': email,
        'isDark': false,
        'isNotif': false,
        //'createdAt': DateTime.now(),
        'isPremium': false,
        'imageUrl': newUserPhotoUrl,
      }).then((value) => {});
    } catch (error) {
      print(error);
      throw error;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<user.User>(context, listen: false);
    return FutureBuilder(
      future: Provider.of<user.User>(context, listen: false).getUserData(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: SpinKitWave(
            color: Color(0xFF00D1CD),
          )
              //CircularProgressIndicator(),
              );
        }
        var userPhotoUrl =
            Provider.of<user.User>(context, listen: false).imageUrl;
        print('building Edit user Screen');
        return Scaffold(
          backgroundColor:
              settings.isDark ? Color(0xFF3C3C3C) : Color(0xFFF3F3F3),
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
                        left: 35,
                      ),
                      child: RichText(
                        text: TextSpan(
                            text: 'Edit ',
                            style: GoogleFonts.quicksand(
                              color:
                                  settings.isDark ? Colors.white : Colors.black,
                              fontSize: 28.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Profile',
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
                SizedBox(
                  height: 30,
                ),
                Stack(children: [
                  Container(
                    height: 170,
                    width: 170,
                    child: (userPhotoUrl == '' && _pickedImage == null)
                        ? Icon(
                            Icons.account_circle,
                            size: 170,
                            color: settings.isDark
                                ? Color(0xFF6A6A6A)
                                : Color(0xFFCECECE),
                          )
                        : _pickedImage == null
                            ? Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(userPhotoUrl),
                                      fit: BoxFit.cover),
                                ),
                              )
                            : Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(_pickedImage),
                                      fit: BoxFit.cover),
                                ),
                              ),
                  ),
                  Positioned(
                      left: 130,
                      top: 12,
                      child: Container(
                        child: GestureDetector(
                          onTap: () async {
                            _onAlertButtonsPressed(settings.isDark);

                            setState(() {});
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: settings.isDark
                              ? Color(0xFF009494)
                              : Color(0xFFF8BB06),
                          border: Border.all(
                            color: Colors.black,
                            width: 0.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: settings.isDark
                                  ? Color(0x00000029)
                                  : Colors.grey[400],
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ))
                ]),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.75,
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
                    border: Border.all(
                      color: Colors.black,
                      width: 0.3,
                    ),
                  ),
                  child: Row(children: [
                    SizedBox(width: 15),
                    Icon(
                      Icons.email,
                      color: settings.isDark ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //validator: validatePhone,
                        keyboardType: TextInputType.emailAddress,
                        //textAlign: TextAlign.start,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 17),
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
                              color: settings.isDark
                                  ? Color(0xFF8E8E8E)
                                  : Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        //controller: phoneNumberController,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.75,
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
                    border: Border.all(
                      color: Colors.black,
                      width: 0.3,
                    ),
                  ),
                  child: Row(children: [
                    SizedBox(width: 15),
                    Icon(
                      Icons.person,
                      size: 25,
                      color: settings.isDark ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //validator: validatePhone,
                        //keyboardType: TextInputType.emailAddress,
                        //textAlign: TextAlign.start,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 17),
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
                              color: settings.isDark
                                  ? Color(0xFF8E8E8E)
                                  : Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        //controller: phoneNumberController,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Change password',
                    style: GoogleFonts.quicksand(
                      fontSize: 17,
                      color: settings.isDark ? Color(0xFF009494) : Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.75,
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
                    border: Border.all(
                      color: Colors.black,
                      width: 0.3,
                    ),
                  ),
                  child: Row(children: [
                    SizedBox(width: 15),
                    Icon(
                      Icons.lock,
                      size: 25,
                      color: settings.isDark ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //validator: validatePhone,
                        //keyboardType: TextInputType.,
                        //textAlign: TextAlign.start,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 17),
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
                            hintText: 'Current password',
                            hintStyle: TextStyle(
                              color: settings.isDark
                                  ? Color(0xFF8E8E8E)
                                  : Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        //controller: phoneNumberController,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.75,
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
                    border: Border.all(
                      color: Colors.black,
                      width: 0.3,
                    ),
                  ),
                  child: Row(children: [
                    SizedBox(width: 15),
                    Icon(
                      Icons.lock,
                      size: 25,
                      color: settings.isDark ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //validator: validatePhone,
                        keyboardType: TextInputType.emailAddress,
                        //textAlign: TextAlign.start,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 17),
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
                            hintText: 'New password',
                            hintStyle: TextStyle(
                              color: settings.isDark
                                  ? Color(0xFF8E8E8E)
                                  : Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        //controller: phoneNumberController,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.75,
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
                    border: Border.all(
                      color: Colors.black,
                      width: 0.3,
                    ),
                  ),
                  child: Row(children: [
                    SizedBox(width: 15),
                    Icon(
                      Icons.lock,
                      size: 25,
                      color: settings.isDark ? Colors.white : Colors.black,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //validator: validatePhone,
                        keyboardType: TextInputType.emailAddress,
                        //textAlign: TextAlign.start,
                        cursorColor:
                            settings.isDark ? Colors.white : Colors.black,
                        style: TextStyle(
                            color:
                                settings.isDark ? Colors.white : Colors.black,
                            fontSize: 17),
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
                            hintText: 'Repeat new password',
                            hintStyle: TextStyle(
                              color: settings.isDark
                                  ? Color(0xFF8E8E8E)
                                  : Color(0xFFCECECE),
                              fontSize: 18,
                            )),
                        //controller: phoneNumberController,
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 31,
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
                        primary: (settings.isDark
                            ? Color(0xFF00D1CD)
                            : Color(0xFFFFD320)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        _saveChanges().then((void nothig) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Changes has beed saved!'),
                            ),
                          );
                        });
                      },
                      child: isLoading
                          ? SpinKitWave(
                              color: settings.isDark
                                  ? Color(0xFF00D1CD)
                                  : Color(0xFFF8BB06),
                            )
                          : Text(
                              'Save Changes',
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
      },
    );
  }
}
