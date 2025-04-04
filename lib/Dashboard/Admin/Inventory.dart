import 'dart:convert';
import 'dart:io';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStrings.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';


class Inventory extends StatefulWidget {
  final List<Diamond>? diamonds;

  const Inventory({super.key, this.diamonds});

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Diamond> diamonds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.diamonds != null) {
      // If diamonds are passed as a parameter, use them directly
      setState(() {
        diamonds = widget.diamonds!;
        isLoading = false;
      });
    } else {
      // Otherwise fetch diamonds from the API
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
          diamonds =
              (data["diamonds"] as List)
                  .map((json) => Diamond.fromJson(json))
                  .toList();
          isLoading = false;
          print(
            "Total Purchase Price: ${data['totalPurchasePrice']}",
          ); // ✅ Debugging
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('${e}', false);
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

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColour,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text(AppString.diamondInventory, style: TextStyleHelper.mediumWhite),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: AppColors.primaryColour,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
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
                    List<String>? selectedShapes =
                    diamond.shape
                        ?.split(",")
                        .map((s) => s.trim())
                        .toList();
                    List<String>? validShapes =
                    selectedShapes
                        ?.where(
                          (shape) => shapeImages.containsKey(shape),
                    )
                        .toList();
                    int? shapeCount =
                        validShapes?.length; // Count valid shapes

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8,
                      ),
                      child: Card(
                        color: AppColors.secondaryColour,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Text(
                              "──── Range ────",
                              style: TextStyleHelper.mediumWhite,
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .start, // Align properly
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppString.weight,
                                            style: TextStyleHelper
                                                .mediumWhite
                                                .copyWith(
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            "${diamond.weightCarat}",
                                            style:
                                            TextStyleHelper
                                                .mediumWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      color: Colors.white,
                                      thickness: 2,
                                      width: 20,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppString.color,
                                            style: TextStyleHelper
                                                .mediumWhite
                                                .copyWith(
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${diamond.color}",
                                            style:
                                            TextStyleHelper
                                                .mediumWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .start, // Align properly
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppString.clarity,
                                            style: TextStyleHelper
                                                .mediumWhite
                                                .copyWith(
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${diamond.clarity}",
                                            style:
                                            TextStyleHelper
                                                .mediumWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      color: Colors.white,
                                      thickness: 2,
                                      width: 20,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: AppString.certified,
                                            style: TextStyleHelper
                                                .mediumWhite
                                                .copyWith(
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            "${diamond.certification}",
                                            style:
                                            TextStyleHelper
                                                .mediumWhite,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "──── Shapes ────",
                              style: TextStyleHelper.mediumWhite,
                            ),
                            shapeCount! > 0
                                ? shapeCount == 1
                                ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: 80, // Fixed width for a single shape
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        shapeImages[validShapes![0]]!,
                                        width: 40,
                                        height: 40,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        validShapes[0],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
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
                                : shapeCount <= 3 // Use Row for 2-3 shapes
                                ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(shapeCount, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0), // Adjust spacing
                                    child: SizedBox(
                                      width: 80, // Fixed width for consistency
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            shapeImages[validShapes![index]]!,
                                            width: 40,
                                            height: 40,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            validShapes[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
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
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: shapeCount > 4 ? 4 : shapeCount, // Grid for 4+
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1,
                                ),
                                itemCount: shapeCount,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: 80, // Fixed width
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          shapeImages[validShapes![index]]!,
                                          width: 40,
                                          height: 40,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          validShapes[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                : Text(
                              AppString.noshapesavailable,
                              style: TextStyleHelper.mediumWhite,
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final capturedImage = await screenshotController.capture();
            if (capturedImage != null) {
              final directory = await getApplicationDocumentsDirectory();
              final path = '${directory.path}/screenshot.png';
              final file = File(path);
              await file.writeAsBytes(capturedImage);

              await Share.shareFiles([path], text: 'Check out this content!');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to capture screenshot.')),
              );
            }
          } catch (e) {
            print('Error capturing screenshot: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error capturing screenshot.')),
            );
          }
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.share,color: Colors.white,),
      ),
    );
  }
}
