
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
import 'package:flutter_slidable/flutter_slidable.dart';

import 'DiamondDetilas.dart';

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
  var totleValue = 0;

  Future<void> fetchDiamonds() async {
    final String apiUrl = "${ApiService.baseUrl}/getAllPurchasedDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      ApiService().printLargeResponse(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          diamonds = (data["diamonds"] as List)
              .map((json) {
            final diamond = Diamond.fromJson(json);
            // Accumulate the total value for each diamond
            final diamondValue = (diamond.purchasePrice ?? 0) * (diamond.totalDiamonds ?? 0);
            totleValue += diamondValue;  // Add the current diamond's value to total
            print('Diamond Value: $diamondValue');  // Print value for each diamond
            return diamond;
          })
              .toList();
          print('Total Value of all Diamonds: $totleValue'); // Print total value after all diamonds are processed
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

  Future<void> addToCart(BuildContext context, String itemCode, int quantity) async {
    final String apiUrl = "${ApiService.baseUrl}/addToCart";
    final userId = await SharedPrefService.getString('userId') ?? '';
    print("userIduserId   ${userId}");

    // Validate inputs
    if (userId.isEmpty || itemCode.isEmpty || quantity <= 0) {
      print(userId.isEmpty);
      print(itemCode.isEmpty);
      print(quantity);
      utils.showCustomSnackbar("Invalid input data", false);
      return;
    }
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
        fetchDiamonds();
      } else {
        final error = jsonDecode(response.body)['message'];
        utils.showCustomSnackbar("Error: $error", false);
        print("Aaaa  ${error}");
      }
    } catch (e) {
      utils.showCustomSnackbar("Error: $e", false);
      print("222222222222  ${e}");
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
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },color: AppColors.primaryColour, icon: Icon(Icons.arrow_back_ios_new_sharp),),

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 10),
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
                        '$totleValue',
                        Icons.attach_money_outlined,
                      ),
                    ),
                  ],
                ),
              ),

              // Diamond List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15),
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

                                return totleValue > 1 ? Stack(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Diamond3DViewScreen(diamond: diamond)),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: selectedDiamonds.contains(diamond) ? AppColors.primaryWhite : Colors.white.withOpacity(0.2),
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 5),
                                              Text("──── Range ────", style: TextStyleHelper.mediumWhite,),
                                              const SizedBox(height: 5),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: "${AppString.weight} : ",
                                                                style: TextStyleHelper.mediumWhite.copyWith(fontWeight: FontWeight.bold,),),
                                                              TextSpan(
                                                                text: "${diamond.weightCarat}",
                                                                style: TextStyleHelper.mediumWhite,
                                                              ),
                                                            ],
                                                          ), softWrap: true, overflow: TextOverflow.visible,
                                                        ),
                                                      ),
                                                      const VerticalDivider(color: Colors.white, thickness: 2, width: 20,),
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(text: "${AppString.color} : ", style: TextStyleHelper.mediumWhite.copyWith(fontWeight: FontWeight.bold,),),
                                                              TextSpan(text: "${diamond.color}", style: TextStyleHelper.mediumWhite,),
                                                            ],
                                                          ), softWrap: true, overflow: TextOverflow.visible,
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(text: "${AppString.clarity} : ", style: TextStyleHelper.mediumWhite.copyWith(fontWeight: FontWeight.bold,),),
                                                              TextSpan(text: "${diamond.clarity}", style: TextStyleHelper.mediumWhite,),
                                                            ],
                                                          ), softWrap: true, overflow: TextOverflow.visible,
                                                        ),
                                                      ),
                                                      const VerticalDivider(color: Colors.white, thickness: 2, width: 20,),
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(text: AppString.certified, style: TextStyleHelper.mediumWhite.copyWith(fontWeight: FontWeight.bold,),),
                                                              TextSpan(text: "${diamond.certification}", style: TextStyleHelper.mediumWhite,),
                                                            ],
                                                          ), softWrap: true, overflow: TextOverflow.visible,
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(text: "size : ", style: TextStyleHelper.mediumWhite.copyWith(fontWeight: FontWeight.bold,),),
                                                              TextSpan(text: "${diamond.size}", style: TextStyleHelper.mediumWhite,),
                                                            ],
                                                          ), softWrap: true, overflow: TextOverflow.visible,
                                                        ),
                                                      ),
                                                      const VerticalDivider(color: Colors.white, thickness: 2, width: 20,),
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(text: "Supplier : ", style: TextStyleHelper.mediumWhite.copyWith(fontWeight: FontWeight.bold,),),
                                                              TextSpan(text: "${diamond.supplier}", style: TextStyleHelper.mediumWhite,),
                                                            ],
                                                          ), softWrap: true, overflow: TextOverflow.visible,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text("──── Shapes ────", style: TextStyleHelper.mediumWhite,),
                                              if (shapeCount! > 0)
                                                shapeCount == 1
                                                    ? Padding(padding: const EdgeInsets.all(8.0),
                                                        child: Align(alignment: Alignment.centerLeft,
                                                          child: SizedBox(width: 80,
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Image.asset(shapeImages[validShapes![0]]!, width: 40, height: 40,
                                                                  color: Colors.white,
                                                                ),
                                                                const SizedBox(height: 5),
                                                                Text(
                                                                  validShapes[0],
                                                                  textAlign: TextAlign.center,
                                                                  style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500, color: Colors.white,),
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
                                                                  child: SizedBox(width: 80,
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
                                                                        Text(validShapes[index], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white,),
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
                                                                        shapeImages[validShapes![index]]!, width: 40,
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
                                    Positioned(
                                        top: 5,
                                        right: 9,
                                        child: IconButton(onPressed: (){
                                          showAddToCartBottomSheet(
                                            context: context,
                                            diamond: diamond, // pass just the tapped one
                                            addToCartFn: (userId, itemCode, quantity) {
                                              addToCart(context, itemCode, quantity);
                                            },
                                          );
                                        },icon: Icon(Icons.more),color: AppColors.primaryWhite,)),
                                  ],
                                ): SizedBox.shrink();
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
  required Diamond diamond,
  required Function(String userId, String itemCode, int quantity) addToCartFn,
}) {
  final TextEditingController quantityController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.diamond_rounded, size: 28, color: Colors.black87),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Add Diamond to Cart",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Item Code: ${diamond.itemCode ?? 'Unknown'}",
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text("Available Qty: ${diamond.totalDiamonds ?? 'N/A'}",
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Quantity",
                hintText: "e.g. 5",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Quantity is required';
                }
                final number = int.tryParse(value);
                if (number == null || number <= 0) {
                  return 'Enter a valid quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final userId = await SharedPrefService.getString('userId') ?? '';
                  int quantity = int.tryParse(quantityController.text) ?? 0;
                  if (quantity <= 0) {
                    utils.showCustomSnackbar("Enter a quantity", false);
                    return;
                  }
                  if ((diamond.totalDiamonds ?? 0) <= 0) {
                    utils.showCustomSnackbar("This diamond is not available.", false);
                    return;
                  }
                  Navigator.pop(context);
                  addToCartFn(userId, diamond.itemCode ?? "", quantity);
                },
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColour,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


