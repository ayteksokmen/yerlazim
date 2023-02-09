import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MatchModel extends Equatable {
  final String id;
  final String sourceId;
  final String demandId;

  const MatchModel({required this.id,
    required this.sourceId,
    required this.demandId});

  @override
  List<Object?> get props => [id, sourceId, demandId];

  @override
  bool? get stringify => true;

  Map<String, dynamic> toJson() => {
    'id': id,
    'sourceId': sourceId,
    'demandId': demandId
  };
}