import 'package:advMe/providers/orders.dart';
import 'package:advMe/providers/settings.dart';
import 'package:advMe/widgets/orders_item.dart';
import 'package:flutter/material.dart';
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
    if(settings.isDark == null) isDark = false;
    return Scaffold(
      backgroundColor: isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
      body: FloatingSearchBar(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        iconColor: isDark ? Color(0xFF464656) : Color(0xFF0D276B),
        backgroundColor:
            isDark ? Color(0xCCFFC03D) : Color(0xCCFFC03D),
        controller: controller,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm ?? 'Search for orders',
          style: TextStyle(
            color: isDark ? Color(0xFF464656) : Color(0xFF0D276B),
            fontSize: 20,
          ),
          //Theme.of(context).textTheme.headline6,
        ),
        hintStyle: TextStyle(
          color: isDark ? Color(0xFF464656) : Color(0xFF0D276B),
          fontSize: 20,
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
              color: isDark ? Color(0xFF171923) : Color(0xFFE9ECF5),
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                        height: 56,
                        width: double.infinity,
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
                                  color: isDark
                                      ? Color(0xFFFFC03D)
                                      : Color(0xFF0D276B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Icon(
                                Icons.history,
                                color: isDark
                                    ? Color(0xFFFFC03D)
                                    : Color(0xFF0D276B),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: isDark
                                      ? Color(0xFFF1554C)
                                      : Color(0xFFF1554C),
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
    if(settings.isDark == null) isDark = false;
    if (searchTerm == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: isDark ? Color(0xFFF79E1B) : Color(0xFFFFC03D),
            ),
            Text(
              'Start searching',
              style: TextStyle(
                fontSize: 30,
                color: isDark ? Color(0xFFCBB2AB) : Color(0xFF387CFF),
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
          );
        }
      },
    );
  }
}
