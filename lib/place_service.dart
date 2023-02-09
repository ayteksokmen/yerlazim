import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

const kGoogleApiKey = "AIzaSyA_53fhhSn0RIvjBLXHM7GTDA_CAOmfKNQ";

class Place {
  String? streetNumber;
  String? street;
  String? city;
  String? zipCode;
  
  Place({
    this.streetNumber,
    this.street,
    this.city,
    this.zipCode,
  });

  @override
  String toString() {
    return 'Place(streetNumber: $streetNumber, street: $street, city: $city, zipCode: $zipCode)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken, this.context);

  final sessionToken;
  final BuildContext context;

  static const String androidKey = 'AIzaSyD90rfDp_T9hXiuqfK7ZYQqq4EBDgYycpw';
  static const String iosKey = 'AIzaSyDZxDlkVA52_o9jon_PtwJS4YQuOmpS32c';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<void> openAddressSearch(String city,
      Function(String? description,
          double latitude, double longitude) addressCallback) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: Mode.fullscreen,
      language: "tr",
      types: [],
      strictbounds: false,
      decoration: InputDecoration(
        hintText: 'Adres Girin',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      components: [Component(Component.country, "tr")],
    );

    displayPrediction(prediction, context, addressCallback);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }

  Future<void> displayPrediction(Prediction? prediction, BuildContext context,
      Function(String? description, double latitude, double longitude) addressCallback) async {
    if (prediction != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(prediction.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      addressCallback(prediction.description, lat, lng);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${prediction.description} - $lat/$lng")),
      );
    }
  }

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&types=address&components=country:tr&key=$apiKey&sessiontoken=$sessionToken';
    final requestUri = Uri.dataFromString(request);
    final response = await client.get(requestUri,
        headers: await const GoogleApiHeaders().getHeaders());

    print("response == " + response.body);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component&key=$apiKey&sessiontoken=$sessionToken';
    final requestUri = Uri.dataFromString(request);
    final response = await client.get(requestUri);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final components =
        result['result']['address_components'] as List<dynamic>;
        // build result
        final place = Place();
        for (var c in components) {
          final List type = c['types'];
          if (type.contains('street_number')) {
            place.streetNumber = c['long_name'];
          }
          if (type.contains('route')) {
            place.street = c['long_name'];
          }
          if (type.contains('locality')) {
            place.city = c['long_name'];
          }
          if (type.contains('postal_code')) {
            place.zipCode = c['long_name'];
          }
        }
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}