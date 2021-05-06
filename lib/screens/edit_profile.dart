

import 'package:advMe/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
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
                    left: 35,
                  ),
                  child: RichText(
                    text: TextSpan(
                        text: 'Edit ',
                        style: GoogleFonts.quicksand(
                          color: settings.isDark ? Colors.white : Colors.black,
                          fontSize: 28.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w700,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Profile',
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
            SizedBox(
              height: 30,
            ),
            Stack(children: [
              Container(
                height: 170,
                width: 170,
                child: Icon(
                  Icons.account_circle,
                  size: 170,
                  color: settings.isDark ? Color(0xFF6A6A6A) : Color(0xFFCECECE),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 0.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      
                      color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
              ),
              Positioned(
                  left: 130,
                  top: 12,
                  child: Container(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: settings.isDark ? Color(0xFF009494) : Color(0xFFF8BB06),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: settings.isDark ? Color(0x00000029) : Colors.grey[400],
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
                    color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                Icon(Icons.email,color: settings.isDark ? Colors.white : Colors.black,),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    //validator: validatePhone,
                    keyboardType: TextInputType.emailAddress,
                    //textAlign: TextAlign.start,
                    cursorColor: settings.isDark ? Colors.white : Colors.black,
                    style: TextStyle(color: settings.isDark ? Colors.white : Colors.black, fontSize: 17),
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
                          color: settings.isDark ? Color(0xFF8E8E8E) :Color(0xFFCECECE),
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
                    color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                    cursorColor: settings.isDark ? Colors.white : Colors.black,
                    style: TextStyle(color: settings.isDark ? Colors.white : Colors.black, fontSize: 17),
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
                          color: settings.isDark ? Color(0xFF8E8E8E) :Color(0xFFCECECE),
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
                    color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                color: settings.isDark ? Color(0xFF565656) : Colors.white,
                border: Border.all(
                  color:  Colors.black,
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
                    cursorColor: settings.isDark ? Colors.white : Colors.black,
                    style: TextStyle(color: settings.isDark ? Colors.white : Colors.black, fontSize: 17),
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
                          color: settings.isDark ? Color(0xFF8E8E8E) :Color(0xFFCECECE),
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
                    color: settings.isDark ? Color(0x00000029) : Colors.grey[300],
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
                    cursorColor: settings.isDark ? Colors.white : Colors.black,
                    style: TextStyle(color: settings.isDark ? Colors.white : Colors.black, fontSize: 17),
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
                          color: settings.isDark ? Color(0xFF8E8E8E) :Color(0xFFCECECE),
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
                    color: settings.isDark ? Color(0x00000029) :Colors.grey[300],
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
                    cursorColor: settings.isDark ? Colors.white : Colors.black,
                    style: TextStyle(color: settings.isDark ? Colors.white : Colors.black, fontSize: 17),
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
                          color: settings.isDark ? Color(0xFF8E8E8E) :Color(0xFFCECECE),
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
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                color: settings.isDark ? Color(0xFF009494) : Color(0xFFF8BB06),
                boxShadow: [
                  BoxShadow(
                    color: settings.isDark ? Color(0x00000029) : Colors.grey[350],
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: Offset(0, 8),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black,
                  width: 0.3,
                ),
              ),
              child: Center(
                child: Text('Save changes',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 18,
                    )),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
