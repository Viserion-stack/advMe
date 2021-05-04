import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/widgets/orders_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class Searchwidget extends StatefulWidget {
  Searchwidget({Key key}) : super(key: key);

  @override
  _SearchwidgetState createState() => _SearchwidgetState();
}

class _SearchwidgetState extends State<Searchwidget> {
  static const historyLength = 5;

  List<String> _searchHistory = [
    'fuchisa',
    'flutter',
    'widgets',
    'resocoder',
    'newitem',
  ];

  List<String> filteredSearchHistory;

  String selectedTerm;
  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isDark = false;
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    isDark = settings.isDark;
    if (settings.isDark == null) isDark = false;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          //color: Color(0xFFF3F3F3),
          image: DecorationImage(
            image: AssetImage(
              'assets/grey.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 20,
                    ),
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.chevron_left,
                        color: Color(0xFFF8BB06),
                        size: 46,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 18,
                  top: 20,
                ),
                child: RichText(
                  text: TextSpan(
                      text: 'Add',
                      style: GoogleFonts.quicksand(
                        color: Colors.black,
                        fontSize: 28.0,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Advertisment',
                          style: GoogleFonts.quicksand(
                            color: Color(0xFFF8BB06),
                            fontSize: 28.0,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: FloatingSearchBar(
             maxWidth: MediaQuery.of(context).size.width * .84,
              backdropColor: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              iconColor: Colors.black,
              backgroundColor: Colors.white,
              controller: controller,
              body: FloatingSearchBarScrollNotifier(
                child: SearchResultsListView(
                  searchTerm: selectedTerm,
                ),
              ),
              transition: CircularFloatingSearchBarTransition(),
              physics: BouncingScrollPhysics(),
              title: Text(
                selectedTerm ?? 'e.g renovation of apartments',
                style: TextStyle(
                  color: Color(0xFFCECECE),
                  fontSize: 15,
                ),
                //Theme.of(context).textTheme.headline6,
              ),
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              hint: 'Search and find out...',
              actions: [
                FloatingSearchBarAction.searchToClear(),
              ],
              onQueryChanged: (query) {
                setState(() {
                  filteredSearchHistory = filterSearchTerms(filter: query);
                });
              },
              onSubmitted: (query) {
                setState(() {
                  addSearchTerm(query);
                  selectedTerm = query;
                });
                controller.close();
              },
              builder: (context, transition) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Material(
                    color: Colors.white,
                    elevation: 4,
                    child: Builder(
                      builder: (context) {
                        if (filteredSearchHistory.isEmpty &&
                            controller.query.isEmpty) {
                          return Container(
                            
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[300],
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              height: 56,
                              width: MediaQuery.of(context).size.width * .6,
                              alignment: Alignment.center,
                              child: Text(
                                'Start searching',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? Color(0xFFCBB2AB)
                                      : Color(0xFF387CFF),
                                  //Theme.of(context).textTheme.caption,
                                ),
                              ));
                        } else if (filteredSearchHistory.isEmpty) {
                          return ListTile(
                            title: Text(controller.query),
                            leading: const Icon(
                              Icons.search,
                              size: 35,
                              // color: settings.isDark
                              //     ? Color(0xFFF79E1B)
                              //     : Color(0xFF387CFF),
                            ),
                            onTap: () {
                              setState(() {
                                addSearchTerm(controller.query);
                                selectedTerm = controller.query;
                              });
                              controller.close();
                            },
                          );
                        } else {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: filteredSearchHistory
                                .map(
                                  (term) => ListTile(
                                    title: Text(
                                      term,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          deleteSearchTerm(term);
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        putSearchTermFirst(term);
                                        selectedTerm = term;
                                      });
                                      controller.close();
                                    },
                                  ),
                                )
                                .toList(),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;

  const SearchResultsListView({
    Key key,
    @required this.searchTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsUser>(context);
    bool isDark = settings.isDark;
    if (settings.isDark == null) isDark = false;
    if (searchTerm == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.black,
            ),
            Text(
              'Start searching',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
              //Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    //final fsb = FloatingSearchBar.of(context);
    final orderstsData = Provider.of<Orders>(context);
    final orders = orderstsData.items;
    final searchOrders = orders.where((ord) {
      return ord.title.contains(searchTerm);
    }).toList();

    return ListView.builder(
      cacheExtent: 1000,
      reverse: false,
      itemCount: searchOrders.length,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return Column(children: [
            SizedBox(
              height: 70,
            ),
            OrdersItem(
              id: searchOrders[index].id,
              title: searchOrders[index].title,
              description: searchOrders[index].description,
              isFavorite: false,
              imageUrl1: searchOrders[index].imageUrl1,
              imageUrl2: searchOrders[index].imageUrl2,
              imageUrl3: searchOrders[index].imageUrl3,
              price: searchOrders[index].price,
              phone: searchOrders[index].phone,
              website: searchOrders[index].website,
              address: searchOrders[index].address,
              category: searchOrders[index].category,
            )
          ]);
        } else {
          return OrdersItem(
            id: searchOrders[index].id,
            title: searchOrders[index].title,
            description: searchOrders[index].description,
            isFavorite: false,
            imageUrl1: searchOrders[index].imageUrl1,
            imageUrl2: searchOrders[index].imageUrl2,
            imageUrl3: searchOrders[index].imageUrl3,
            price: searchOrders[index].price,
            phone: searchOrders[index].phone,
            website: searchOrders[index].website,
            address: searchOrders[index].address,
            category: searchOrders[index].category,
          );
        }
      },
    );
  }
}
