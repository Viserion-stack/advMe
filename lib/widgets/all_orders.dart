import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:advMe/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'order_grid_item.dart';

class AllOrders extends StatefulWidget {
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  final List<String> categories = [
    'Construction',
    'Renovation',
    'Transport',
    'Mechanic',
  ];

  final List<Color> colorsDark = [
    Color(0xFFF79E1B),
    Color(0xFFCBB2AB),
    Color(0xEEC31331),
    Color(0xFF464656),
  ];

  final List<Color> colorsLight = [
    Color(0xFFFFC03D),
    Color(0xFF387CFF),
    Color(0xFFF1554C),
    Color(0xFF0D276B),
  ];
  bool isYourAds = false;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: settings.isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
      ),
      child: Stack(children: [
        Center(
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              'advMe',
              style: GoogleFonts.ubuntu(
                color: settings.isDark ? Color(0x40C31331) : Color(0x78FFC03D),
                fontSize: 140,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Column(children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            height: MediaQuery.of(context).size.height * .1,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: settings.isDark
                              ? colorsDark[index]
                              : colorsLight[index],
                          borderRadius: BorderRadius.circular(40)),
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('allAds').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                if (orderSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: SpinKitWave(
                    color: Color(0xFFF79E1B),
                  ));
                }
                return StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (_) =>
                        StaggeredTile.fit(1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    crossAxisCount: 2,
                    itemCount: orderSnapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                                      print('Ilość załadowanych ogłoszeń futurebuilderem ' +
                    orderSnapshot.data.docs.length.toString());
                      DocumentSnapshot userData =
                          orderSnapshot.data.docs[index];
                      return OrderGridItem(
                        description: userData.data()['description'],
                        id: userData.id,
                        title: userData.data()['title'],
                        imageUrl1: userData.data()['imageUrl1'],
                        imageUrl2: userData.data()['imageUrl2'],
                        imageUrl3: userData.data()['imageUrl3'],
                        isFavorite: false,
                        price: userData.data()['price'],
                        phone: userData.data()['phone'],
                        website: userData.data()['website'],
                        address: userData.data()['address'],
                        isYourAds: isYourAds,
                      );
                    });

                // CustomScrollView(
                //  slivers:[ SliverToBoxAdapter(
                //                     child: MasonryGrid(
                //     column: 2,

                // print('Ilość załadowanych ogłoszeń futurebuilderem ' +
                //     orderSnapshot.data.docs.length.toString());
                // return ListView.builder(
                //   cacheExtent: 1000,
                //   reverse: false,
                //   itemCount: orderSnapshot.data.docs.length,
                //   itemBuilder: (ctx, index) {
                //     DocumentSnapshot userData =
                //         orderSnapshot.data.docs[index];

                // children: List.generate(orderSnapshot.data.docs.length, index) {
                //   DocumentSnapshot userData =
                //      orderSnapshot.data.docs[index];
              },
            ),
          ),
        ])
      ]),
    );
  }
}
