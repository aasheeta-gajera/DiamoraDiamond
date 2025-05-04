import 'DiamondModel.dart';

class CartDiamond {
  final String id;  // Cart item's ID (MongoDB _id)
  final String userId;  // User's ID
  final String itemCode;  // Unique item code for the diamond
  int quantity;  // Mutable, as it can change (e.g., when user updates quantity)
  final double price;  // Price of the diamond
  final Diamond diamondDetails;  // Details of the diamond (probably an object)

  CartDiamond({
    required this.id,
    required this.userId,
    required this.itemCode,
    required this.quantity,
    required this.price,
    required this.diamondDetails,
  });

  // Factory method to create a CartDiamond object from JSON response
  factory CartDiamond.fromJson(Map<String, dynamic> json) {
    return CartDiamond(
      id: json['_id'],
      userId: json['userId'],
      itemCode: json['itemCode'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      diamondDetails: Diamond.fromJson(json['diamondDetails']),  // Assuming a Diamond class
    );
  }

  // Method to convert the CartDiamond object into JSON format
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'itemCode': itemCode,
      'quantity': quantity,
      'price': price,
      'diamondDetails': diamondDetails.toJson(),
    };
  }
}

