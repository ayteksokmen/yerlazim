// import 'package:flutter/material.dart';
// import 'package:yerlazim/place_service.dart';
// import 'package:yerlazim/util/Uuid.dart';
//
// class AddressSearch extends SearchDelegate<Suggestion> {
//   AddressSearch(this.sessionToken) {
//     apiClient = PlaceApiProvider(sessionToken);
//   }
//
//   final sessionToken;
//   late PlaceApiProvider apiClient;
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         tooltip: 'Clear',
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       tooltip: 'Back',
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, Suggestion(Uuid().generateV4(), ""));
//       },
//     );
//   }
//
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return FutureBuilder(
//       future: query == ""
//           ? null
//           : apiClient.fetchSuggestions(
//           query, Localizations.localeOf(context).languageCode),
//       builder: (context, snapshot) => query == ''
//           ? Container(
//         padding: EdgeInsets.all(16.0),
//         child: Text('Adres Girişi Yapın'),
//       )
//           : snapshot.hasData
//           ? ListView.builder(
//         itemBuilder: (context, index) {
//           var data = (snapshot.data as List<Suggestion>)[index];
//           return ListTile(
//           title:
//           Text((data).description),
//           onTap: () {
//             close(context, data);
//           },
//         );
//         },
//         itemCount: (snapshot.data as List<Suggestion>).length,
//       )
//           : Container(child: Text('Loading...')),
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return ListView();
//   }
// }