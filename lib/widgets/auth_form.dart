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
    return Scaffold(backgroundColor: Colors.green[600],
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
                  Colors.grey[200],
                  Colors.grey[400],
                  Colors.grey,
                  Colors.grey[600],
                ],
              ),
            ),
            padding: EdgeInsets.only(top: 100.0),
            child: Text(
              'advMe',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Pacifico',
                fontSize: 70.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.6,
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
                              side: BorderSide(color: Colors.green),
                            ),
                            color: Colors.white70,
                            child: Text(
                              _isLogin ? 'Sign in' : 'Sign up',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: _trySubmit,
                          ),
                        if (!widget.isLoading)
                          FlatButton(
                            textColor: Colors.black,//Theme.of(context).primaryColor,
                            child: Text(_isLogin
                                ? 'Create new account'
                                : 'Have account'),
                            color: Colors.black12,
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
