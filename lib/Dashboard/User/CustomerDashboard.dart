import 'package:flutter/material.dart';
import '../../Library/AppImages.dart';
import '../../Library/DiamondBackground.dart';
import '../../Library/Drawer.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import 'package:get/get.dart';

import 'AddCart.dart';
import 'AddInquiry.dart';
import 'DiamondInventory.dart';
import 'DiamondSearch.dart';


class CustomerDashboard extends StatelessWidget {
  final String? token;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CustomerDashboard({Key? key, this.token}) : super(key: key);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.customer,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(
            Icons.menu,
            color: AppColors.primaryColour,
          ),
        ),
      ),
      drawer: const CommonDrawer(),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Card
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.overlayLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: (){

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppString.myInventory,
                                style: TextStyleHelper.mediumWhite.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'View your diamond collection',
                                style: TextStyleHelper.mediumWhite.copyWith(
                                  fontSize: 14,
                                  // opacity: 0.8,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryWhite.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.attach_money,
                              size: 40,
                              color: AppColors.primaryWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Grid Section
                _buildGrid(context),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: AppColors.overlayLight,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.1),
      //         blurRadius: 10,
      //         offset: const Offset(0, -2),
      //       ),
      //     ],
      //   ),
      //   child: ClipRRect(
      //     borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      //     child: BottomNavigationBar(
      //       backgroundColor: AppColors.overlayLight,
      //       currentIndex: _selectedIndex,
      //       selectedItemColor: AppColors.primaryColour,
      //       unselectedItemColor: AppColors.secondaryColour.withOpacity(0.5),
      //       showUnselectedLabels: true,
      //       type: BottomNavigationBarType.fixed,
      //       elevation: 0,
      //       selectedLabelStyle: TextStyleHelper.mediumWhite.copyWith(
      //         fontSize: 12,
      //         fontWeight: FontWeight.w500,
      //       ),
      //       unselectedLabelStyle: TextStyleHelper.mediumWhite.copyWith(
      //         fontSize: 12,
      //         fontWeight: FontWeight.w400,
      //         // opacity: 0.5,
      //       ),
      //       onTap: (index) {
      //         _selectedIndex = index;
      //         switch (index) {
      //           case 0:
      //             Get.to(() => CustomerDashboard());
      //             break;
      //           case 1:
      //             Get.to(() => CardDiamonds());
      //             break;
      //           case 2:
      //             // Get.to(() => OrdersPage());
      //             break;
      //           case 3:
      //             // Get.to(() => PurchasePage());
      //             break;
      //           case 4:
      //             // Get.to(() => AccountPage());
      //             break;
      //         }
      //       },
      //       items: [
      //         BottomNavigationBarItem(
      //           icon: Container(
      //             padding: const EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: _selectedIndex == 0
      //                   ? AppColors.primaryWhite.withOpacity(0.2)
      //                   : Colors.transparent,
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //             child: const Icon(Icons.home),
      //           ),
      //           label: 'HOME',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Container(
      //             padding: const EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: _selectedIndex == 1
      //                   ? AppColors.primaryWhite.withOpacity(0.2)
      //                   : Colors.transparent,
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //             child: const Icon(Icons.add_shopping_cart),
      //           ),
      //           label: 'CART',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Container(
      //             padding: const EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: _selectedIndex == 2
      //                   ? AppColors.primaryWhite.withOpacity(0.2)
      //                   : Colors.transparent,
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //             child: const Icon(Icons.opacity_rounded),
      //           ),
      //           label: 'ORDER',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Container(
      //             padding: const EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: _selectedIndex == 3
      //                   ? AppColors.primaryWhite.withOpacity(0.2)
      //                   : Colors.transparent,
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //             child: const Icon(Icons.publish_rounded),
      //           ),
      //           label: 'INVENTORY',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Container(
      //             padding: const EdgeInsets.all(8),
      //             decoration: BoxDecoration(
      //               color: _selectedIndex == 4
      //                   ? AppColors.primaryWhite.withOpacity(0.2)
      //                   : Colors.transparent,
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //             child: const Icon(Icons.person),
      //           ),
      //           label: 'ACCOUNT',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(
              title: AppString.inventory,
              icon: Icons.diamond,
              onTap: () => Get.to(const DiamondInventory()),
            ),
            _DiamondCard(
              title: AppString.search,
              icon: Icons.search,
              onTap: () => Get.to(const DiamondSearch()),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(
              title: AppString.cart,
              icon: Icons.add_shopping_cart,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CardDiamonds()));
              },
            ),
            _DiamondCard(
              title: AppString.order,
              icon: Icons.opacity_rounded,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(
              title: AppString.bill,
              icon: Icons.watch_later,
              onTap: () {},
            ),
            _DiamondCard(
              title: AppString.inquiry,
              icon: Icons.inventory,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>InquiryScreen()));
              },
            ),
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

  const _DiamondCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: MediaQuery.of(context).size.width * 0.42,
        decoration: BoxDecoration(
          color: AppColors.overlayLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryWhite,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyleHelper.mediumWhite.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
