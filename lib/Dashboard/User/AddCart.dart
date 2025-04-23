
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
          cartDiamonds = (data['cartItems'] as List)
              .map((item) => CartDiamond.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('$e', false);
    }
  }
  Future<void> removeFromCart(String cartId) async {
    final String url = "${ApiService.baseUrl}/cartDiamonds/$cartId";

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        utils.showCustomSnackbar("Removed from cart!", true);
        fetchCartDiamonds(); // refresh list
      } else {
        utils.showCustomSnackbar("Error: ${jsonDecode(response.body)['message']}", false);
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
        title: Text("Cart", style: TextStyleHelper.mediumPrimaryColour),
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 8,
                                      sigmaY: 8,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(20),
                                        // border: Border.all(
                                        //   color:
                                        //       selectedDiamonds.contains(diamond)
                                        //           ? AppColors.primaryWhite
                                        //           : Colors.white.withOpacity(
                                        //             0.2,
                                        //           ),
                                        //   width: 2,
                                        // ),
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
                                            style: TextStyleHelper.mediumWhite,
                                          ),
                                          const SizedBox(height: 5),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.weight,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.diamondDetails.weightCarat}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  const VerticalDivider(
                                                    color: Colors.white,
                                                    thickness: 2,
                                                    width: 20,
                                                  ),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.color,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.diamondDetails.color}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
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
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.clarity,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.diamondDetails.clarity}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  const VerticalDivider(
                                                    color: Colors.white,
                                                    thickness: 2,
                                                    width: 20,
                                                  ),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: AppString.certified,
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.diamondDetails.certification}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
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
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "size: ",
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.diamondDetails.size}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ),
                                                  const VerticalDivider(
                                                    color: Colors.white,
                                                    thickness: 2,
                                                    width: 20,
                                                  ),
                                                  Flexible(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "supplier: ",
                                                            style: TextStyleHelper.mediumWhite.copyWith(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${diamond.diamondDetails.supplier}",
                                                            style: TextStyleHelper.mediumWhite,
                                                          ),
                                                        ],
                                                      ),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
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
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: SizedBox(
                                                      width: 80,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Image.asset(
                                                            shapeImages[validShapes![0]]!,
                                                            width: 40,
                                                            height: 40,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            validShapes[0],
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            style:
                                                                const TextStyle(
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
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: List.generate(shapeCount, (
                                                      index,
                                                    ) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 4.0,
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
                                                      );
                                                    }),
                                                  ),
                                                )
                                                : Padding(
                                                  padding: const EdgeInsets.all(
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
                                                          crossAxisSpacing: 4,
                                                          mainAxisSpacing: 8,
                                                          childAspectRatio: 1,
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            Image.asset(
                                                              shapeImages[validShapes![index]]!,
                                                              width: 40,
                                                              height: 40,
                                                              color:
                                                                  Colors.white,
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
                                                      );
                                                    },
                                                  ),
                                                )
                                          else
                                            Text(
                                              AppString.noshapesavailable,
                                              style:
                                                  TextStyleHelper.mediumWhite,
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
