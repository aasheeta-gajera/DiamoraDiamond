import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import '../../Library/SharedPrefService.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/InquiryModel.dart';

class InquiryScreen extends StatefulWidget {
  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final diamondIdController = TextEditingController();
  final diamondShapeController = TextEditingController();
  final caratWeightController = TextEditingController();
  final colorController = TextEditingController();
  final clarityController = TextEditingController();
  final certificationController = TextEditingController();

  bool _isLoading = false;

  // To keep track of the inquiries after submission
  List<InquiryModel> inquiries = [];

  Future<void> submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userId = await SharedPrefService.getString('userId') ?? '';

    final newInquiry = InquiryModel(
      userId: userId,
      subject: subjectController.text,
      message: messageController.text,
      diamondId: diamondIdController.text,
      diamondShape: diamondShapeController.text,
      caratWeight: caratWeightController.text,
      color: colorController.text,
      clarity: clarityController.text,
      certification: certificationController.text, id: '',
    );

    final url = Uri.parse('${ApiService.baseUrl}/inquiry');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newInquiry.toJson()),
    );

    setState(() => _isLoading = false);

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      Get.snackbar("Success", "Inquiry submitted successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      _formKey.currentState!.reset();

      // Optionally add the newly created inquiry to the list
      inquiries.add(InquiryModel.fromJson(data));
      setState(() {}); // Refresh UI if necessary
    } else {
      Get.snackbar("Error", data['error'] ?? 'Something went wrong',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchInquiries() async {
    final String apiUrl = "${ApiService.baseUrl}/admin/inquiries";

    final url = Uri.parse(apiUrl);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          inquiries = data.map((json) => InquiryModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      utils.showCustomSnackbar('${e}', false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInquiries(); // Fetch on screen load
  }

  void _showAllInquiriesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Inquiries',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: inquiries.isEmpty
                      ? Center(child: Text('No inquiries submitted yet.'))
                      : ListView.builder(
                    controller: controller,
                    itemCount: inquiries.length,
                    itemBuilder: (context, index) {
                      final inquiry = inquiries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text('Subject: ${inquiry.subject}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Message: ${inquiry.message}'),
                              Text('Status: ${inquiry.status}'),
                              Text('Response: ${inquiry.response ?? 'No response yet'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.inquiry,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColour,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: AppColors.primaryColour),
            onPressed: () {
              _showAllInquiriesBottomSheet();
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                utils.buildTextField(
                  "Subject",
                  subjectController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Message",
                  messageController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Diamond ID",
                  diamondIdController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Diamond Shape",
                  diamondShapeController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Carat Weight",
                  caratWeightController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Color",
                  colorController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Clarity",
                  clarityController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Certification",
                  certificationController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                  color: AppColors.primaryWhite,
                )
                    : utils.PrimaryButton(
                  text: "Submit Inquiry",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitInquiry();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
// import 'dart:convert';
// import 'dart:ui';
// import 'package:daimo/Library/ApiService.dart';
// import 'package:daimo/Library/AppStyle.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../Library/AppColour.dart';
// import '../../Library/AppStrings.dart';
// import '../../Library/SharedPrefService.dart';
// import '../../Library/Utils.dart' as utils;
// import '../../Models/CartDiamond.dart';
// import '../../Models/DiamondModel.dart';
//
// class CardDiamonds extends StatefulWidget {
//   final List<Diamond>? diamonds;
//
//   const CardDiamonds({super.key, this.diamonds});
//
//   @override
//   _CardDiamondsState createState() => _CardDiamondsState();
// }
//
// class _CardDiamondsState extends State<CardDiamonds> {
//   @override
//   void initState() {
//     super.initState();
//     fetchCartDiamonds();
//   }
//
//   List<CartDiamond> cartDiamonds = [];
//   bool isLoading = true;
//
//   Future<void> fetchCartDiamonds() async {
//     final String apiUrl = "${ApiService.baseUrl}/cartDiamonds";
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         setState(() {
//           cartDiamonds = (data['cartItems'] as List).map((item) => CartDiamond.fromJson(item)).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         // utils.showCustomSnackbar("Failed to load cart items", false);
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       utils.showCustomSnackbar("Error: $e", false);
//     }
//   }
//
//   final Map<String, String> shapeImages = {
//     "Round": "Assets/Images/Round.png",
//     "Princess": "Assets/Images/Round.png",// Fix here
//     "Emerald": "Assets/Images/emerald.png",
//     "Asscher": "Assets/Images/Round.png",
//     "Marquise": "Assets/Images/Marquise.png",
//     "Oval": "Assets/Images/Oval.png",
//     "Pear": "Assets/Images/Pear.png",
//     "Heart": "Assets/Images/Heart.png",
//     "Cushion": "Assets/Images/Cushion.png",
//     "Radiant": "Assets/Images/Round.png",// Fix here
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryWhite,
//       appBar: AppBar(
//         backgroundColor: AppColors.secondaryColour,
//         elevation: 1,
//         title: Text("Cart", style: TextStyleHelper.mediumPrimaryColour),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           color: AppColors.primaryColour,
//           icon: Icon(Icons.arrow_back_ios_new_sharp),
//         ),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [AppColors.primaryColour, AppColors.secondaryColour],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: Container(
//                   margin: const EdgeInsets.all(15),
//                   child:
//                   isLoading
//                       ? const Center(
//                     child: CircularProgressIndicator(
//                       color: AppColors.primaryWhite,
//                     ),
//                   )
//                       : cartDiamonds.isEmpty
//                       ? Center(
//                     child: Text(AppString.noDataFound, style: TextStyleHelper.mediumWhite,),)
//                       : ListView.builder(
//                     itemCount: cartDiamonds.length,
//                     itemBuilder: (context, index) {
//                       final diamond = cartDiamonds[index];
//                       List<String>? selectedShapes = diamond.diamondDetails.shape?.split(",").map((s) => s.trim()).toList();
//                       List<String>? validShapes = selectedShapes?.where((shape) => shapeImages.containsKey(shape),).toList();
//                       int? shapeCount = validShapes?.length;
//                       return GestureDetector(
//                         onTap: () {},
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     const Icon(Icons.diamond, color: Colors.white, size: 24),
//                                     const SizedBox(width: 8),
//                                     Text("Diamond Item", style: TextStyleHelper.mediumWhite.copyWith(fontSize: 18),),
//                                     const Spacer(),
//                                     GestureDetector(
//                                         onTap: () async {
//                                           bool success = await removeDiamondFromCart(context, diamond.id);
//                                           if (success) {
//                                             fetchCartDiamonds();
//                                             utils.showCustomSnackbar("Diamond removed from cart", true,);
//                                           } else {
//                                             utils.showCustomSnackbar("Failed to remove diamond", false);
//                                           }
//                                         },child: Icon(Icons.delete_outline, color: Colors.white.withOpacity(0.8))),
//                                   ],
//                                 ),
//                                 const Divider(color: Colors.white54, height: 20),
//
//                                 // Details: Weight, Color, Clarity, Certification
//                                 Wrap(
//                                   spacing: 12,
//                                   runSpacing: 8,
//                                   children: [
//                                     _detailChip("Weight", "${diamond.diamondDetails.weightCarat ?? 'NA'}"),
//                                     _detailChip("Clarity", "${diamond.diamondDetails.clarity ?? 'NA'}"),
//                                     _detailChip("Certified", "${diamond.diamondDetails.certification ?? 'NA'}"),
//                                     _detailChip("Size", "${diamond.diamondDetails.size ?? 'NA'}"),
//                                     _detailChip("Cut", "${diamond.diamondDetails.cut ?? 'NA'}"),
//                                     _detailChip("Shape", "${diamond.diamondDetails.shape ?? 'NA'}"),
//                                     _detailChip("Price", "\$${diamond.diamondDetails.totalPurchasePrice ?? 'NA'}"),
//                                     _detailChip("Color", "\$${diamond.diamondDetails.color ?? 'NA'}"),
//                                   ],
//                                 ),
//
//                                 const SizedBox(height: 16),
//                                 Text("Shapes", style: TextStyleHelper.mediumWhite.copyWith(fontSize: 16)),
//                                 const SizedBox(height: 8),
//
//                                 // Shapes Section
//                                 shapeCount! > 0 ? Wrap(
//                                   spacing: 12,
//                                   runSpacing: 12,
//                                   children: List.generate(
//                                     shapeCount, (index) => Column(mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Image.asset(shapeImages[validShapes![index]]!, width: 40, height: 40, color: Colors.white,),
//                                       const SizedBox(height: 4),
//                                       Text(validShapes[index], style: const TextStyle(fontSize: 12,color: Colors.white, fontWeight: FontWeight.w500,),),
//                                     ],
//                                   ),
//                                   ),
//                                 ) : Text(AppString.noshapesavailable, style: TextStyleHelper.mediumWhite,),
//
//                                 const SizedBox(height: 16),
//                                 Row(
//                                   children: [
//                                     Text("\$${diamond.diamondDetails.totalPurchasePrice ?? 'NA'}", style: TextStyleHelper.mediumWhite.copyWith(fontSize: 18, fontWeight: FontWeight.bold,),),
//                                     const Spacer(),
//                                     ElevatedButton.icon(
//                                       onPressed: () {
//                                         showModalBottomSheet(
//                                           context: context, isScrollControlled: true,
//                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20),),),
//                                           builder: (context) => SellConfirmationSheet(cartDiamond: diamond,),
//                                         );
//                                       },
//                                       icon: const Icon(Icons.shopping_cart_outlined),
//                                       label: const Text("Purchase"),
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         foregroundColor: Colors.black,
//                                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget _detailChip(String label, String value) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(0.1),
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(color: Colors.white54),
//     ),
//     child: RichText(
//       text: TextSpan(
//         style: const TextStyle(color: Colors.white, fontSize: 13),
//         children: [TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: value),
//         ],
//       ),
//     ),
//   );
// }
// Future<void> sellDiamond(CartDiamond diamond) async {
//   final userId = await SharedPrefService.getString('userId') ?? '';
//   print("userIduserId   ${userId}");
//
//   final String paymentMethod = "Credit Card";  // This can be dynamic based on user input
//   final String transactionId = "TX123456789"; // This can be dynamically generated or retrieved from a payment API
//
//   final String paymentStatus = diamond.diamondDetails.paymentStatus ?? 'Pending'; // Default to 'Pending' if not available
//
//   final sellData = {
//     "userId": userId,
//     "itemCode": diamond.itemCode,
//     "customerName": diamond.diamondDetails.supplier,
//     "quantity": diamond.quantity,
//     "totlePrice": diamond.diamondDetails.totalPurchasePrice,
//     "paymentStatus": paymentStatus, // Now using the payment status extracted from the diamond object
//     "paymentMethod": paymentMethod, // New field for payment method
//     "transactionId": transactionId, // New field for transaction ID
//   };
//   final url = Uri.parse("${ApiService.baseUrl}/sellDiamond");
//   try {
//     final response = await http.post(url, headers: {"Content-Type": "application/json"},
//       body: json.encode(sellData),
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final res = json.decode(response.body);
//       utils.showCustomSnackbar(res['message'], true);
//     } else {
//       utils.showCustomSnackbar("Error selling ${diamond.itemCode}: ${response.body}", false);
//       return;
//     }
//   } catch (e) {
//     print('Error in sellDiamond: $e');
//     utils.showCustomSnackbar("$e", false);
//     return;
//   }
// }
//
// Future<bool> removeDiamondFromCart(BuildContext context, String id) async {
//   final bool shouldRemove = await showRemoveConfirmationDialog(context);
//   if (!shouldRemove) return false;
//
//   final url = Uri.parse("${ApiService.baseUrl}/cartDiamonds/$id");
//   print("iddd ${id}");
//   try {
//     final response = await http.delete(url);
//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       utils.showCustomSnackbar("Failed to remove diamond", false);
//       return false;
//     }
//   } catch (e) {
//     print('Error deleting from cart: $e');
//     utils.showCustomSnackbar("Error: ${e.toString()}", false);
//     return false;
//   }
// }
//
// Future<bool> showRemoveConfirmationDialog(BuildContext context) async {
//   return await showDialog<bool>(
//     context: context,
//     builder:
//         (context) => AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       backgroundColor: Colors.white,
//       titlePadding: const EdgeInsets.only(top: 20),
//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 10,
//       ),
//       actionsPadding: const EdgeInsets.only(bottom: 15, right: 10),
//       title: Column(
//         children: [
//           Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 40,),
//           const SizedBox(height: 10),
//           const Text("Remove from Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,
//           ),
//           ),
//         ],
//       ),
//       content: const Text("Are you sure you want to remove this diamond from the cart?", style: TextStyle(fontSize: 16, color: Colors.black87), textAlign: TextAlign.center,),
//       actionsAlignment: MainAxisAlignment.center,
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10,),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade200,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Text("No", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         TextButton(
//           onPressed: () => Navigator.pop(context, true),
//           child: Container(padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10,), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12),), child: const Text("Yes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
//           ),
//           ),
//         ),
//       ],
//     ),
//   ) ??
//       false;
// }
//
// class SellConfirmationSheet extends StatefulWidget {
//   final CartDiamond cartDiamond;
//
//   const SellConfirmationSheet({Key? key, required this.cartDiamond}) : super(key: key);
//
//   @override
//   _SellConfirmationSheetState createState() => _SellConfirmationSheetState();
// }
//
// class _SellConfirmationSheetState extends State<SellConfirmationSheet> {
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             end: Alignment.bottomCenter,
//             colors: [AppColors.secondaryColour, AppColors.secondaryColour],
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Cart Icon - Centered and with proper alignment
//             Text(
//               "🛒 Confirm Diamond Purchase",
//               style: TextStyle(fontSize: 20),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Item Details Container with card-like design
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Item Code Section with emoji
//                   Text(
//                     "💎 Item Code: ${widget.cartDiamond.itemCode}",
//                     style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Total Price Section with emoji
//                   Text(
//                     "💰 Total Price: \$${widget.cartDiamond.diamondDetails.totalPurchasePrice?.toStringAsFixed(2)}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 10),
//
//                   Text(
//                     "🔢 Quantity: ${widget.cartDiamond.diamondDetails.totalDiamonds}",
//                     style: const TextStyle(fontSize: 16),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // Quantity Adjustment Row with icons for increment/decrement
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: widget.cartDiamond.diamondDetails.totalDiamonds! > 1
//                             ? () {
//                           // Decrease quantity logic
//                         }
//                             : null, // Disable "remove" if quantity is 1
//                         icon: const Icon(Icons.remove_circle_outline),
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                       Text(
//                         "${widget.cartDiamond.diamondDetails.totalDiamonds}",
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       IconButton(
//                         onPressed: widget.cartDiamond.diamondDetails.totalDiamonds! < (widget.cartDiamond.diamondDetails.totalDiamonds ?? 0)
//                             ? () {
//                           // Increase quantity logic
//                         }
//                             : null, // Disable "add" if quantity exceeds stock
//                         icon: const Icon(Icons.add_circle_outline),
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // Confirm Purchase Button - Full Width with centered icon and text
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () async {
//                   setState(() => isLoading = true);
//                   await sellDiamond(widget.cartDiamond);
//                   setState(() => isLoading = false);
//                   Navigator.pop(context);
//                 },
//                 icon: const Icon(Icons.check_circle_outline),
//                 label: const Text("Confirm Purchase"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryColour,
//                   foregroundColor: AppColors.primaryWhite,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         )
//
//
//     );
//   }
// }
//
//
//
//
