
import 'package:daimo/Library/AppStrings.dart';
import 'package:flutter/material.dart';
import '../../Library/AppImages.dart';
import '../../Library/AppStyle.dart';
import '../../Library/Drawer.dart';
import '../../Library/AppColour.dart';
import 'package:get/get.dart';
import 'AddSupplier.dart';
import 'DiamondPurchase.dart';
import 'Inventory.dart';


class AdminDashboard extends StatelessWidget {
  final String? token;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AdminDashboard({Key? key, this.token}) : super(key: key);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text(AppString.admin,style: TextStyleHelper.mediumPrimaryColour,),
        leading:  IconButton(
          color: AppColors.primaryWhite,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu, color: AppColors.primaryColour),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryColour,
      drawer: CommonDrawer(), // Drawer
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
                      color: AppColors.primaryWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.report_gmailerrorred, size: 50, color: AppColors.primaryColour),
                          SizedBox(height: 8),
                          Text(
                            AppString.sellReport,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColour,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.report_gmailerrorred, size: 50, color: AppColors.primaryColour),
                          SizedBox(height: 8),
                          Text(
                            AppString.purchase,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColour,
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
        backgroundColor: AppColors.primaryWhite,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
            _selectedIndex = index;
            switch (index) {
            case 0:
              Get.to(() => AdminDashboard());
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
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'PURCHASE'),
          BottomNavigationBarItem(icon: Icon(Icons.opacity_rounded), label: 'ORDER'),
          BottomNavigationBarItem(icon: Icon(Icons.publish_rounded), label: 'INQUIRY'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'REPORT'),
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
            _DiamondCard(title: AppString.inventory, icon: Icons.diamond, onTap: () {
              Get.to(Inventory());
            },),
            _DiamondCard(title: AppString.purchase, icon: Icons.add_shopping_cart, onTap: () {
              Get.to(DiamondPurchaseForm());
            },),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(title: AppString.addSupplier, icon: Icons.opacity_rounded, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddSupplier()));
            },),
            _DiamondCard(title: AppString.receiveOrder, icon: Icons.opacity_rounded, onTap: () {},),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(title: AppString.inquiry, icon: Icons.add_task_outlined, onTap: () {},),
            _DiamondCard(title: AppString.history, icon: Icons.watch_later, onTap: () {},),
            // _DiamondCard(title: "My Purchase", icon: Icons.publish_rounded, onTap: () {},),
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
        color:AppColors.primaryWhite,
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
              Icon(icon, color: AppColors.primaryColour, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColour,
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
