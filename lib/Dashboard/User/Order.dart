
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import '../../Models/DiamondModel.dart';
import '../../Library/Utils.dart' as utils;

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<Diamond> diamonds = [];
  bool isLoading = true;

  Future<void> shareExcelFile(List<Diamond> diamonds) async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    // Add header row
    sheet.importList([
      'Item',
      'Weight',
      'Color',
      'Clarity',
      'Size',
      'Certification',
      'Supplier',
      'Price',
    ], 1, 1, false);

    int rowIndex = 2;

    for (var diamond in diamonds) {
      sheet.importList([
        diamond.itemCode ?? 'N/A',
        diamond.weightCarat?.toString() ?? 'N/A',
        diamond.color ?? 'N/A',
        diamond.clarity ?? 'N/A',
        diamond.size ?? 'N/A',
        diamond.certification ?? 'N/A',
        diamond.supplier ?? 'N/A',
        diamond.totalPurchasePrice?.toString() ?? 'N/A',
      ], rowIndex, 1, false);

      rowIndex++;
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/Diamonds.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles([XFile(filePath)], text: 'Check out the diamond details!');
  }


  Future<void> fetchDiamonds() async {
    final String apiUrl = "${ApiService.baseUrl}/Customer/getSoldDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> encryptedResponse = json.decode(response.body);

        if (encryptedResponse.containsKey("data")) {
          final decryptedString = ApiService.decryptData(encryptedResponse["data"]);
          final Map<String, dynamic> data = json.decode(decryptedString);

          setState(() {
            diamonds = (data["soldDiamonds"] as List)
                .map((json) => Diamond.fromJson(json))
                .toList();
            isLoading = false;
          });
        } else {
          utils.showCustomSnackbar("Invalid response format", false);
          setState(() => isLoading = false);
        }
      } else {
        utils.showCustomSnackbar("Failed to load data", false);
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar("Error: $e", false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDiamonds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 0.5,
        title: Text("Order", style: TextStyleHelper.mediumPrimaryColour),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          color: AppColors.primaryColour,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              shareExcelFile(diamonds); // Share Excel file when pressed
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColour, AppColors.secondaryColour],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
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
                final status = diamond.paymentStatus ?? 'N/A';

                Color statusColor = status == 'Paid'
                    ? AppColors.greenAccent
                    : status == 'Pending'
                    ? AppColors.yellow
                    : AppColors.redAccent;

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.white.withOpacity(0.85),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Item: ${diamond.itemCode ?? 'N/A'}",
                              style: TextStyleHelper.mediumBlack.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Diamond Details
                        Wrap(
                          runSpacing: 8,
                          children: [
                            _infoTile(Icons.scale, "Weight", "${diamond.weightCarat}"),
                            _infoTile(Icons.color_lens, "Color", "${diamond.color}"),
                            _infoTile(Icons.brightness_low, "Clarity", "${diamond.clarity}"),
                            _infoTile(Icons.verified_user, "Certification", "${diamond.certification}"),
                            _infoTile(Icons.aspect_ratio, "Size", "${diamond.size}"),
                            _infoTile(Icons.business, "Supplier", "${diamond.supplier}"),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Price Footer
                        // Price & Download Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${diamond.totalPurchasePrice}",
                              style: TextStyleHelper.mediumPrimaryColour.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (status == 'Paid')
                              InkWell(
                                onTap: () {
                                  utils.showCustomSnackbar("Downloading bill for ${diamond.itemCode}", true);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColour.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: AppColors.primaryColour,
                                    size: 24,
                                  ),
                                ),
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
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryColour),
        SizedBox(width: 6),
        Text(
          "$label: $value",
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        SizedBox(width: 12),
      ],
    );
  }
}





//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../Library/ApiService.dart';
// import '../../Library/AppColour.dart';
// import '../../Library/AppStrings.dart';
// import '../../Library/AppStyle.dart';
// import '../../Models/DiamondModel.dart';
// import '../../Library/Utils.dart' as utils;
//
// class Order extends StatefulWidget {
//   const Order({super.key});
//
//   @override
//   _OrderState createState() => _OrderState();
// }
//
// class _OrderState extends State<Order> {
//   List<Diamond> diamonds = [];
//   bool isLoading = true;
//
//   Future<void> fetchDiamonds() async {
//     final String apiUrl = "${ApiService.baseUrl}/getAllCartItems";
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         setState(() {
//           diamonds = (data["soldDiamonds"] as List)
//               .map((json) => Diamond.fromJson(json))
//               .toList();
//           isLoading = false;
//         });
//       } else {
//         utils.showCustomSnackbar("Failed to load data", false);
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       utils.showCustomSnackbar("Error: $e", false);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDiamonds();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryWhite,
//       appBar: AppBar(
//         backgroundColor: AppColors.secondaryColour,
//         elevation: 0.5,
//         title: Text("Receive Order", style: TextStyleHelper.mediumPrimaryColour),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new_sharp),
//           color: AppColors.primaryColour,
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [AppColors.primaryColour, AppColors.secondaryColour],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : diamonds.isEmpty
//                 ? Center(
//               child: Text(
//                 AppString.noDataFound,
//                 style: TextStyleHelper.mediumWhite,
//               ),
//             )
//                 : ListView.builder(
//               itemCount: diamonds.length,
//               itemBuilder: (context, index) {
//                 final diamond = diamonds[index];
//                 final status = diamond.paymentStatus ?? 'N/A';
//
//                 Color statusColor = status == 'Paid'
//                     ? AppColors.greenAccent
//                     : status == 'Pending'
//                     ? AppColors.yellow
//                     : AppColors.redAccent;
//
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.08),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color:  Colors.white.withOpacity(0.2),
//                       width: 2,
//                     ),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Header
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Item: ${diamond.itemCode ?? 'N/A'}",
//                               style: TextStyleHelper.mediumWhite.copyWith(fontWeight: FontWeight.bold),
//                             ),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: statusColor.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 status,
//                                 style: TextStyle(
//                                   color: statusColor,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Diamond Details
//                         Wrap(
//                           runSpacing: 8,
//                           children: [
//                             _infoTile(Icons.scale, "Weight", "${diamond.weightCarat}"),
//                             _infoTile(Icons.color_lens, "Color", "${diamond.color}"),
//                             _infoTile(Icons.brightness_low, "Clarity", "${diamond.clarity}"),
//                             _infoTile(Icons.verified_user, "Certification", "${diamond.certification}"),
//                             _infoTile(Icons.aspect_ratio, "Size", "${diamond.size}"),
//                             _infoTile(Icons.business, "Supplier", "${diamond.supplier}"),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//
//                         // Price Footer
//                         // Price & Download Footer
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "\$${diamond.totalPurchasePrice}",
//                               style: TextStyleHelper.mediumPrimaryColour.copyWith(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             if (status == 'Paid')
//                               InkWell(
//                                 onTap: () {
//                                   utils.showCustomSnackbar("Downloading bill for ${diamond.itemCode}", true);
//                                   // TODO: Implement download logic here
//                                 },
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Container(
//                                   padding: EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.primaryColour.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Icon(
//                                     Icons.download_rounded,
//                                     color: AppColors.primaryColour,
//                                     size: 24,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoTile(IconData icon, String label, String value) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 18, color: AppColors.primaryWhite),
//         SizedBox(width: 6),
//         Text(
//           "$label: $value",
//           style: TextStyle(fontSize: 14, color: AppColors.primaryWhite),
//         ),
//         SizedBox(width: 12),
//       ],
//     );
//   }
// }
