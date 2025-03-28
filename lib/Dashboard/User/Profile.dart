
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Authentication/Login.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
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
    setState(() {});  // Refresh UI after fetching data
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
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryBlack,
        title: Text("PROFILE",style: TextStyleHelper.mediumWhite,),
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: AppColors.primaryWhite,)),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),

          // Dark Overlay for readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  profileDetail("Contact Name", contactName),
                  profileDetail("Email", email),
                  profileDetail("Mobile No", mobileNo),
                  profileDetail("city", city),
                  profileDetail("Address", address),
                  profileDetail("Company Name", address),
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
        ],
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
