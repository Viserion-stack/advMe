import 'package:advMe/providers/products.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/screens/ads_screen.dart';
import 'package:advMe/screens/auth_screen.dart';
import 'package:advMe/screens/categories_screen.dart';
import 'package:advMe/screens/home_screen.dart';
import 'package:advMe/screens/orders_screen.dart';
import 'package:advMe/screens/order_detail_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
      ],
      child: MaterialApp(
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
          //CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
          //OrderDetailScreen.routeName: (ctx) => OrderDetailScreen(),
          CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
          //'/category-meals': (ctx) =>CategoryMealsScreen(),
        },

        // ignore: missing_return
        onGenerateRoute: (settings) {
          print(settings.arguments);
          // if (settings.name == '/meal-detail') {
          //   return ...;
          // } else if (settings.name == '/something-else') {
          //   return ...;
          // }
          // return MaterialPageRoute(builder: (ctx) => CategoriesScreen(),);
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (ctx) => CategoriesScreen(),
          );
        },
      ),
    );
  }
}
