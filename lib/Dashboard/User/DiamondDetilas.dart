
import 'package:flutter/material.dart';
import '../../Library/AppStyle.dart';
import '../../Models/DiamondModel.dart';
import '../../Library/AppColour.dart';

class DiamondDetail extends StatelessWidget {
  final Diamond diamond;

  const DiamondDetail({super.key, required this.diamond});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text(AppString.purchase,style: TextStyleHelper.mediumWhite,),
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new_sharp,color: AppColors.primaryColour,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${diamond.itemCode} - ${diamond.shape}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Supplier: ${diamond.supplier}"),
            Text("Size: ${diamond.size} ct"),
            Text("Weight: ${diamond.weightCarat} carat"),
            Text("Color: ${diamond.color}, Clarity: ${diamond.clarity}"),
            Text("Cut: ${diamond.cut}, Polish: ${diamond.polish}"),
            Text("Storage: ${diamond.storageLocation}"),
            SizedBox(height: 20),
            Text(
              "Status: ${diamond.status}",
              style: TextStyle(
                color: diamond.status == "Sold" ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text("💎 Quantity: ${diamond.totalDiamonds}"),
          ],
        ),
      ),
    );
  }
}
