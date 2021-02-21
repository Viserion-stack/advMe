import 'package:advMe/animation/fade_animation.dart';
import 'package:advMe/providers/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;

  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  var _userEmail = '';

  var _userName = '';

  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    print(settings.isDark.toString());
    return Scaffold(
      backgroundColor: //settings.isDark
          //? Color(0xFF171923)
          Color(0xFFFFFFFF), //Color(0xFF171923),
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // colors: settings.isDark
                  //     ? [
                  //         Color(0xFF171923),
                  //         Color(0xFF171923),
                  //       ]
                  colors: [
                    Color(0xFFE7EEFB),
                    Color(0xFFE7EEFB),
                  ]),
            ),
            padding: EdgeInsets.only(top: 100.0),
            child: Column(
              children: [
                Container(
                  child: Stack(
                    children: [
                      FadeAnimation(
                        1.5,
                        Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0),
                            color: Color(0xFFC31331),
                          ),
                          child: Icon(
                            Icons.handyman,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.7,
                        Container(
                          margin: EdgeInsets.only(left: 35.0, top: 30.0),
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0),
                            color: Color(0xFFCBB2AB),
                          ),
                          child: Icon(
                            Icons.build,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FadeAnimation(
                        1.9,
                        Container(
                          margin: EdgeInsets.only(left: 70.0),
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0),
                            color: Color(0xFFF79E1B),
                          ),
                          child: Icon(
                            Icons.format_paint,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FadeAnimation(
                        2.0,
                        Container(
                          margin: EdgeInsets.only(left: 105.0, top: 30.0),
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0),
                            color: Color(0xFF464656),
                          ),
                          child: Icon(
                            Icons.room,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      FadeAnimation(
                        2.2,
                        Container(
                          margin: EdgeInsets.only(
                            left: 140.0,
                          ),
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.0),
                            color: Color(0xFF2D2D2D),
                          ),
                          child: Icon(
                            Icons.plumbing,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                  2.4,
                  RichText(
                    text: TextSpan(
                        text: 'adv',
                        style: GoogleFonts.ubuntu(
                          color: Color(0xFF432344), //Color(0xFFC31331),
                          fontSize: 70.0,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Me',
                            style: GoogleFonts.ubuntu(
                              color: Color(0xFFF79E1B),
                              fontSize: 70.0,
                              letterSpacing: 0.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 300,
                        ),
                        TextFormField(
                          style: TextStyle(color: Color(0xFF2D2D2D)),
                          //Color(0xFFCBB2AB)),
                          cursorColor: Color(0xFFF79E1B),
                          key: ValueKey('email'),
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusColor: Color(0xFFCBB2AB),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFF464656),
                              ),
                            ),
                            fillColor: Colors.white10,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Color(0xFF2D2D2D),
                              //Color(0xFFCBB2AB),
                            ),
                            labelText: 'Address Eamil',
                            labelStyle: TextStyle(
                              color: Color(0xFF2D2D2D),
                              //Color(0xFFCBB2AB),
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Color(0xFFF79E1B),
                            ),
                          ),
                          onSaved: (value) {
                            _userEmail = value;
                          },
                        ),
                        SizedBox(height: 12),
                        if (!_isLogin)
                          TextFormField(
                            style: TextStyle(color: Color(0xFF2D2D2D)),
                            //Color(0xFFCBB2AB)),
                            cursorColor: Color(0xFFF79E1B),
                            key: ValueKey('username'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Please enter 4 chars at least';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFF464656),
                                ),
                              ),
                              fillColor: Colors.white10,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                color: Color(0xFFCBB2AB),
                              ),
                              labelText: 'Username',
                              labelStyle: TextStyle(
                                color: Color(0xFFCBB2AB),
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            onSaved: (value) {
                              _userName = value;
                            },
                          ),
                        SizedBox(height: 12),
                        TextFormField(
                          style: TextStyle(color: Color(0xFF2D2D2D)),
                          //Color(0xFFCBB2AB)),
                          cursorColor: Color(0xFFF79E1B),
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Password should contain 7 chars at least';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFF464656),
                              ),
                            ),
                            fillColor: Colors.white10,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Color(0xFF2D2D2D),
                              //Color(0xFFCBB2AB),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Color(0xFF2D2D2D),
                              //Color(0xFFCBB2AB),
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Color(0xFFF79E1B),
                            ),
                          ),
                          obscureText: true,
                          onSaved: (value) {
                            _userPassword = value;
                          },
                        ),
                        SizedBox(height: 12),
                        if (widget.isLoading) CircularProgressIndicator(),
                        if (!widget.isLoading)
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),

                              //side: BorderSide(color: Colors.green),
                            ),
                            color: Color(0xFFF79E1B),
                            child: Text(
                              _isLogin ? 'Sign in' : 'Sign up',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: _trySubmit,
                          ),
                        if (!widget.isLoading)
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),

                              //side: BorderSide(color: Colors.green),
                            ),

                            textColor:
                                Colors.black, //Theme.of(context).primaryColor,

                            child: Text(
                              _isLogin ? 'Create new account' : 'Have account',
                              style: TextStyle(
                                color: Color(0xFFCBB2AB),
                              ),
                            ),

                            color: Color(0xFF432344),

                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                          )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
