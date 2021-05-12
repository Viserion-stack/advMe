import 'package:advMe/providers/orders.dart';
import 'package:advMe/widgets/search_delegate.dart';
import 'package:advMe/providers/user.dart' as user;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'order_grid_item.dart';

class AllOrders extends StatefulWidget {
  final AnimationController controller;
  final Duration duration;

  const AllOrders({Key key, this.controller, this.duration}) : super(key: key);

  static const routeName = '/allOrders';
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  double tranx = 0, trany = 0, scale = 1.0;
  bool menuOpen = false;
  Animation<double> _scaleAnimation;

  String valueChoosen = 'All';
  List<String> categories = [
    'All',
    'Construction',
    'Renovation',
    'Transport',
    'Mechanic',
  ];
  bool isYourAds = false;
  bool isFavorite = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 1, end: 0.6).animate(widget.controller);
    }
    print('Rebuild all orders');
    final ordersData = Provider.of<Orders>(context);
    var categoryOrders = ordersData.items.where((order) {
      return order.category.contains(valueChoosen);
    }).toList();

    final orders = ordersData.items;
    if (valueChoosen == 'All') {
      categoryOrders = orders;
    }
    final isDark = Provider.of<user.User>(context, listen: false).isDark;
    print('isDark = ' + isDark.toString());
    return SafeArea(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: isDark
                  ? AssetImage(
                      'assets/dark.jpg',
                    )
                  : AssetImage(
                      'assets/grey.png',
                    ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Image.asset(
                      isDark
                          ? 'assets/small_logo_dark.png'
                          : 'assets/small_logo.png',
                      fit: BoxFit.contain,
                      height: 60,
                      width: 120,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.36,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Searchwidget()));
                      },
                      child: Icon(
                        Icons.search,
                        size: 35,
                        color: isDark ? Color(0xFF959595) : Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.01,
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .1,
                ),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    height: MediaQuery.of(context).size.height * .17,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  valueChoosen = categories[index];
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 20,
                                  bottom: 15,
                                  right: 3,
                                  left: 5,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isDark
                                            ? Color(0xFF00D1CD)
                                            : Colors.black,
                                        width: isDark ? 2.0 : 0.08,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark
                                              ? Color(0x0000001A)
                                              : Colors.grey[300],
                                          blurRadius: 10,
                                          spreadRadius: 0.5,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                      color: valueChoosen == categories[index]
                                          ? (isDark
                                              ? Color(0xFF00D1CD)
                                              : Color(0xFFFFD320))
                                          : (isDark
                                              ? Colors.transparent
                                              : Colors.white),
                                      borderRadius: BorderRadius.circular(15)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                  child: Center(
                                    child: Text(
                                      categories[index],
                                      style: TextStyle(
                                        color: valueChoosen == categories[index]
                                            ? Colors.white
                                            : (isDark
                                                ? Color(0xFF00D1CD)
                                                : Color(0xFFFFD320)),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                        staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                        mainAxisSpacing: 0.1,
                        crossAxisSpacing: 0.1,
                        crossAxisCount: 2,
                        itemCount: categoryOrders.length,
                        itemBuilder: (ctx, i) {
                          for (int index = 0;
                              index < ordersData.itemFavorite.length;
                              index++) {
                            if (categoryOrders[i].id.toString() ==
                                ordersData.itemFavorite[index].toString()) {
                              isFavorite = true;

                              print('AAAAA' + categoryOrders[i].id);
                              break;
                            } else {
                              isFavorite = false;
                            }
                          }
                          //print('AAAAA' + categoryOrders[i].id);
                          return ChangeNotifierProvider.value(
                            //builder: (c) => products[i],
                            value: categoryOrders[i],
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 6.0, right: 6.0, bottom: 6),
                              child: OrderGridItem(
                                userId: categoryOrders[i].userId,
                                description: categoryOrders[i].description,
                                id: categoryOrders[i].id,
                                title: categoryOrders[i].title,
                                imageUrl1: categoryOrders[i].imageUrl1,
                                imageUrl2: categoryOrders[i].imageUrl2,
                                imageUrl3: categoryOrders[i].imageUrl3,
                                isFavorite:
                                    isFavorite, //categoryOrders[i].isFavorite,
                                price: categoryOrders[i].price,
                                phone: categoryOrders[i].phone,
                                website: categoryOrders[i].website,
                                address: categoryOrders[i].address,
                                isYourAds: isYourAds,
                                rating: categoryOrders[i].rating,
                                countRating: categoryOrders[i].countRating,
                                sumRating: categoryOrders[i].sumRating,
                              ),
                            ),
                          );
                        }),
                  )
                ]),
              ),
            ],
          )),
    );
  }
}
