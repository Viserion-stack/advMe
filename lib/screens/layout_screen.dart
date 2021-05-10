import 'package:advMe/screens/drawer_screen.dart';
import 'package:advMe/screens/home_screen.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Duration duration = Duration(milliseconds: 300);

  @override
  void initState() {
  Provider.of<user.User>(context, listen: false).getUserData();
    _controller = AnimationController(duration: duration, vsync: this);
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<user.User>(context, listen: false).getUserData(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            //Provider.of<SettingsUser>(context, listen: false).getSettings();
            return Center(
                child: SpinKitWave(
              color: Color(0xFF00D1CD),
            )
                //CircularProgressIndicator(),
                );
          }
          return Scaffold(
            backgroundColor: Color(0xFF3C3C3C),
            body: Stack(
              children: [
                DrawerScreen(
                  
                  controller: _controller,
                ),
                HomeScreen(
                  controller: _controller,
                  duration: duration,
                )
              ],
            ),
          );
        });
  }
}
