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
  String idProof = "";
  String licenseCopy = "";
  String taxCertificate = "";
  String partnerCopy = "";
  String userType = "";

  Future<void> getUserDetails() async {
    name = SharedPrefService.getString('user_name') ?? "N/A";
    email = SharedPrefService.getString('user_email') ?? "N/A";
    mobileNo = SharedPrefService.getString('mobileNo') ?? "N/A";
    address = SharedPrefService.getString('Address') ?? "N/A";
    city = SharedPrefService.getString('City') ?? "N/A";
    contactName = SharedPrefService.getString('contactName') ?? "N/A";
    companyName = SharedPrefService.getString('companyName') ?? "N/A";
    idProof = SharedPrefService.getString('id_proof') ?? "N/A";
    licenseCopy = SharedPrefService.getString('license_copy') ?? "N/A";
    taxCertificate = SharedPrefService.getString('tax_certificate') ?? "N/A";
    partnerCopy = SharedPrefService.getString('partner_copy') ?? "N/A";
    userType = SharedPrefService.getString('userType') ?? "N/A";
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.profile, style: theme.textTheme.titleLarge),
        backgroundColor: AppColors.secondaryColour,
        elevation: 0,
        leading: BackButton(color: AppColors.primaryColour),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColour, AppColors.secondaryColour],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Profile Info Card
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildProfileRow(AppString.contactName, contactName, theme),
                          _buildProfileRow(AppString.email, email, theme),
                          _buildProfileRow(AppString.mobileNo, mobileNo, theme),
                          _buildProfileRow(AppString.city, city, theme),
                          _buildProfileRow(AppString.address, address, theme),
                          _buildProfileRow(AppString.companyName, companyName, theme),
                          _buildProfileRow("ID Proof", idProof, theme),
                          _buildProfileRow("License Copy", licenseCopy, theme),
                          _buildProfileRow("Tax Certificate", taxCertificate, theme),
                          _buildProfileRow("Partner Copy", partnerCopy, theme),
                          _buildProfileRow("User Type", userType, theme),
                        ],
                      ),

                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: logout,
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      AppString.logout,
                      style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildProfileRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
