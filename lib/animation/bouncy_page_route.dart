import 'package:flutter/cupertino.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget widget;

  BouncyPageRoute({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 350),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAniamtion,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOut);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.bottomLeft,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAniamtion) {
              return widget;
            });
}

class BouncyPageRouteListItem extends PageRouteBuilder {
  final Widget widget;

  BouncyPageRouteListItem({this.widget})
      : super(
            transitionDuration: Duration(milliseconds: 350),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAniamtion,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.easeInOut);
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.bottomLeft,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAniamtion) {
              return widget;
            });
}
