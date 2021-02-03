import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.green[600],
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
              ),
            ),
            padding: EdgeInsets.only(top: 100.0),
            child: Column(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0xFF03A89E),
                        ),
                        child: Icon(
                          Icons.handyman,
                          color: Colors.white,
                        ),
                      ),
                       Container(
                         margin: EdgeInsets.only(left:35.0, top: 30.0),
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0xFFCD3700),
                        ),
                        child: Icon(
                          Icons.build,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                         margin: EdgeInsets.only(left:70.0),
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0xFFFFD700),
                        ),
                        child: Icon(
                          Icons.format_paint,
                          color: Colors.white,
                        ),
                      ),
                      
                      Container(
                         margin: EdgeInsets.only(left:105.0,top: 30.0),
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0xFF3D59AB),
                        ),
                        child: Icon(
                          Icons.room,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                         margin: EdgeInsets.only(left:140.0,),
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0xFFFF6103),
                        ),
                        child: Icon(
                          Icons.plumbing,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'advMe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFDA04),
                    fontFamily: 'CarterOne',
                    fontSize: 70.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.6,
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
                          key: ValueKey('email'),
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: Colors.white10,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintText: 'Email',
                            labelText: 'Address Eamil',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                          onSaved: (value) {
                            _userEmail = value;
                          },
                        ),
                        SizedBox(height: 12),
                        if (!_isLogin)
                          TextFormField(
                            key: ValueKey('username'),
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return 'Please enter 4 chars at least';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.white10,
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintText: 'Username',
                              labelText: 'Username',
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
                          key: ValueKey('password'),
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Password should contain 7 chars at least';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white10,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintText: 'Password',
                            labelText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
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
                            color: Color(0xFFFFCC08),
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
                            child: Text(_isLogin
                                ? 'Create new account'
                                : 'Have account',style: TextStyle(color: Colors.white),),
                            color: Color(0xFF3D59AB),
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
