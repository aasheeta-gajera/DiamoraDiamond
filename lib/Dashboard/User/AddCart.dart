import 'dart:convert';
import 'dart:ui';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
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
                                    // if (selectedDiamonds.contains(diamond)) {
                                    //   selectedDiamonds.remove(diamond);
                                    // } else {
                                    //   selectedDiamonds.add(diamond);
                                    // }
                                  });
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 8,
                                          sigmaY: 8,
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.08,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.15,
                                                ),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 5),
                                              Text(
                                                "──── Range ────",
                                                style:
                                                    TextStyleHelper.mediumWhite,
                                              ),
                                              const SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                    ),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    AppString
                                                                        .weight,
                                                                style: TextStyleHelper
                                                                    .mediumWhite
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${diamond.diamondDetails.weightCarat}",
                                                                style:
                                                                    TextStyleHelper
                                                                        .mediumWhite,
                                                              ),
                                                            ],
                                                          ),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        color: Colors.white,
                                                        thickness: 2,
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    AppString
                                                                        .color,
                                                                style: TextStyleHelper
                                                                    .mediumWhite
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${diamond.diamondDetails.color}",
                                                                style:
                                                                    TextStyleHelper
                                                                        .mediumWhite,
                                                              ),
                                                            ],
                                                          ),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                    ),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    AppString
                                                                        .clarity,
                                                                style: TextStyleHelper
                                                                    .mediumWhite
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${diamond.diamondDetails.clarity}",
                                                                style:
                                                                    TextStyleHelper
                                                                        .mediumWhite,
                                                              ),
                                                            ],
                                                          ),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        color: Colors.white,
                                                        thickness: 2,
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    AppString
                                                                        .certified,
                                                                style: TextStyleHelper
                                                                    .mediumWhite
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${diamond.diamondDetails.certification}",
                                                                style:
                                                                    TextStyleHelper
                                                                        .mediumWhite,
                                                              ),
                                                            ],
                                                          ),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                    ),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: "size: ",
                                                                style: TextStyleHelper
                                                                    .mediumWhite
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${diamond.diamondDetails.size}",
                                                                style:
                                                                    TextStyleHelper
                                                                        .mediumWhite,
                                                              ),
                                                            ],
                                                          ),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                        ),
                                                      ),
                                                      const VerticalDivider(
                                                        color: Colors.white,
                                                        thickness: 2,
                                                        width: 20,
                                                      ),
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "supplier: ",
                                                                style: TextStyleHelper
                                                                    .mediumWhite
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "${diamond.diamondDetails.supplier}",
                                                                style:
                                                                    TextStyleHelper
                                                                        .mediumWhite,
                                                              ),
                                                            ],
                                                          ),
                                                          softWrap: true,
                                                          overflow:
                                                              TextOverflow
                                                                  .visible,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "──── Shapes ────",
                                                style:
                                                    TextStyleHelper.mediumWhite,
                                              ),
                                              if (shapeCount! > 0)
                                                shapeCount == 1
                                                    ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Align(
                                                        alignment:
                                                            Alignment
                                                                .centerLeft,
                                                        child: SizedBox(
                                                          width: 80,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Image.asset(
                                                                shapeImages[validShapes![0]]!,
                                                                width: 40,
                                                                height: 40,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                validShapes[0],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    : shapeCount <= 3
                                                    ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: List.generate(shapeCount, (
                                                          index,
                                                        ) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      4.0,
                                                                ),
                                                            child: SizedBox(
                                                              width: 80,
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Image.asset(
                                                                    shapeImages[validShapes![index]]!,
                                                                    width: 40,
                                                                    height: 40,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    validShapes[index],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    )
                                                    : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6.0,
                                                          ),
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  shapeCount > 4
                                                                      ? 4
                                                                      : shapeCount,
                                                              crossAxisSpacing:
                                                                  4,
                                                              mainAxisSpacing:
                                                                  8,
                                                              childAspectRatio:
                                                                  1,
                                                            ),
                                                        itemCount: shapeCount,
                                                        itemBuilder: (
                                                          context,
                                                          index,
                                                        ) {
                                                          return SizedBox(
                                                            width: 80,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                  shapeImages[validShapes![index]]!,
                                                                  width: 40,
                                                                  height: 40,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  validShapes[index],
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                              else
                                                Text(
                                                  AppString.noshapesavailable,
                                                  style:
                                                      TextStyleHelper
                                                          .mediumWhite,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 3,
                                      right: 9,
                                      child: IconButton(
                                        onPressed: () async {
                                            final success = await removeDiamondFromCart(diamond.id ?? "",);
                                            if (success) {
                                                fetchCartDiamonds();
                                              utils.showCustomSnackbar("Diamond removed from cart", true,);
                                            } else {
                                              fetchCartDiamonds(); // fallback if API fails
                                            }

                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline_sharp,
                                        ),
                                        color: AppColors.primaryWhite,
                                      ),
                                    ),
                                    Positioned(
                                      top: 3,
                                      right: 35,
                                      child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                            ),
                                            builder: (context) => SellConfirmationSheet(cartDiamonds: cartDiamonds),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.add_box_outlined,
                                        ),
                                        color: AppColors.primaryWhite,
                                      ),
                                    ),
                                  ],
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

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.overlayLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryWhite, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyleHelper.extraLargeWhite.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyleHelper.mediumWhite.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
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

      if (response.statusCode == 200) {
        return true;
      } else {
        utils.showCustomSnackbar("Failed to remove diamond", false);
        return false;
      }
    } catch (e) {
      utils.showCustomSnackbar("Error: ${e.toString()}", false);
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

class SellConfirmationSheet extends StatefulWidget {
  final List<CartDiamond> cartDiamonds;

  const SellConfirmationSheet({Key? key, required this.cartDiamonds}) : super(key: key);

  @override
  _SellConfirmationSheetState createState() => _SellConfirmationSheetState();
}

class _SellConfirmationSheetState extends State<SellConfirmationSheet> {
  bool isLoading = false; // Add the loading state flag

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Confirm Diamond Sales",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),

          const SizedBox(height: 16),

          // Diamond List
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: widget.cartDiamonds.length,
              itemBuilder: (context, index) {
                final diamond = widget.cartDiamonds[index];
                return ListTile(
                  title: Text("ItemCode: ${diamond.itemCode}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: ${diamond.diamondDetails.supplier}"),
                      Text("Quantity: ${diamond.quantity}"),
                      Text("Price: \$${diamond.diamondDetails.totalPurchasePrice?.toStringAsFixed(2)}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Decrease Button
                      ElevatedButton(
                        onPressed: diamond.quantity > 1 // Disable if quantity is 1 or less
                            ? () {
                          setState(() {
                            diamond.quantity--; // Decrease quantity safely
                          });
                        }
                            : null, // Disable if quantity is 1 or less
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 10),
                      // Quantity Display
                      Text(diamond.quantity.toString(), style: TextStyle(fontSize: 16)),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: (diamond.quantity ?? 0) < (diamond.diamondDetails.totalDiamonds ?? 0) // Ensure quantity doesn't exceed totalDiamonds
                            ? () {
                          setState(() {
                            diamond.quantity = (diamond.quantity ?? 0) + 1; // Safely increase quantity
                          });
                        }
                            : null, // Disable if quantity equals totalDiamonds
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Confirm Purchase Button
          isLoading
              ? Center(child: CircularProgressIndicator()) // Show loading indicator while processing
              : ElevatedButton.icon(
            onPressed: () async {
              setState(() => isLoading = true); // Start loading
              for (CartDiamond diamond in widget.cartDiamonds) {
                final sellData = {
                  "itemCode": diamond.itemCode,
                  "customerName": diamond.diamondDetails.supplier,
                  "quantity": diamond.quantity,
                  "totlePrice": diamond.diamondDetails.totalPurchasePrice,
                  "paymentStatus": "Paid",
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
                    print("Sold: ${res['message']}");
                  } else {
                    print("Error selling ${diamond.itemCode}: ${response.body}");
                  }
                } catch (e) {
                  setState(() => isLoading = false); // Stop loading on error
                  print("Exception selling ${diamond.itemCode}: $e");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  return; // Exit the loop early if there's an error
                }
              }

              setState(() => isLoading = false); // Stop loading after the API request completes
              Navigator.pop(context); // Close BottomSheet
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Diamonds sold successfully!")));
            },
            icon: Icon(Icons.shopping_cart_checkout),
            label: Text("Confirm Purchase"),
            style: ElevatedButton.styleFrom(
              // primary: Theme.of(context).primaryColor, // Use primary color for the button
              // onPrimary: Theme.of(context).accentColor, // Icon color based on theme
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
