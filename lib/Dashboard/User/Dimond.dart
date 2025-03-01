import 'dart:convert';
import 'package:daimo/Library/AppColour.dart';
import 'package:flutter/material.dart';
import '../../Library/AppStyle.dart';
import '../../Library/ApiService.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';
import 'package:http/http.dart' as http;

class DiamondListScreen extends StatefulWidget {
  @override
  _DiamondListScreenState createState() => _DiamondListScreenState();
}

class _DiamondListScreenState extends State<DiamondListScreen> {
  late Future<List<Diamond>> futureDiamonds;
  bool isLoading = false;

  Future<List<Diamond>> fetchDiamonds() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/getAllPurchasedDiamonds'));
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> diamondList = data['diamonds'];
        return diamondList.map((json) => Diamond.fromJson(json)).toList();
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
        return []; // Return an empty list if the API fails
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('$e', false);
      print(e);
      return []; // Return an empty list if there's an error
    }
  }

  @override
  void initState() {
    super.initState();
    futureDiamonds = fetchDiamonds(); // Correct way to assign a future in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 50),
        child: Column(
          children: [
            Text(
              "Diamonds",
              style: TextStyleHelper.bigBlack.copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<Diamond>>(
                future: futureDiamonds,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No diamonds found"));
                  }

                  List<Diamond> diamonds = snapshot.data!;

                  return ListView.builder(
                    itemCount: diamonds.length,
                    itemBuilder: (context, index) {
                      Diamond diamond = diamonds[index];
                      return Card(
                        color: AppColors.primaryBlack,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Shape: ${diamond.shape}", style: TextStyleHelper.smallWhite),
                              SizedBox(height: 5),
                              Text("Carat: ${diamond.weightCarat} Ct", style: TextStyleHelper.smallWhite),
                              Text("Color: ${diamond.color}", style: TextStyleHelper.smallWhite),
                              Text("Clarity: ${diamond.clarity}", style: TextStyleHelper.smallWhite),
                              Text("Certification: ${diamond.certification}", style: TextStyleHelper.smallWhite),
                              SizedBox(height: 10),
                              Text("Price: \$${diamond.purchasePrice}", style: TextStyleHelper.smallWhite),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
