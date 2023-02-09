// import 'dart:async';
// import 'dart:math';
//
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:yerlazim/place_service.dart';
// import 'package:yerlazim/util/Uuid.dart';
//
// import 'address_search.dart';
//
// final searchScaffoldKey = GlobalKey<ScaffoldState>();
//
// class AddressSearchScaffold extends PlacesAutocompleteWidget {
//   AddressSearchScaffold({Key? key})
//       : super(
//     key: key, apiKey: "AIzaSyA_53fhhSn0RIvjBLXHM7GTDA_CAOmfKNQ",
//     sessionToken: Uuid().generateV4(),
//     language: "tr",
//     components: [Component(Component.country, "tr")],
//   );
//
//   @override
//   _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
// }
//
// class _CustomSearchScaffoldState extends PlacesAutocompleteState {
//   final _controller = TextEditingController();
//   String _streetNumber = '';
//   String _street = '';
//   String _city = '';
//   String _zipCode = '';
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Container(
//       margin: const EdgeInsets.only(left: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           TextField(
//             controller: _controller,
//             readOnly: true,
//             onTap: () async {
//               // generate a new token here
//               final sessionToken = Uuid().generateV4();
//               final Suggestion? result = await showSearch(
//                 context: context,
//                 delegate: AddressSearch(sessionToken),
//               );
//               // This will change the text displayed in the TextField
//               if (result != null) {
//                 final placeDetails = await PlaceApiProvider(sessionToken)
//                     .getPlaceDetailFromId(result.placeId);
//                 setState(() {
//                   _controller.text = result.description;
//                   _streetNumber = placeDetails.streetNumber ?? "";
//                   _street = placeDetails.street ?? "";
//                   _city = placeDetails.city ?? "";
//                   _zipCode = placeDetails.zipCode ?? "";
//                 });
//               }
//             },
//             decoration: InputDecoration(
//               icon: Container(
//                 width: 10,
//                 height: 10,
//                 child: const Icon(
//                   Icons.home,
//                   color: Colors.black,
//                 ),
//               ),
//               hintText: "Konaklama Adresi",
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
//             ),
//           ),
//           const SizedBox(height: 20.0),
//           Text('Cadde no: $_streetNumber'),
//           Text('Cadde: $_street'),
//           Text('Şehir: $_city'),
//           Text('Posta Kodu: $_zipCode'),
//         ],
//       ),
//     ),
//     );
//   }
// }