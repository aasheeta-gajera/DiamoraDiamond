
import 'dart:convert';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Diamond> diamonds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiamonds();
  }

  Future<void> fetchDiamonds() async {
    final String apiUrl = "${ApiService.baseUrl}/getAllPurchasedDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          diamonds =
              (data["diamonds"] as List)
                  .map((json) => Diamond.fromJson(json))
                  .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryBlack,
        title: Text("PURCHASE",style: TextStyleHelper.mediumWhite,),
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new_sharp,color: AppColors.primaryWhite,)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),

          // Dark Overlay for readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
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
                            "NO DATA FOUND",
                            style: TextStyleHelper.mediumBlack,
                          ),
                        )
                        : ListView.builder(
                          itemCount: diamonds.length,
                          itemBuilder: (context, index) {
                            final diamond = diamonds[index];
                            return Card(
                              color: AppColors.transparent,
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: ListTile(
                                title: Text(
                                  "${diamond.itemCode} - ${diamond.shape}",
                                ),
                                subtitle: Text(
                                  "Supplier: ${diamond.supplier}\n"
                                  "Size: ${diamond.size} ct\n"
                                  "Weight: ${diamond.weightCarat} carat\n"
                                  "Color: ${diamond.color}, Clarity: ${diamond.clarity}\n"
                                  "Cut: ${diamond.cut}, Polish: ${diamond.polish}\n"
                                  "Storage: ${diamond.storageLocation}",
                                  style: TextStyleHelper.mediumBlack,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      diamond.status.toString(),
                                      style: TextStyle(
                                        color:
                                            diamond.status == "Sold"
                                                ? Colors.red
                                                : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("💎 x${diamond.totalDiamonds}"),
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
    );
  }
}
