import 'package:cloud_firestore/cloud_firestore.dart';

class WEARLOG {
  final String logId;
  final String userId;
  final String itemId;
  final String outfitId;
  final Timestamp wearDate;
  final String? notes;
  final Timestamp createdDate;

  WEARLOG({
    required this.logId,
    required this.userId,
    required this.itemId,
    required this.outfitId,
    required this.wearDate,
    this.notes,
    Timestamp? createdDate,
  }) : createdDate = createdDate ?? Timestamp.now();

  // Example: toJson for serialization
  Map<String, dynamic> toJson() => {
    'logId': logId,
    'userId': userId,
    'itemId': itemId,
    'outfitId': outfitId,
    'wearDate': wearDate,
    'notes': notes,
    'createdDate': createdDate,
  };

  // Example: fromJson for deserialization
  factory WEARLOG.fromJson(Map<String, dynamic> json) => WEARLOG(
    logId: json['logId'],
    userId: json['userId'],
    itemId: json['itemId'],
    outfitId: json['outfitId'],
    wearDate: Timestamp.fromMillisecondsSinceEpoch(json['wearDate']),
    notes: json['notes'],
    createdDate: json['createdDate'] as Timestamp,
  );
}
