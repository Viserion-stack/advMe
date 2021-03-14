import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/widgets/all_orders.dart';
import 'package:advMe/widgets/favorite_orders.dart';
import 'package:advMe/widgets/search_delegate.dart';
import 'package:advMe/widgets/your_ads.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key key}) : super(key: key);
  static const routeName = '/OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context, listen: false).fetchAndSetProducts();
      Provider.of<Orders>(context, listen: false).fetchFavorite();
    });

    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              padding: EdgeInsets.only(left: 0, right: 35),
              icon: Icon(Icons.search,
                  color:
                      settings.isDark ? Color(0xFFF79E1B) : Color(0xFF0D276B),
                  size: 40),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Searchwidget()));
              }),
        ],
        backgroundColor:
            settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Color(0x40F79E1B),
                  //       offset: Offset(2.0, 2.0),
                  //       blurRadius: 5.0,
                  //       spreadRadius: 1.0),
                  //   BoxShadow(
                  //       color: Color(0x40F79E1B),
                  //       offset: Offset(-2.0, -2.0),
                  //       blurRadius: 5.0,
                  //       spreadRadius: 1.0),
                  // ],
                  color:
                      settings.isDark ? Color(0x40303250) : Color(0xFF0D276B)),
              child: Icon(
                Icons.chevron_left,
                color: settings.isDark ? Color(0xFFF79E1B) : Color(0xFFFFC03D),
                size: 40,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Expanded(
            child: RichText(
              text: TextSpan(
                  text: 'lookFor',
                  style: GoogleFonts.ubuntu(
                    color:
                        settings.isDark ? Color(0xFFCBB2AB) : Color(0xFF0D276B),
                    fontSize: 24.0,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Orders',
                      style: GoogleFonts.ubuntu(
                        color: Color(0xFFF79E1B),
                        fontSize: 24.0,
                        letterSpacing: 0.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xEEC31331),
          labelColor: settings.isDark ? Colors.white : Color(0xFF0D276B),
          indicatorWeight: 5.0,
          //isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(child: Text('All', style: TextStyle(fontSize: 18))),
            Tab(child: Text('Yours', style: TextStyle(fontSize: 18))),
            Tab(child: Text('Favorite', style: TextStyle(fontSize: 18))),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: <Widget>[
        //Center(child: Text('All orders',style: TextStyle(fontSize: 30))),
        AllOrders(),
        YourAds(),
        FavoriteOrders(),
        //Center(child: Text('Yours orders',style: TextStyle(fontSize: 30))),
      ]),
    );
  }
}
