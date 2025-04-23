import 'DiamondModel.dart';

class CartDiamond {
  final String id;
  final String userId;
  final String itemCode;
  final int quantity;
  final double price;
  final Diamond diamondDetails;

  CartDiamond({
    required this.id,
    required this.userId,
    required this.itemCode,
    required this.quantity,
    required this.price,
    required this.diamondDetails,
  });

  factory CartDiamond.fromJson(Map<String, dynamic> json) {
    return CartDiamond(
      id: json['_id'],
      userId: json['userId'],
      itemCode: json['itemCode'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      diamondDetails: Diamond.fromJson(json['diamondDetails']),
    );
  }
}
