import 'package:advMe/providers/orders.dart';
import 'package:advMe/screens/order_detail_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
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
          style: Theme.of(context).textTheme.headline6,
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
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
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
    if (searchTerm == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context);
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
              imageUrl: searchOrders[index].imageUrl,
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
            imageUrl: searchOrders[index].imageUrl,
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
