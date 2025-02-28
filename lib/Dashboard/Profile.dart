
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Authentication/LoginScreen.dart';
import '../Library/AppColour.dart';
import '../Library/AppStyle.dart';
import '../Library/api_service.dart';
import '../Library/shared_pref_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";
  String mobileNo = "";
  String address = "";
  String city = "";
  String contactName = "";



  Future<void> getUserDetails() async {
    name = SharedPrefService.getString('user_name') ?? "N/A";
    email = SharedPrefService.getString('user_email') ?? "N/A";
    mobileNo = SharedPrefService.getString('mobileNo') ?? "N/A";
    address = SharedPrefService.getString('Address') ?? "N/A";
    city = SharedPrefService.getString('City') ?? "N/A";
    contactName = SharedPrefService.getString('contactName') ?? "N/A";
    setState(() {});  // Refresh UI after fetching data
  }

  void logout() async {
    await SharedPrefService.clearAll();
    Get.offAll(() => Loginscreen());
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Profile",
                style: TextStyleHelper.bigBlack.copyWith(fontWeight: FontWeight.bold),
              ),
              profileDetail("Name", name),
              profileDetail("contactName", contactName),
              profileDetail("Email", email),
              profileDetail("Mobile No", mobileNo),
              profileDetail("city", city),
              profileDetail("Address", address),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.primaryBlack,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    textStyle: TextStyleHelper.mediumBlack,
                  ),
                  child: Text("Logout",style: TextStyleHelper.mediumWhite,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget profileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyleHelper.mediumBlack.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
