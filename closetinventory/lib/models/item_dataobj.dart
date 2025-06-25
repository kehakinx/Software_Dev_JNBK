import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String itemId;
  final String userId;
  final String name;
  final String type;
  final String brand;
  final String size;
  final String color;
  final String material;
  final Timestamp? purchaseDate;
  final double? price;
  final String? careInstructions;
  final List<String>? photoUrls;
  final List<String>? tags;
  final Map<String, dynamic>? customAttributes;
  final String? currentLocationId;
  final int? wearCount;
  final Timestamp? lastWornDate;
  final String? declutterStatus;
  final bool isDuplicateSuggestion;
  final Timestamp? createdDate;

  Item({
    required this.itemId,
    required this.userId,
    required this.name,
    required this.type,
    required this.brand,
    required this.size,
    required this.color,
    required this.material,
    this.purchaseDate,
    this.price,
    this.careInstructions,
    this.photoUrls,
    this.tags,
    this.customAttributes,
    this.currentLocationId,
    this.wearCount = 0,
    this.lastWornDate,
    this.declutterStatus,
    this.isDuplicateSuggestion = false,
    this.createdDate,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['itemId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      brand: json['brand'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      material: json['material'] as String,
      purchaseDate: json['purchaseDate'] as Timestamp,
      price: (json['price'] as num).toDouble(),
      careInstructions: json['careInstructions'] as String?,
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      customAttributes: Map<String, dynamic>.from(
        json['customAttributes'] ?? {},
      ),
      currentLocationId: json['currentLocationId'] as String,
      wearCount: json['wearCount'] as int,
      lastWornDate: json['lastWornDate'] as Timestamp,
      declutterStatus: json['declutterStatus'] as String,
      isDuplicateSuggestion: json['isDuplicateSuggestion'] as bool,
      createdDate: json['createdDate'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'userId': userId,
      'name': name,
      'type': type,
      'brand': brand,
      'size': size,
      'color': color,
      'material': material,
      'purchaseDate': purchaseDate,
      'price': price,
      'careInstructions': careInstructions,
      'photoUrls': photoUrls,
      'tags': tags,
      'customAttributes': customAttributes,
      'currentLocationId': currentLocationId,
      'wearCount': wearCount,
      'lastWornDate': lastWornDate,
      'declutterStatus': declutterStatus,
      'isDuplicateSuggestion': isDuplicateSuggestion,
      'createdDate': createdDate,
    };
  }
}
