
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/SharedPrefService.dart';
import 'package:flutter/material.dart';
import '../Dashboard/User/Profile.dart';
import '../Library/AppColour.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import 'package:get/get.dart';
import '../Authentication/AuthChoice.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryWhite,
      child: Column(
        children: [
          _buildDrawerHeader(),
          ApiService.userTypes == 'admin'
              ? Expanded(
                child: ListView(
                  children: [
                    _buildDrawerItem(
                      icon: Icons.person,
                      text: "Profile",
                      iconColor: AppColors.primaryBlack,
                      onTap: () => Get.to(Profile()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.home,
                      text: "Home",
                      iconColor: AppColors.primaryBlack,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.shopping_cart_checkout,
                      text: "My PURCHASE",
                      iconColor: AppColors.primaryBlack,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.receipt_long,
                      text: "Orders",
                      iconColor: AppColors.primaryBlack,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.favorite_border,
                      text: "INQUIRY",
                      iconColor: AppColors.primaryBlack,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      text: "REPORT",
                      iconColor: AppColors.primaryBlack,
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.primaryBlack),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      text: "Logout",
                      iconColor: Colors.redAccent,
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
                  children: [
                    _buildDrawerItem(
                      icon: Icons.person,
                      text: "Profile",
                      iconColor: AppColors.primaryBlack,
                      onTap: () => Get.to(Profile()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.home,
                      text: "Home",
                      iconColor: AppColors.primaryBlack,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.shopping_cart_checkout,
                      text: "My Cart",
                      iconColor: AppColors.primaryBlack,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.receipt_long,
                      text: "Orders",
                      iconColor: AppColors.primaryBlack,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.favorite_border,
                      text: "Wishlist",
                      iconColor: AppColors.primaryBlack,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      text: "Settings",
                      iconColor: AppColors.primaryBlack,
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.primaryBlack),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      text: "Logout",
                      iconColor: Colors.redAccent,
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
    );
  }

  Widget _buildDrawerHeader() {
    String name = SharedPrefService.getString('user_name') ?? "";
    String email = SharedPrefService.getString('user_email') ?? "";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: AppColors.primaryWhite),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryBlack,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.primaryBlack,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: const TextStyle(color: AppColors.primaryBlack, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlack.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryBlack,
        ),
      ),
      onTap: onTap,
    );
  }
}
