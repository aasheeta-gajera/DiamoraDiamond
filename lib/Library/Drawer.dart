
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
      backgroundColor: AppColors.greyLight,
      child: Column(
        children: [
          _buildDrawerHeader(),
          ApiService.userTypes == 'admin'
              ? Expanded(
                child: ListView(
                  children: [
                    _buildDrawerItem(
                      icon: Icons.person,
                      text: "PROFILE",
                      iconColor: AppColors.primaryColour,
                      onTap: () => Get.to(Profile()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.home,
                      text: "HOME",
                      iconColor: AppColors.primaryColour,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.shopping_cart_checkout,
                      text: "PURCHASE",
                      iconColor: AppColors.primaryColour,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.receipt_long,
                      text: "ORDER",
                      iconColor: AppColors.primaryColour,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.favorite_border,
                      text: "INQUIRY",
                      iconColor: AppColors.primaryColour,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      text: "REPORT",
                      iconColor: AppColors.primaryColour,
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.primaryColour),
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
                      text: "PROFILE",
                      iconColor: AppColors.primaryColour,
                      onTap: () => Get.to(Profile()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.home,
                      text: "HOME",
                      iconColor: AppColors.primaryColour,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.shopping_cart_checkout,
                      text: "MY CART",
                      iconColor: AppColors.primaryColour,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.receipt_long,
                      text: "ORDER",
                      iconColor: AppColors.primaryColour,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.favorite_border,
                      text: "WISHLIST",
                      iconColor: AppColors.primaryColour,
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      text: "SETTING",
                      iconColor: AppColors.primaryColour,
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.primaryColour),
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
      decoration: const BoxDecoration(color: AppColors.greyLight),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryColour,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.primaryColour,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.primaryColour,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: const TextStyle(color: AppColors.primaryColour, fontSize: 14),
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
          color: AppColors.primaryColour.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColour,
        ),
      ),
      onTap: onTap,
    );
  }
}
