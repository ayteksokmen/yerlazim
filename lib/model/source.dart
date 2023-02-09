import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Source extends Equatable {
  final String id;
  final String name;
  final String surname;
  final String phone;
  final String phone2;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final String note;

  const Source({required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.phone2,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.note});

  @override
  List<Object?> get props => [id, name, surname, phone, phone2, city, address,
    latitude, longitude, note,];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'surname': surname,
    'phone': phone,
    'phone2': phone2,
    'city': city,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
    'note': note,
  };
}
