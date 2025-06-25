import 'package:cloud_firestore/cloud_firestore.dart';

class Outfit {
  final String outfitId; // Primary key (UID)
  final String userId; // Foreign key (UID)
  final String name;
  final List<String> itemIds;
  final String? stylingNotes;
  final int warCount;
  final Timestamp? lastWornDate;
  final Timestamp createdDate;

  Outfit({
    required this.outfitId,
    required this.userId,
    required this.name,
    required this.itemIds,
    this.stylingNotes,
    this.warCount = 0,
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
      warCount: json['warCount'] != null ? json['warCount'] as int : 0,
      lastWornDate: json['lastWornDate'] as Timestamp?,
      createdDate: json['createdDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'outfitId': outfitId,
      'userId': userId,
      'name': name,
      'itemIds': itemIds,
      'stylingNotes': stylingNotes,
      'warCount': warCount,
      'lastWornDate': lastWornDate,
      'createdDate': createdDate,
    };
  }
}
