import 'package:advMe/screens/drawer_screen.dart';
import 'package:advMe/screens/home_screen.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:advMe/widgets/all_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LayoutScreen extends StatefulWidget {
  final int screen;
  LayoutScreen({Key key, this.screen}) : super(key: key);
  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Duration duration = Duration(milliseconds: 300);

  @override
  void initState() {
    //Provider.of<user.User>(context, listen: false).getUserData();
    _controller = AnimationController(duration: duration, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreen(
        controller: _controller,
        duration: duration,
      ),
      AllOrders(
        controller: _controller,
        duration: duration,
      ),
    ];

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
         // Provider.of<user.User>(context).setScreenIndex(0);
        //   final userData = Provider.of<user.User>(context);
        //  var screenIndex = userData.getCurrentIndex();
          // final screenIndex =
          //     Provider.of<user.User>(context, listen: false).screenIndex;
          // print(screenIndex);

          return Scaffold(
            backgroundColor: Color(0xFF3C3C3C),
            body: Stack(
              children: [
                DrawerScreen(
                  controller: _controller,
                ),
                screens[widget.screen],
                // HomeScreen(
                //   controller: _controller,
                //   duration: duration,
                // )
              ],
            ),
          );
        });
  }
}
