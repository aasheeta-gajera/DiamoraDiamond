import 'dart:convert';
import 'dart:ui';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/SharedPrefService.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/CartDiamond.dart';
import '../../Models/DiamondModel.dart';

class CardDiamonds extends StatefulWidget {
  final List<Diamond>? diamonds;

  const CardDiamonds({super.key, this.diamonds});

  @override
  _CardDiamondsState createState() => _CardDiamondsState();
}

class _CardDiamondsState extends State<CardDiamonds> {
  @override
  void initState() {
    super.initState();
    fetchCartDiamonds();
  }

  List<CartDiamond> cartDiamonds = [];
  bool isLoading = true;

  Future<void> fetchCartDiamonds() async {
    final String apiUrl = "${ApiService.baseUrl}/cartDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          cartDiamonds =
              (data['cartItems'] as List)
                  .map((item) => CartDiamond.fromJson(item))
                  .toList();
          isLoading = false;
        });
      } else {
        // utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('$e', false);
    }
  }

  final Map<String, String> shapeImages = {
    "Round": "Assets/Images/Round.png",
    "Princess": "Assets/Images/Round.png",
    "Emerald": "Assets/Images/emerald.png",
    "Asscher": "Assets/Images/Round.png",
    "Marquise": "Assets/Images/Marquise.png",
    "Oval": "Assets/Images/Oval.png",
    "Pear": "Assets/Images/Pear.png",
    "Heart": "Assets/Images/Heart.png",
    "Cushion": "Assets/Images/Cushion.png",
    "Radiant": "Assets/Images/Round.png",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text("Cart", style: TextStyleHelper.mediumPrimaryColour),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: AppColors.primaryColour,
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColour, AppColors.secondaryColour],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child:
                      isLoading
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryWhite,
                            ),
                          )
                          : cartDiamonds.isEmpty
                          ? Center(
                            child: Text(
                              AppString.noDataFound,
                              style: TextStyleHelper.mediumWhite,
                            ),
                          )
                          : ListView.builder(
                            itemCount: cartDiamonds.length,
                            itemBuilder: (context, index) {
                              final diamond = cartDiamonds[index];
                              List<String>? selectedShapes =
                                  diamond.diamondDetails.shape
                                      ?.split(",")
                                      .map((s) => s.trim())
                                      .toList();
                              List<String>? validShapes =
                                  selectedShapes
                                      ?.where(
                                        (shape) =>
                                            shapeImages.containsKey(shape),
                                      )
                                      .toList();
                              int? shapeCount = validShapes?.length;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {

                                  });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.diamond, color: Colors.white, size: 24),
                                            const SizedBox(width: 8),
                                            Text(
                                              "Diamond Item",
                                              style: TextStyleHelper.mediumWhite.copyWith(fontSize: 18),
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap: () async {
                                                print('asdfghjklkjhgfdsasdfghjk${cartDiamonds[index].id}');

                                                final success =
                                                    await removeDiamondFromCart(
                                                      diamond.id ?? "",
                                                );
                                                if (success) {
                                                  fetchCartDiamonds();
                                                  utils.showCustomSnackbar(
                                                    "Diamond removed from cart",
                                                    true,
                                                  );
                                                } else {
                                                  fetchCartDiamonds(); // fallback if API fails
                                                }
                                            },child: Icon(Icons.delete_outline, color: Colors.white.withOpacity(0.8))),
                                          ],
                                        ),
                                        const Divider(color: Colors.white54, height: 20),

                                        // Details: Weight, Color, Clarity, Certification
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 8,
                                          children: [
                                            _detailChip("Weight", "${diamond.diamondDetails.weightCarat ?? 'NA'}"),
                                            _detailChip("Clarity", "${diamond.diamondDetails.clarity ?? 'NA'}"),
                                            _detailChip("Certified", "${diamond.diamondDetails.certification ?? 'NA'}"),
                                            _detailChip("Size", "${diamond.diamondDetails.size ?? 'NA'}"),
                                            _detailChip("Cut", "${diamond.diamondDetails.cut ?? 'NA'}"),
                                            _detailChip("Shape", "${diamond.diamondDetails.shape ?? 'NA'}"),
                                            _detailChip("Price", "\$${diamond.diamondDetails.totalPurchasePrice ?? 'NA'}"),
                                            _detailChip("Color", "\$${diamond.diamondDetails.color ?? 'NA'}"),
                                          ],
                                        ),

                                        const SizedBox(height: 16),
                                        Text("Shapes", style: TextStyleHelper.mediumWhite.copyWith(fontSize: 16)),
                                        const SizedBox(height: 8),

                                        // Shapes Section
                                        shapeCount! > 0
                                            ? Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          children: List.generate(
                                            shapeCount,
                                                (index) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  shapeImages[validShapes![index]]!,
                                                  width: 40,
                                                  height: 40,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  validShapes[index],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                            : Text(
                                          AppString.noshapesavailable,
                                          style: TextStyleHelper.mediumWhite,
                                        ),

                                        const SizedBox(height: 16),
                                        // Price + Button Row
                                        Row(
                                          children: [
                                            Text(
                                              "\$${diamond.diamondDetails.totalPurchasePrice ?? 'NA'}",
                                              style: TextStyleHelper.mediumWhite.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                  ),
                                                  builder:
                                                      (context) =>
                                                      SellConfirmationSheet(
                                                        cartDiamonds:
                                                        cartDiamonds,
                                                      ),
                                                );
                                              },
                                              icon: const Icon(Icons.shopping_cart_outlined),
                                              label: const Text("Add to Cart"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> removeDiamondFromCart(String diamondId) async {
    try {

      final String apiUrl = "${ApiService.baseUrl}/cartDiamonds/$diamondId";
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );
      print('sssssss  ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      } else {
        utils.showCustomSnackbar("Failed to remove diamond", false);
        return false;
      }
    } catch (e) {
      utils.showCustomSnackbar("Error: ${e.toString()}", false);
      print(e);
      return false;
    }
  }

  Future<bool> showRemoveConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.white,
                titlePadding: const EdgeInsets.only(top: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                actionsPadding: const EdgeInsets.only(bottom: 15, right: 10),
                title: Column(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Remove from Cart",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                content: const Text(
                  "Are you sure you want to remove this diamond from the cart?",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}

Widget _detailChip(String label, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.white54),
    ),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.white, fontSize: 13),
        children: [
          TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}

class SellConfirmationSheet extends StatefulWidget {
  final List<CartDiamond> cartDiamonds;

  const SellConfirmationSheet({Key? key, required this.cartDiamonds})
    : super(key: key);

  @override
  _SellConfirmationSheetState createState() => _SellConfirmationSheetState();
}

class _SellConfirmationSheetState extends State<SellConfirmationSheet> {
  bool isLoading = false;

  Future<void> sellDiamond(CartDiamond diamond) async {
    final userId = await SharedPrefService.getString('userId') ?? '';
    print("userIduserId   ${userId}");

    final String paymentMethod = "Credit Card";  // This can be dynamic based on user input
    final String transactionId = "TX123456789"; // This can be dynamically generated or retrieved from a payment API

    // Extract payment status from the diamond object (make sure this is correctly retrieved)
    final String paymentStatus = diamond.diamondDetails.paymentStatus ?? 'Pending'; // Default to 'Pending' if not available

    final sellData = {
      "userId": userId,
      "itemCode": diamond.itemCode,
      "customerName": diamond.diamondDetails.supplier,
      "quantity": diamond.quantity,
      "totlePrice": diamond.diamondDetails.totalPurchasePrice,
      "paymentStatus": paymentStatus, // Now using the payment status extracted from the diamond object
      "paymentMethod": paymentMethod, // New field for payment method
      "transactionId": transactionId, // New field for transaction ID
    };

    final url = Uri.parse("${ApiService.baseUrl}/sellDiamond");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(sellData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = json.decode(response.body);
        utils.showCustomSnackbar(res['message'], true);
      } else {
        print("Error selling ${diamond.itemCode}: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('$e', false);
    }
  }

  List<CartDiamond> localCart = [];

  @override
  void initState() {
    localCart = List.from(widget.cartDiamonds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "🛒 Confirm Diamond Purchase",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          // Diamond List with Card UI
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: widget.cartDiamonds.length,
              itemBuilder: (context, index) {
                final diamond = widget.cartDiamonds[index];

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "💎 Item Code: ${diamond.itemCode}",
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),

                        // Diamond Details (Shape, Color, etc.)
                        Text(
                          "Shape: ${diamond.diamondDetails.shape}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          "Color: ${diamond.diamondDetails.color}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          "Clarity: ${diamond.diamondDetails.clarity}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          "Certification: ${diamond.diamondDetails.certification ?? 'N/A'}",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),

                        // Quantity and Price
                        Text("🔢 Quantity: ${diamond.quantity}"),
                        Text(
                          "💰 Price: \$${diamond.diamondDetails.totalPurchasePrice?.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.green[700]),
                        ),
                        const SizedBox(height: 8),

                        // Quantity Adjustment Row
                        Row(
                          children: [
                            IconButton(
                              onPressed: diamond.quantity > 1
                                  ? () {
                                setState(() {
                                  diamond.quantity--;
                                });
                              }
                                  : null, // Disable "remove" if quantity is 1
                              icon: const Icon(Icons.remove_circle_outline),
                              color: theme.colorScheme.primary,
                            ),
                            Text(
                              diamond.quantity.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              onPressed: diamond.quantity < (diamond.diamondDetails.totalDiamonds ?? 0)
                                  ? () {
                                setState(() {
                                  // Ensure quantity cannot go beyond the available stock
                                  if (diamond.quantity < (diamond.diamondDetails.totalDiamonds ?? 0)) {
                                    diamond.quantity++;
                                  }
                                });
                              }
                                  : null, // Disable "add" if quantity >= available stock
                              icon: const Icon(Icons.add_circle_outline),
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Confirm Button
          isLoading
              ? const CircularProgressIndicator()
              : SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    setState(() => isLoading = true);
                    try {
                      for (CartDiamond diamond in localCart) {
                        await sellDiamond(diamond);
                      }

                      Navigator.pop(context);
                      utils.showCustomSnackbar(
                        '✅ Diamonds sold successfully!',
                        true,
                      );
                    } catch (e) {
                      utils.showCustomSnackbar('$e', false);
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Confirm & Purchase"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColour,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
