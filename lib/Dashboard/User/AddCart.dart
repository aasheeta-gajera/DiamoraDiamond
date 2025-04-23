import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Library/ApiService.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart'; // Import utils for showing custom snackbars if needed

class CardDiamonds extends StatefulWidget {
  @override
  _CardDiamondsState createState() => _CardDiamondsState();
}

class _CardDiamondsState extends State<CardDiamonds> {
  List<Diamond> diamonds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiamonds();  // Call the API method to fetch diamonds
  }

  Future<void> fetchDiamonds() async {
    final String apiUrl = "${ApiService.baseUrl}/cartDiamonds";  // Replace with your actual API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));  // Making the API GET request
      ApiService().printLargeResponse(response.body);  // Assuming you have a utility function for debugging

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the response body
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          diamonds = (data["cartItems"] as List).map((json) => Diamond.fromJson(json)).toList();
          isLoading = false;  // Set loading flag to false after data is fetched
        });
      } else {
        // If the response is not successful, show an error snackbar
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
      }
    } catch (e) {
      setState(() => isLoading = false);  // Set loading flag to false if an error occurs
      utils.showCustomSnackbar('${e}', false);  // Display the error message in a custom snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diamonds'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Show loading indicator while fetching
          : ListView.builder(
            itemCount: diamonds.length,
             itemBuilder: (context, index) {
          final diamond = diamonds[index];
          return ListTile(
            title: Text(diamond.itemCode ?? 'No item code'),
            subtitle: Text('Shape: ${diamond.shape}'),
            trailing: Image.network(diamond.imageURL ?? 'https://via.placeholder.com/150'),
            onTap: () {
              // You can add any onTap action here, e.g., navigate to a detail screen
            },
          );
        },
      ),
    );
  }
}
