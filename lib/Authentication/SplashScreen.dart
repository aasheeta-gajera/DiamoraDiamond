import 'package:flutter/material.dart';
import 'dart:async';
import '../Dashboard/Dashboard.dart';
import '../Library/DiamondBackground.dart';
import 'AuthChoiceScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DiamondHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // DiamondBackground(),
          Positioned(
            top: 200,
            left: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'Assets/Images/logo.png',
                  width: 150,
                ),
                const SizedBox(height: 20),
                // Text(
                //   'Diamora',
                //   style: TextStyle(
                //     color: Colors.purple[100],
                //     fontSize: 32,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(height: 8),
                Text(
                  'Beyond rare, there is only unique.',
                  style: TextStyle(
                    color: Colors.purple[100]!,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



//
// import 'package:flutter/material.dart';
//
// class DiamondHomePage extends StatelessWidget {
//   const DiamondHomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       /// If you want a custom background with shapes, you can use a Stack or
//       /// a decorated Container as the scaffold's background:
//       body: Stack(
//         children: [
//           // 1) Background shapes or gradients
//           Container(
//             decoration: const BoxDecoration(
//               color: Colors.white, // base color
//             ),
//           ),
//           // TODO: Add Positioned widgets or CustomPainter for colored shapes here
//
//           // 2) Main content (scrollable)
//           SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Top bar with "Buy" (or use an AppBar if you prefer)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Time or menu icon
//                       IconButton(
//                         icon: const Icon(Icons.menu),
//                         onPressed: () {},
//                       ),
//                       const Text(
//                         'BUY',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       // Placeholder for battery/wifi icons or similar
//                       IconButton(
//                         icon: const Icon(Icons.more_vert),
//                         onPressed: () {},
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   /// Row of two "cards" (Diamonds & Fancy Diamonds)
//                   Row(
//                     children: [
//                       // Diamonds Card
//                       Expanded(
//                         child: _DiamondCard(
//                           title: 'Diamonds',
//                           backgroundColor: Colors.blue[100]!,
//                           iconColor: Colors.blue[800]!,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       // Fancy Diamonds Card
//                       Expanded(
//                         child: _DiamondCard(
//                           title: 'Fancy Diamonds',
//                           backgroundColor: Colors.purple[100]!,
//                           iconColor: Colors.purple[800]!,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   /// Large "Sell Diamonds" card
//                   GestureDetector(
//                     onTap: () {
//                       // Handle tap
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.green[50],
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 5,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           // Placeholder icon or image
//                           Icon(
//                             Icons.attach_money,
//                             size: 40,
//                             color: Colors.green[700],
//                           ),
//                           const SizedBox(width: 16),
//                           const Expanded(
//                             child: Text(
//                               'Sell Diamonds',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Add more content here if needed
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Additional content or details...',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//
//       /// Bottom navigation bar
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           // Handle navigation
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.monetization_on),
//             label: 'Buy/Sell',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_basket),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Account',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// A simple reusable card widget for Diamonds / Fancy Diamonds
// class _DiamondCard extends StatelessWidget {
//   final String title;
//   final Color backgroundColor;
//   final Color iconColor;
//
//   const _DiamondCard({
//     Key? key,
//     required this.title,
//     required this.backgroundColor,
//     required this.iconColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Handle tap
//       },
//       child: Container(
//         height: 120,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.08),
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Placeholder icon
//               Icon(
//                 Icons.diamond,
//                 size: 40,
//                 color: iconColor,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: iconColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
