import 'package:uuid/uuid.dart';

class WEARLOG {
  final String logId;
  final String userId;
  final String itemId;
  final String outfitId;
  final DateTime wearDate;
  final String? notes;
  final DateTime createdDate;

  WEARLOG({
    String? logId,
    required this.userId,
    required this.itemId,
    required this.outfitId,
    required this.wearDate,
    this.notes,
    DateTime? createdDate,
  }) : logId = logId ?? const Uuid().v4(),
       createdDate = createdDate ?? DateTime.now();

  // Example: toJson for serialization
  Map<String, dynamic> toJson() => {
    'logId': logId,
    'userId': userId,
    'itemId': itemId,
    'outfitId': outfitId,
    'wearDate': wearDate.toIso8601String(),
    'notes': notes,
    'createdDate': createdDate.toIso8601String(),
  };

  // Example: fromJson for deserialization
  factory WEARLOG.fromJson(Map<String, dynamic> json) => WEARLOG(
    logId: json['logId'],
    userId: json['userId'],
    itemId: json['itemId'],
    outfitId: json['outfitId'],
    wearDate: DateTime.parse(json['wearDate']),
    notes: json['notes'],
    createdDate: json['createdDate'] != null
        ? DateTime.parse(json['createdDate'])
        : null,
  );
}
