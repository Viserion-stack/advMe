import 'package:advMe/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:advMe/helpers/string_extenstion.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  var errorMessage;

  void _showErrorDialog(String message) {
    print(message);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'userName': username.capitalize(),
          'email': email,
          'isDark': false,
          'isNotif': false,
          'createdAt': DateTime.now(),
          'isPremium': false,
          'imageUrl': '',
        });
        var user = FirebaseAuth.instance.currentUser;
        user.updateProfile(
          displayName: username,
          photoURL:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Felis_catus-cat_on_snow.jpg/1280px-Felis_catus-cat_on_snow.jpg',
        );
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';
      print(err);
      if (err.message != null) {
        message = err.message;
      }

      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        //errorMessage = error.toString();
      });

      if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('invalid-email')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('weak-password')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('user-not-found')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('wrong-password')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
