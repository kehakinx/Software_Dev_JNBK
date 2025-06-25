import 'package:cloud_firestore/cloud_firestore.dart';

class USER {
  final String userId;
  final String email;
  final String displayName;
  final String? profileImageUrl;
  final Map<String, dynamic> preference;
  final Timestamp createdDate;

  USER({
    required this.userId,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    required this.preference,
    required this.createdDate,
  });

  factory USER.fromJson(Map<String, dynamic> json) {
    return USER(
      userId: json['userId'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      preference: Map<String, dynamic>.from(json['preference'] as Map),
      createdDate: json['createdDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'preference': preference,
      'createdDate': createdDate,
    };
  }
}
