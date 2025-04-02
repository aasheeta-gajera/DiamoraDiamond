
import 'package:flutter/material.dart';
import '../../Library/AppImages.dart';
import '../../Library/DiamondBackground.dart';
import '../../Library/Drawer.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import 'package:get/get.dart';

import 'DiamondInventory.dart';


class CustomerDashboard extends StatelessWidget {
  final String? token;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CustomerDashboard({Key? key, this.token}) : super(key: key);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text("Customer",style: TextStyleHelper.mediumWhite.copyWith(color: AppColors.primaryColour),),
        leading: IconButton(
          color: AppColors.primaryColour,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu, color: AppColors.primaryColour),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryColour,
      drawer: CommonDrawer(), // Drawer`
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 4),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildGrid(context),
                  const SizedBox(height: 30),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.attach_money, size: 50, color: AppColors.primaryWhite),
                          SizedBox(height: 8),
                          Text(
                            "MY INVENTORY",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryWhite,
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
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
            _selectedIndex = index;
            switch (index) {
            case 0:
              Get.to(() => CustomerDashboard());
              break;
            case 1:
             // Get.to(() => DiamondListScreen());
              break;
            case 2:
             // Get.to(() => OrdersPage());
              break;
            case 3:
              //Get.to(() => PurchasePage());
              break;
            case 4:
             // Get.to(() => AccountPage());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'CART'),
          BottomNavigationBarItem(icon: Icon(Icons.opacity_rounded), label: 'ORDER'),
          BottomNavigationBarItem(icon: Icon(Icons.publish_rounded), label: 'PURCHASE'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ACCOUNT'),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(title: "INVENTORY", icon: Icons.diamond, onTap: () {
              Get.to(DiamondInventory());
            },),
            _DiamondCard(title: "SEARCH", icon: Icons.search, onTap: () {},),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(title: "CART", icon: Icons.add_shopping_cart, onTap: () {},),
            _DiamondCard(title: "ORDER", icon: Icons.opacity_rounded, onTap: () {},),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(title: "PURCHASE", icon: Icons.watch_later, onTap: () {},),
            // _DiamondCard(title: "MEMO", icon: Icons.publish_rounded, onTap: () {},),
          ],
        ),
      ],
    );
  }
}

class _DiamondCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DiamondCard({Key? key, required this.title, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[900],
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.37,
          height: MediaQuery.of(context).size.width * 0.37,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryWhite, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryWhite,
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
