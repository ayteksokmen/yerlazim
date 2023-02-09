import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:yerlazim/model/demand.dart';
import 'package:yerlazim/model/source.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yerlazim/notification.dart';
import 'package:yerlazim/util/Uuid.dart';

import 'model/match.dart';

final databaseReference = FirebaseDatabase.instance.
refFromURL("https://yer-lazim-default-rtdb.europe-west1.firebasedatabase.app");

class Db {

  static Db instance = Db();

  void createData() {

    databaseReference.child("flutterDevsTeam1").set({
      'name': 'Deepak Nishad',
      'description': 'Team Lead'
    });
    databaseReference.child("flutterDevsTeam2").set({
      'name': 'Yashwant Kumar',
      'description': 'Senior Software Engineer'
    });
    databaseReference.child("flutterDevsTeam3").set({
      'name': 'Akshay',
      'description': 'Software Engineer'
    });
    databaseReference.child("flutterDevsTeam4").set({
      'name': 'Aditya',
      'description': 'Software Engineer'
    });
    databaseReference.child("flutterDevsTeam5").set({
      'name': 'Shaiq',
      'description': 'Associate Software Engineer'
    });
    databaseReference.child("flutterDevsTeam6").set({
      'name': 'Mohit',
      'description': 'Associate Software Engineer'
    });
    databaseReference.child("flutterDevsTeam7").set({
      'name': 'Naveen',
      'description': 'Associate Software Engineer'
    });
  }

  void createSource(Source source) {
    databaseReference.child("sources").child(source.id).set(source.toJson());
    checkForMatchFromSource(source.city, source.id,
        source.latitude, source.longitude);
  }

  void createDemand(Demand demand) {
    databaseReference.child("demands").child(demand.id).set(demand.toJson());
    checkForMatchFromSource(demand.city, demand.id,
        demand.latitude, demand.longitude);
  }

  // Call this when someone creates a new source!
  void checkForMatchFromSource(String city, String sourceId, double sourceLat,
      double sourceLng) async {
    DatabaseReference demandsRef = FirebaseDatabase.instance.ref('demands');
    final event = await demandsRef.once(DatabaseEventType.value);
      for (final value in event.snapshot.children) {
        var demand = value.value;
        Map<String, dynamic> data = Map<String, dynamic>.from(json.decode(jsonEncode(demand)));
        if (data['city'] == city) {
          var lat = (data['longitude']);
          var lng = (data['longitude']);

          if (await checkIsNearbyLocation(sourceLat, sourceLng, lat, lng)) {
            var match = MatchModel(id: Uuid().generateV4(), sourceId: sourceId,
                demandId: data['id']);
            createMatch(match);
            NotificationManager.instance.displayNotification(match,
                NotificationType.forSource);
          }
        }
      }
  }

  // Call this when someone creates a new demand!
  void checkForMatchFromDemand(String city, String demandId, double demandLat,
      double demandLng) async {
    DatabaseReference sourcesRef = FirebaseDatabase.instance.ref('sources');
    final event = await sourcesRef.once(DatabaseEventType.value);
    for (final value in event.snapshot.children) {
      var source = value.value;
      Map<String, dynamic> data = Map<String, dynamic>.from(json.decode(jsonEncode(source)));
      if (data['city'] == city) {
        var lat = (data['longitude']);
        var lng = (data['longitude']);

        if (await checkIsNearbyLocation(demandLat, demandLng, lat, lng)) {
          var match = MatchModel(id: Uuid().generateV4(), sourceId: data['id'],
              demandId: demandId);
          createMatch(match);
          NotificationManager.instance.displayNotification(match,
              NotificationType.forDemand);
        }
      }
    }
  }

  Future<bool> checkIsNearbyLocation(double lat, double lng,
      double lat1, double lng1) async {
    var distanceInMeters = Geolocator.distanceBetween(
      lat,
      lng,
      lat1,
      lng1
    );

    var distanceInKM = distanceInMeters/1000;
    return distanceInKM < 5000;
  }

  void createMatch(MatchModel match) {
    databaseReference.child("matches").child(match.id).set(match.toJson());
  }

  void readData() async {
    DatabaseReference demandsRef = FirebaseDatabase.instance.ref('demands');
    final event = await demandsRef.once(DatabaseEventType.value);
    for (final child in event.snapshot.children) {
      print('demand : ${child.value}');
    }


    // final event = await databaseReference.once(DatabaseEventType.value);
    // event.snapshot.value["demands"]
    // print('Data : ${event.snapshot.value}');
    // final username = event.snapshot.value?;
    // databaseReference.once().then((DataSnapshot snapshot) {
    //   print('Data : ${snapshot.value}');
    // });
  }

  void updateData() {
    databaseReference.child('flutterDevsTeam1').update({
      'description': 'CEO'
    });
    databaseReference.child('flutterDevsTeam2').update({
      'description': 'Team Lead'
    });
    databaseReference.child('flutterDevsTeam3').update({
      'description': 'Senior Software Engineer'
    });
  }


  void deleteData() {
    databaseReference.child('flutterDevsTeam1').remove();
    databaseReference.child('flutterDevsTeam2').remove();
    databaseReference.child('flutterDevsTeam3').remove();
  }
}