import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistItem {
  final String wishlistItem; // Primary key (UID)
  final String userId; // Foreign key (UID)
  final String name;
  final String description;
  final String type;
  final String brand;
  final double? desiredPrice;
  final String? reason;
  final bool isPurchased;
  final String? imageUrl;
  final Timestamp createdDate;

  WishlistItem({
    required this.wishlistItem,
    required this.userId,
    required this.name,
    required this.description,
    required this.type,
    required this.brand,
    this.desiredPrice,
    this.reason,
    this.isPurchased = false,
    this.imageUrl,
    Timestamp? createdDate,
  }) : createdDate = createdDate ?? Timestamp.now();

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      wishlistItem: json['wishlistItem'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String,
      desiredPrice: (json['desiredPrice'] != null)
          ? (json['desiredPrice'] as num).toDouble()
          : null,
      reason: json['reason'] as String?,
      isPurchased: json['isPurchased'] ?? false,
      imageUrl: json['imageUrl'] as String?,
      createdDate: json['createdDate'] is Timestamp
          ? json['createdDate']
          : (json['createdDate'] != null
                ? Timestamp.fromMillisecondsSinceEpoch(json['createdDate'])
                : Timestamp.now()),
    );
  }

  factory WishlistItem.fromDocument(DocumentSnapshot doc) {
    return WishlistItem(
      wishlistItem: doc['wishlistItem'] as String,
      userId: doc['userId'] as String,
      name: doc['name'] as String,
      description: doc['description'] as String,
      type: doc['type'] as String,
      brand: doc['brand'] as String,
      desiredPrice: (doc['desiredPrice'] != null)
          ? (doc['desiredPrice'] as num).toDouble()
          : null,
      reason: doc['reason'] as String?,
      isPurchased: doc['isPurchased'] ?? false,
      imageUrl: doc['imageUrl'] as String?,
      createdDate: doc['createdDate'] is Timestamp
          ? doc['createdDate']
          : (doc['createdDate'] != null
                ? Timestamp.fromMillisecondsSinceEpoch(doc['createdDate'])
                : Timestamp.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wishlistItem': wishlistItem,
      'userId': userId,
      'name': name,
      'description': description,
      'type': type,
      'brand': brand,
      'desiredPrice': desiredPrice,
      'reason': reason,
      'isPurchased': isPurchased,
      'imageUrl': imageUrl,
      'createdDate': createdDate,
    };
  }
}
