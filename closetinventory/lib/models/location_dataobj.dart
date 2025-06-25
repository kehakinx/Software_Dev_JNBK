import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String locationId;
  final String userId;
  final String name;
  final String? description;
  final Timestamp createdDate;

  Location({
    required this.locationId,
    required this.userId,
    required this.name,
    this.description,
    required this.createdDate,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdDate: json['createdDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'userId': userId,
      'name': name,
      'description': description,
      'createdDate': createdDate,
    };
  }
}
