import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Authentication/Login.dart';
import '../../Library/AppColour.dart';
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
        title: Text(AppString.profile, style: TextStyleHelper.mediumPrimaryColour),
        backgroundColor: AppColors.secondaryColour,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColour,
          ),
        ),      ),
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
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildProfileRow(Icons.person, AppString.contactName, contactName, theme),
                          _buildProfileRow(Icons.email, AppString.email, email, theme),
                          _buildProfileRow(Icons.phone, AppString.mobileNo, mobileNo, theme),
                          _buildProfileRow(Icons.location_city, AppString.city, city, theme),
                          _buildProfileRow(Icons.home, AppString.address, address, theme),
                          _buildProfileRow(Icons.business, AppString.companyName, companyName, theme),
                          _buildProfileRow(Icons.document_scanner, "ID Proof", idProof, theme),
                          _buildProfileRow(Icons.file_copy, "License Copy", licenseCopy, theme),
                          _buildProfileRow(Icons.assignment, "Tax Certificate", taxCertificate, theme),
                          _buildProfileRow(Icons.group, "Partner Copy", partnerCopy, theme),
                          _buildProfileRow(Icons.account_box, "User Type", userType, theme),
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

  Widget _buildProfileRow(IconData icon, String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 28),
          const SizedBox(width: 16),
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
