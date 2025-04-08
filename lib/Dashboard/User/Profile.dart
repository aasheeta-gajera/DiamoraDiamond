import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Authentication/Login.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import '../../Library/SharedPrefService.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String email = "";
  String mobileNo = "";
  String address = "";
  String companyName = "";
  String city = "";
  String contactName = "";

  Future<void> getUserDetails() async {
    name = SharedPrefService.getString('user_name') ?? "N/A";
    email = SharedPrefService.getString('user_email') ?? "N/A";
    mobileNo = SharedPrefService.getString('mobileNo') ?? "N/A";
    address = SharedPrefService.getString('Address') ?? "N/A";
    city = SharedPrefService.getString('City') ?? "N/A";
    contactName = SharedPrefService.getString('contactName') ?? "N/A";
    companyName = SharedPrefService.getString('contactName') ?? "N/A";
    setState(() {});
  }

  void logout() async {
    await SharedPrefService.clearAll();
    Get.offAll(() => LogIn());
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.profile,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: AppColors.primaryColour,
          ),
        ),
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryWhite,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primaryColour,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: TextStyleHelper.extraLargeWhite.copyWith(
                          fontSize: 24,
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
                ),

                // Profile Details
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
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
                  child: Column(
                    children: [
                      _buildProfileDetail(AppString.contactName, contactName),
                      _buildDivider(),
                      _buildProfileDetail(AppString.email, email),
                      _buildDivider(),
                      _buildProfileDetail(AppString.mobileNo, mobileNo),
                      _buildDivider(),
                      _buildProfileDetail(AppString.city, city),
                      _buildDivider(),
                      _buildProfileDetail(AppString.address, address),
                      _buildDivider(),
                      _buildProfileDetail(AppString.companyName, companyName),
                    ],
                  ),
                ),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: ElevatedButton(
                    onPressed: logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.overlayLight,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppString.logout,
                          style: TextStyleHelper.mediumWhite.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyleHelper.mediumWhite.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyleHelper.mediumWhite.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white.withOpacity(0.1),
    );
  }
}
