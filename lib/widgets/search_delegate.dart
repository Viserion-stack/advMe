// import 'package:advMe/dummy_data.dart';
// import 'package:flutter/material.dart';
 

// class name extends StatefulWidget {
//   name({Key key}) : super(key: key);

//   @override
//   _nameState createState() => _nameState();
// }

// class _nameState extends State<name> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: child,
//     );
//   }
// }




// class CategoryMealsScreen extends StatelessWidget {
//    static const routeName = '/category-meals';
//    // final String categoryId;
//  class CategoryMealsScreen extends StatelessWidget {
//      return Scaffold(
//        appBar: AppBar(
//         title: Text(categoryTitle),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {
//                 showSearch(context: context, delegate: DataSearch());
//               }),
//         ],
//       ),
//       body: ListView.builder(
//         itemBuilder: (ctx, index) {
//  class CategoryMealsScreen extends StatelessWidget {
//     );
//   }
// }

// class DataSearch extends SearchDelegate<String> {
// //  final routeArgs =
// //         ModalRoute.of(context).settings.arguments as Map<String, String>;
// //     final categoryTitle = routeArgs['title'];
// //     final categoryId = routeArgs['id'];
// //     final categoryMeals = DUMMY_MEALS.where((meal) {
// //       return meal.categories.contains(categoryId);
// //     }).toList();

//   final ads = [
//     'Malowanie dachĂłw',
//     'Remont Ĺ‚azienki',
//     'Czyszczenie',
//     'Transport',
//     'Transportowanie',
//     'Tranzition',
//     'Czekanie',
//     'Remapowanie',
//     'Regipsy',
//   ];

//   final recentads = [
//     'Czyszczenie',
//     'Transport',
//     'Transportowanie',
//     'Regipsy',
//   ];

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     // TODO: implement buildActions
//     return [
//       IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             query = '';
//           })
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: AnimatedIcon(
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         close(context, null);
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final sugestionList = query.isEmpty
//         ? recentads
//         : ads.where((p) => p.startsWith(query)).toList();

//     return ListView.builder(
//       itemBuilder: (context, index) => ListTile(
//         leading: Icon(Icons.location_city),
//         title: RichText(
//           text: TextSpan(
//             text: sugestionList[index].substring(0, query.length),
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             children: [
//               TextSpan(
//                 text: sugestionList[index].substring(query.length),
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ),
//       ),
//       itemCount: sugestionList.length,
//     );
//   }
// }