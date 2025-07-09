import 'package:cloud_firestore/cloud_firestore.dart';

class USER {
  final String userId;
  final String email;
  final String displayName;
  final String? profileImageUrl;
  final Map<String, dynamic>? preference;
  final Timestamp createdDate;

  USER({
    required this.userId,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    this.preference,
    Timestamp? createdDate,
  }) : createdDate = createdDate ?? Timestamp.now();

  factory USER.fromJson(Map<String, dynamic> json) {
    return USER(
      userId: json['userId'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      preference: Map<String, dynamic>.from(
        json['preference'] ?? {},
      ),
      createdDate: json['createdDate'] as Timestamp? ?? Timestamp.now(),
    );
  }

  factory USER.fromDocument(DocumentSnapshot doc) {
    return USER(
      userId: doc['userId'] as String,
      email: doc['email'] as String,
      displayName: doc['displayName'] as String,
      profileImageUrl: doc['profileImageUrl'] as String?,
      preference: Map<String, dynamic>.from(
        doc['preference'] ?? {},
      ),
      createdDate: doc['createdDate'] as Timestamp? ?? Timestamp.now(),
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
