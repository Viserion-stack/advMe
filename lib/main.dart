import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/ads_screen.dart';
import 'package:advMe/screens/auth_screen.dart';
import 'package:advMe/screens/home_screen.dart';
import 'package:advMe/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider.value(
      value: SettingsUser(),
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'advMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return HomeScreen(); //ChatScreen();
            }
            return AuthScreen();
          }),
      routes: {
        OrdersScreen.routeName: (ctx) => OrdersScreen(),
        AdsScreen.routeName: (ctx) => AdsScreen(),
      },
    );
  }
}
