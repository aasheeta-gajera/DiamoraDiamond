import 'package:flutter/material.dart';
import '../Library/DiamondBackground.dart';
import '../Library/common_drawer.dart';
import 'Dimond.dart';

class DiamondHomePage extends StatelessWidget {
  final String? token;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  DiamondHomePage({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: CommonDrawer(), // Drawer
      body: Stack(
        children: [
          // DiamondBackground(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16,top: 40,bottom: 4),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        color: Colors.blue[200],
                        onPressed: () {
                          _scaffoldKey.currentState
                              ?.openDrawer(); // Open drawer when button is pressed
                        },
                        icon: Icon(Icons.menu, color: Colors.black),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                      const Text(
                        'BUY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _DiamondCard(
                            title: "Diamonds",
                            backgroundColor: Colors.blue[100]!,
                            iconColor: Colors.blue[800]!,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PurchasedDiamondsScreen(),
                                ),
                              );
                            },
                            icon: Icons.diamond,
                          ),
                          _DiamondCard(
                            title: "Search",
                            backgroundColor: Colors.purple[100]!,
                            iconColor: Colors.purple[800]!,
                            onTap: () {},
                            icon: Icons.search,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _DiamondCard(
                            title: "My Cart",
                            backgroundColor: Colors.green[100]!,
                            iconColor: Colors.green[800]!,
                            onTap: () {},
                            icon: Icons.add_shopping_cart,
                          ),
                          _DiamondCard(
                            title: "My Order",
                            backgroundColor: Colors.orange[100]!,
                            iconColor: Colors.orange[800]!,
                            onTap: () {},
                            icon: Icons.opacity_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _DiamondCard(
                            title: "My Watchlist",
                            backgroundColor: Colors.yellow[100]!,
                            iconColor: Colors.yellow[800]!,
                            onTap: () {},
                            icon: Icons.watch_later,
                          ),
                          _DiamondCard(
                            title: "My Purchase",
                            backgroundColor: Colors.red[100]!,
                            iconColor: Colors.pink[800]!,
                            onTap: () {},
                            icon: Icons.publish_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.attach_money, size: 50, color: Colors.green),
                          SizedBox(height: 8),
                          Text(
                            "Sell Diamonds",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
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
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue[200],
        unselectedItemColor: Colors.purple[200],
        showUnselectedLabels: true,
        onTap: (index) {
          // Handle navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'CART',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.opacity_rounded),
            label: 'ORDER',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.publish_rounded), label: 'PURCHASE'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }
}

class _DiamondCard extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final IconData icon;

  const _DiamondCard({
    Key? key,
    required this.title,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor,
        elevation: 6, // Increase shadow for depth
        shadowColor: Colors.grey.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // More rounded
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.37, // Adaptive width
          height: MediaQuery.of(context).size.width * 0.37, // Increase height
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 40), // Bigger icon
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16, // Slightly larger text
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
