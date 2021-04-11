import 'package:advMe/animation/fade_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
    //final settings = Provider.of<SettingsUser>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/screen.jpeg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Positioned(
              top: !_isLogin
                  ? MediaQuery.of(context).size.height * 0.06
                  : MediaQuery.of(context).size.height * 0.15,
              left: MediaQuery.of(context).size.width * 0.25,
              child: FadeAnimation(
                1.4,
                Container(
                  //padding: EdgeInsets.only(top: 100.0),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.57,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/logo.png',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            if (!_isLogin)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                left: MediaQuery.of(context).size.width * 0.27,
                child: Text(
                  'Registration',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.teal[400],
                      fontWeight: FontWeight.bold),
                ),
              ),
            if (!_isLogin)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.42,
                left: MediaQuery.of(context).size.width * 0.39,
                child: Text(
                  'Join us!',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                  ),
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
                          FadeAnimation(
                            1.7,
                            Container(
                              width: MediaQuery.of(context).size.width * 0.68,
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  //Color(0xFFCBB2AB)),
                                  cursorColor: Colors.black,
                                  key: ValueKey('email'),
                                  validator: (value) {
                                    if (value.isEmpty || !value.contains('@')) {
                                      return 'Please enter a valid email address';
                                    }

                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 14),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      //Color(0xFFCBB2AB),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onSaved: (value) {
                                    _userEmail = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (!_isLogin)
                            Container(
                              width: MediaQuery.of(context).size.width * 0.68,
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Color(0xFFCBB2AB),
                                  ),
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
                                    contentPadding: EdgeInsets.only(top: 14),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    hintText: 'Username',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onSaved: (value) {
                                    _userName = value;
                                  },
                                ),
                              ),
                            ),
                          FadeAnimation(
                            1.9,
                            Container(
                              width: MediaQuery.of(context).size.width * 0.68,
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFCBB2AB),
                                  ),
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
                                    contentPadding: EdgeInsets.only(top: 14),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.transparent,
                                    )),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      //Color(0xFFCBB2AB),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                  ),
                                  obscureText: true,
                                  onSaved: (value) {
                                    _userPassword = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          if (widget.isLoading)
                            SpinKitWave(
                              color: Color(0xFFF79E1B),
                            ),
                          if (!widget.isLoading)
                            FadeAnimation(
                              2.2,
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),

                                    //side: BorderSide(color: Colors.green),
                                  ),
                                  color: Colors.teal[300],
                                  child: Text(
                                    _isLogin ? 'Sign in' : 'Sign up',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: _trySubmit,
                                ),
                              ),
                            ),
                          SizedBox(height: 25),
                          FadeAnimation(
                            2.4,
                            Text(
                              'Are you new on this App?',
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          if (!widget.isLoading)
                            FadeAnimation(
                              2.6,
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),

                                    //side: BorderSide(color: Colors.green),
                                  ),

                                  textColor: Colors
                                      .black, //Theme.of(context).primaryColor,

                                  child: Text(
                                    _isLogin
                                        ? 'Create account'
                                        : 'Have account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),

                                  color: Colors.teal,

                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                ),
                              ),
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
      ),
    );
  }
}
