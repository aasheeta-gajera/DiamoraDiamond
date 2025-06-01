
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStrings.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

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
    final String apiUrl = "${ApiService.baseUrl}/Admin/getAllPurchasedDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      ApiService().printLargeResponse(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          diamonds = (data["diamonds"] as List)
              .map((json) {
            final diamond = Diamond.fromJson(json);
            totleValue = (diamond.purchasePrice ?? 0) * (diamond.totalDiamonds ?? 0);

            return diamond;
          })
              .toList();
          isLoading = false;
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
        print(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('${e}', false);
      print("eeeeeeeeeee  ${e}");
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

  Future<void> shareExcelFile(List<Diamond> diamonds) async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    // Add header row
    sheet.importList([
      'Item Code',
      'Weight (Carat)',
      'Color',
      'Clarity',
      'Size',
      'Certification',
      'Supplier',
      'Purchase Price',
      'Total Diamonds',
      'Total Value',
    ], 1, 1, false);

    int rowIndex = 2;

    for (var diamond in diamonds) {
      int purchasePrice = diamond.purchasePrice ?? 0;
      int totalDiamonds = diamond.totalDiamonds ?? 0;
      int totalValue = purchasePrice * totalDiamonds;

      sheet.importList([
        diamond.itemCode ?? 'N/A',
        diamond.weightCarat?.toString() ?? 'N/A',
        diamond.color ?? 'N/A',
        diamond.clarity ?? 'N/A',
        diamond.size ?? 'N/A',
        diamond.certification ?? 'N/A',
        diamond.supplier ?? 'N/A',
        purchasePrice.toString(),
        totalDiamonds.toString(),
        totalValue.toString(),
      ], rowIndex, 1, false);

      rowIndex++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/PurchasedDiamonds.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Purchased Diamond Details - Excel Export',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.inventory,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },color: AppColors.primaryColour, icon: Icon(Icons.arrow_back_ios_new_sharp),),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              shareExcelFile(diamonds);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 15),
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
                  child: Column(
                    children: [

                      Expanded(
                        child:
                            isLoading
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
                                  // padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                              (shape) => shapeImages
                                                  .containsKey(shape),
                                            )
                                            .toList();
                                    int? shapeCount = validShapes?.length;

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
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
                                                                text: "${diamond.weightCarat}",
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
                                                      Expanded(
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
                                                                text: "${diamond.color}",
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
                                                      Expanded(
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
                                                                text: "${diamond.clarity}",
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
                                                      Expanded(
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
                                                                text: "${diamond.certification}",
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
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: "Size: ",
                                                                style: TextStyleHelper.mediumWhite.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: "${diamond.size}",
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
                                                      Expanded(
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: "Supplier: ",
                                                                style: TextStyleHelper.mediumWhite.copyWith(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: "${diamond.supplier}",
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
                                              shapeCount! > 0
                                                  ? shapeCount == 1
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
                                                      padding:
                                                      const EdgeInsets.symmetric(horizontal: 4.0),
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
                                                  gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                    shapeCount > 4 ? 4 : shapeCount,
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
                                                  : Text(
                                                AppString.noshapesavailable,
                                                style: TextStyleHelper.mediumWhite,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                  },
                                ),
                      ),
                    ],
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
