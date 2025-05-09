import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/SharedPrefService.dart';
import 'package:flutter/material.dart';
import '../Dashboard/Admin/AddSupplier.dart';
import '../Dashboard/Admin/DiamondPurchase.dart';
import '../Dashboard/Admin/InquiryAns.dart';
import '../Dashboard/User/AddCart.dart';
import '../Dashboard/User/CustomerDashboard.dart';
import '../Dashboard/User/Order.dart';
import '../Dashboard/User/Profile.dart';
import '../Library/AppColour.dart';
import '../Library/AppStyle.dart';
import 'package:get/get.dart';
import 'AppImages.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryWhite,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColour, AppColors.secondaryColour],
          ),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(),
            ApiService.userTypes == 'admin'
                ? Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildDrawerItem(
                          icon: Icons.person,
                          text: "PROFILE",
                          onTap: () => Get.to(Profile()),
                        ),
                        _buildDrawerItem(
                          icon: Icons.home,
                          text: "HOME",
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildDrawerItem(
                          icon: Icons.shopping_cart_checkout,
                          text: "CART",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>CardDiamonds())),
                        ),
                        _buildDrawerItem(
                          icon: Icons.receipt_long,
                          text: "ORDER",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>Order())),
                        ),
                        _buildDrawerItem(
                          icon: Icons.favorite_border,
                          text: "INQUIRY",
                          onTap: () {},
                        ),
                        _buildDrawerItem(
                          icon: Icons.settings,
                          text: "REPORT",
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportDashboard()));
                          },
                        ),
                        const Divider(
                          color: AppColors.primaryWhite,
                          height: 32,
                          thickness: 0.5,
                        ),
                        _buildDrawerItem(
                          icon: Icons.logout,
                          text: "Logout",
                          isLogout: true,
                          onTap: () {
                            ApiService apiService = ApiService();
                            apiService.logout();
                          },
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildDrawerItem(
                          icon: Icons.person,
                          text: "PROFILE",
                          onTap: () => Get.to(Profile()),
                        ),
                        _buildDrawerItem(
                          icon: Icons.home,
                          text: "HOME",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerDashboard())),
                        ),
                        _buildDrawerItem(
                          icon: Icons.shopping_cart_checkout,
                          text: "PURCHASE",
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>DiamondPurchaseForm())),
                        ),
                        _buildDrawerItem(
                          icon: Icons.receipt_long,
                          text: "INVENTORY",
                          onTap: () {},
                        ),
                        _buildDrawerItem(
                          icon: Icons.favorite_border,
                          text: "INQUIRY",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminInquiryScreen(adminName: "Aasheeta",)));
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.settings,
                          text: "ADD SUPPLIER",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddSupplier()));
                          },
                        ),
                        const Divider(
                          color: AppColors.primaryWhite,
                          height: 32,
                          thickness: 0.5,
                        ),
                        _buildDrawerItem(
                          icon: Icons.logout,
                          text: "Logout",
                          isLogout: true,
                          onTap: () {
                            ApiService apiService = ApiService();
                            apiService.logout();
                          },
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    String name = SharedPrefService.getString('user_name') ?? "";
    String email = SharedPrefService.getString('user_email') ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ClipOval(
            child: Image.asset(
              AppImages.splashImage,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: TextStyleHelper.extraLargeWhite.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: TextStyleHelper.mediumWhite.copyWith(
              fontSize: 14,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isLogout ? Colors.redAccent : AppColors.primaryWhite,
          ),
        ),
        title: Text(
          text,
          style: TextStyleHelper.mediumWhite.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.redAccent : AppColors.primaryWhite,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
