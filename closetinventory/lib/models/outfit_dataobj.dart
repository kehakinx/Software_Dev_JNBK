import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String outfitId; // Primary key (UID)
  final String userId; // Foreign key (UID)
  final String name;
  final List<String> itemIds;
  final String? stylingNotes;
  final int wearCount;
  final Timestamp? lastWornDate;
  final Timestamp createdDate;

  Outfit({
    required this.outfitId,
    required this.userId,
    required this.name,
    required this.itemIds,
    this.stylingNotes,
    this.wearCount = 0,
    this.lastWornDate,
    Timestamp? createdDate,
  }) : createdDate = createdDate ?? Timestamp.now();

  factory Outfit.fromJson(Map<String, dynamic> json) {
    return Outfit(
      outfitId: json['outfitId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      itemIds: List<String>.from(json['itemIds'] ?? []),
      stylingNotes: json['stylingNotes'] as String?,
      wearCount: json['wearCount'] != null ? json['wearCount'] as int : 0,
      lastWornDate: json['lastWornDate'] as Timestamp? ?? Timestamp.now(),
      createdDate: json['createdDate'] as Timestamp? ?? Timestamp.now(),
    );
  }

  factory Outfit.fromDocument(DocumentSnapshot doc) {
    return Outfit(
      outfitId: doc['outfitId'] as String,
      userId: doc['userId'] as String,
      name: doc['name'] as String,
      itemIds: List<String>.from(doc['itemIds'] ?? []),
      stylingNotes: doc['stylingNotes'] as String?,
      wearCount: doc['wearCount'] != null ? doc['wearCount'] as int : 0,
      lastWornDate: doc['lastWornDate'] as Timestamp? ?? Timestamp.now(),
      createdDate: doc['createdDate'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'outfitId': outfitId,
      'userId': userId,
      'name': name,
      'itemIds': itemIds,
      'stylingNotes': stylingNotes,
      'wearCount': wearCount,
      'lastWornDate': lastWornDate,
      'createdDate': createdDate,
    };
  }
}
