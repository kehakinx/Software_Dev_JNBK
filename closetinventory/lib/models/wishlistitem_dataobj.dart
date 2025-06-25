import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistItem {
  final String wishlistItem; // Primary key (UID)
  final String userId; // Foreign key (UID)
  final String name;
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

  Map<String, dynamic> toJson() {
    return {
      'wishlistItem': wishlistItem,
      'userId': userId,
      'name': name,
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
