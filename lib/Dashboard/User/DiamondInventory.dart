import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
import '../../Library/AppStrings.dart';
import '../../Library/SharedPrefService.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class DiamondInventory extends StatefulWidget {
  final List<Diamond>? diamonds;

  const DiamondInventory({super.key, this.diamonds});

  @override
  _DiamondInventoryState createState() => _DiamondInventoryState();
}

class _DiamondInventoryState extends State<DiamondInventory> {
  List<Diamond> diamonds = [];
  bool isLoading = true;
  List<Diamond> selectedDiamonds = [];
  final ScreenshotController screenshotController = ScreenshotController();
  Diamond diamond = Diamond();

  @override
  void initState() {
    super.initState();
    if (widget.diamonds != null) {
      setState(() {
        diamonds = widget.diamonds!;
        isLoading = false;
      });
    } else {
      fetchDiamonds();
    }
  }

  Future<void> fetchDiamonds() async {
    final String apiUrl = "${ApiService.baseUrl}/getAllPurchasedDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      ApiService().printLargeResponse(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          diamonds = (data["diamonds"] as List).map((json) => Diamond.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('${e}', false);
    }
  }

  Future<void> addToCart(BuildContext context, String userId, String itemCode, int quantity) async {
    final String apiUrl = "${ApiService.baseUrl}/addToCart";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "itemCode": itemCode,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200) {
        utils.showCustomSnackbar("Added to cart successfully!", true);
      } else {
        final error = jsonDecode(response.body)['message'];
        utils.showCustomSnackbar("Error: $error", false);
      }
    } catch (e) {
      utils.showCustomSnackbar("Error: $e", false);
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
        title: Text(
          AppString.diamondInventory,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        actions: [
          if (selectedDiamonds.isNotEmpty)
            IconButton(
              icon: Icon(Icons.inventory, color: AppColors.primaryColour),
              tooltip: "Training Info",
              onPressed: () {
                showAddToCartBottomSheet(
                  context: context,
                  diamonds: selectedDiamonds,
                  addToCartFn: (userId, itemCode, quantity) {
                    for (var diamond in selectedDiamonds) {
                      if (diamond.itemCode != null) {
                        addToCart(context, userId, diamond.itemCode!, quantity);
                      }
                    }
                  },
                );
              },
            ),
        ],
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
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      AppString.diamondInventory,
                      style: TextStyleHelper.extraLargeWhite.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your diamond inventory',
                      style: TextStyleHelper.mediumWhite.copyWith(
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Diamonds',
                        diamonds.length.toString(),
                        Icons.diamond_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Total Value',
                        '30000',
                        Icons.attach_money_outlined,
                      ),
                    ),
                  ],
                ),
              ),

              // Diamond List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(24),
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
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryWhite,
                          ),
                        )
                      : diamonds.isEmpty
                          ? Center(
                              child: Text(
                                AppString.noDataFound,
                                style: TextStyleHelper.mediumWhite,
                              ),
                            )
                          : ListView.builder(
                              itemCount: diamonds.length,
                              itemBuilder: (context, index) {
                                final diamond = diamonds[index];
                                List<String>? selectedShapes = diamond.shape?.split(",").map((s) => s.trim()).toList();
                                List<String>? validShapes = selectedShapes?.where((shape) => shapeImages.containsKey(shape)).toList();
                                int? shapeCount = validShapes?.length;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedDiamonds.contains(diamond)) {
                                        selectedDiamonds.remove(diamond);
                                      } else {
                                        selectedDiamonds.add(diamond);
                                      }
                                    });
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: selectedDiamonds.contains(diamond)
                                                ? AppColors.primaryWhite
                                                : Colors.white.withOpacity(0.2),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.15),
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
                                              style: TextStyleHelper.mediumWhite,
                                            ),
                                            const SizedBox(height: 5),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.weight,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.weightCarat}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const VerticalDivider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                      width: 20,
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.color,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.color}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.clarity,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.clarity}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const VerticalDivider(
                                                      color: Colors.white,
                                                      thickness: 2,
                                                      width: 20,
                                                    ),
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.certified,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.certification}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "──── Shapes ────",
                                              style: TextStyleHelper.mediumWhite,
                                            ),
                                            if (shapeCount! > 0)
                                              shapeCount == 1
                                                  ? Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: SizedBox(
                                                          width: 80,
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Image.asset(
                                                                shapeImages[validShapes![0]]!,
                                                                width: 40,
                                                                height: 40,
                                                                color: Colors.white,
                                                              ),
                                                              const SizedBox(height: 5),
                                                              Text(
                                                                validShapes[0],
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : shapeCount <= 3
                                                      ? Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: List.generate(shapeCount, (index) {
                                                              return Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                                child: SizedBox(
                                                                  width: 80,
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Image.asset(
                                                                        shapeImages[validShapes![index]]!,
                                                                        width: 40,
                                                                        height: 40,
                                                                        color: Colors.white,
                                                                      ),
                                                                      const SizedBox(height: 5),
                                                                      Text(
                                                                        validShapes[index],
                                                                        textAlign: TextAlign.center,
                                                                        style: const TextStyle(
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500,
                                                                          color: Colors.white,
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
                                                          padding: const EdgeInsets.all(6.0),
                                                          child: GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: shapeCount > 4 ? 4 : shapeCount,
                                                              crossAxisSpacing: 4,
                                                              mainAxisSpacing: 8,
                                                              childAspectRatio: 1,
                                                            ),
                                                            itemCount: shapeCount,
                                                            itemBuilder: (context, index) {
                                                              return SizedBox(
                                                                width: 80,
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Image.asset(
                                                                      shapeImages[validShapes![index]]!,
                                                                      width: 40,
                                                                      height: 40,
                                                                      color: Colors.white,
                                                                    ),
                                                                    const SizedBox(height: 5),
                                                                    Text(
                                                                      validShapes[index],
                                                                      textAlign: TextAlign.center,
                                                                      style: const TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.white,
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
                                                style: TextStyleHelper.mediumWhite,
                                              ),
                                          ],
                                        ),
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
}

void showAddToCartBottomSheet({
  required BuildContext context,
  required List<Diamond> diamonds,
  required Function(String userId, String itemCode, int quantity) addToCartFn,
}) {
  final TextEditingController quantityController = TextEditingController();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selected Diamonds (${diamonds.length})",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                itemCount: diamonds.length,
                itemBuilder: (context, index) {
                  final d = diamonds[index];
                  return Text("• ${d.itemCode} - Qty: ${d.totalDiamonds ?? 'N/A'}");
                },
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Quantity (applies to all)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final userId = await SharedPrefService.getString('userId') ?? '';
                  int quantity = int.tryParse(quantityController.text) ?? 0;

                  if (quantity <= 0) {
                    utils.showCustomSnackbar("Enter a valid quantity", false);
                    return;
                  }

                  bool hasAvailable = diamonds.any((d) => (d.totalDiamonds ?? 0) > 0);
                  if (!hasAvailable) {
                    utils.showCustomSnackbar("No selected diamonds are available.", false);
                    return;
                  }

                  Navigator.pop(context);

                  for (var d in diamonds) {
                    int? availableQty = d.totalDiamonds;
                    if (availableQty != null && availableQty > 0) {
                      addToCartFn(userId, d.itemCode ?? "", quantity);
                    }
                  }
                },
                child: Text("Add All to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColour,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

