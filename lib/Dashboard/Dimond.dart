
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/diamond_model.dart';

class PurchasedDiamondsScreen extends StatefulWidget {
  const PurchasedDiamondsScreen({Key? key}) : super(key: key);

  @override
  _PurchasedDiamondsScreenState createState() => _PurchasedDiamondsScreenState();
}

class _PurchasedDiamondsScreenState extends State<PurchasedDiamondsScreen> {

  @override
  void initState() {
    fetchPurchasedDiamonds();
    super.initState();
  }
  Future<List<Diamond>> fetchPurchasedDiamonds() async {
    final response = await http.get(Uri.parse("http://localhost:4000/api/user/getAllPurchasedDiamonds"));

    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      List<dynamic> diamondsJson = data["diamonds"];
      print(diamondsJson);
      return diamondsJson.map((json) => Diamond.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load diamonds");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Purchased Diamonds")),
      body: FutureBuilder<List<Diamond>>(
        future: fetchPurchasedDiamonds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No diamonds found"));
          }

          final diamonds = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: diamonds.length,
            itemBuilder: (context, index) {
              return DiamondCard(diamond: diamonds[index]);
            },
          );
        },
      ),
    );
  }
}

/// **Diamond Card UI**
class DiamondCard extends StatelessWidget {
  final Diamond diamond;
  const DiamondCard({Key? key, required this.diamond}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                diamond.imageURL,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diamond.itemCode,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Supplier: ${diamond.supplier}", style: const TextStyle(color: Colors.grey)),
                  Text("Shape: ${diamond.shape} | Color: ${diamond.color}", style: const TextStyle(fontSize: 14)),
                  Text("Clarity: ${diamond.clarity} | Cut: ${diamond.cut}", style: const TextStyle(fontSize: 14)),
                  Text(
                    "\$${diamond.purchasePrice.toStringAsFixed(2)} - ${diamond.weightCarat} Ct",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: diamond.status == "Sold" ? Colors.red[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                diamond.status,
                style: TextStyle(color: diamond.status == "Sold" ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
