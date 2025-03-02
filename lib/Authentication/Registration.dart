
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Library/AppColour.dart';
import '../Library/Utils.dart' as utils;
import '../Library/ApiService.dart';
import '../Models/UserModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _personalFormKey = GlobalKey<FormState>();
  final _kycFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  XFile? selectedImageKYC;
  XFile? selectedLicenseCopy;
  XFile? selectedTaxCertificate;
  XFile? selectedPartnerCopy;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Future<void> _pickImage(Function(XFile?) onImageSelected) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        onImageSelected(pickedImage);
      });
    }
  }

  Future<String?> _convertImageToBase64(XFile? imageFile) async {
    if (imageFile == null) return null;
    final bytes = await File(imageFile.path).readAsBytes();
    return base64Encode(bytes);
  }
  bool isLoading = false;

  void _register() async {
    setState(() => isLoading = true);
    
    String? idProofBase64 = await _convertImageToBase64(selectedImageKYC);
    String? licenseCopyBase64 = await _convertImageToBase64(selectedLicenseCopy);
    String? taxCertificateBase64 = await _convertImageToBase64(selectedTaxCertificate);
    String? partnerCopyBase64 = await _convertImageToBase64(selectedPartnerCopy);

    UserModel user = UserModel(
      userId: _usernameController.text,
      password: _passwordController.text,
      email: _emailController.text,
      mobile: _mobileController.text,
      city: _pincodeController.text,
      userType: "admin",
      address: _addressController.text,
      companyName: _companyNameController.text,
      contactName: _nameController.text,
      idProof: idProofBase64 ?? "",
      licenseCopy: licenseCopyBase64 ?? "",
      taxCertificate: taxCertificateBase64 ?? "",
      partnerCopy: partnerCopyBase64 ?? "",
      references: [Reference(name: "Ref1", phone: "9876543210")],
    );
      try {
        final response = await http.post(
          Uri.parse('${ApiService.baseUrl}/register'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(user.toJson()),
        );
        setState(() => isLoading = false);

        if (response.statusCode == 200 || response.statusCode == 201) {
          utils.showCustomSnackbar('Login successful!', true);
          Get.to(() => LogIn());

        } else {
          utils.showCustomSnackbar(jsonDecode(response.body)['message'] , false);

          print("Error: ${response.body}");
        }
      } catch (e) {
        setState(() => isLoading = false);
        utils.showCustomSnackbar('${e}', false);
      }
  }

  void _nextTab(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: PopScope(
        canPop: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'REGISTER',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryBlack),
              ),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryBlack,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primaryBlack,
                tabs: const [
                  Tab(text: "Personal Info"),
                  Tab(text: "KYC Info"),
                  Tab(text: "Business Info"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildPersonalInfoForm(),
                    _buildKYCInfoForm(),
                    _buildBusinessInfoForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Form(
      key: _personalFormKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [

          utils.buildTextField("Name", _nameController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
          utils.buildTextField("Email", _emailController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
          utils.buildTextField("Mobile No", _mobileController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
          utils.buildTextField("Username", _usernameController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
          utils.buildTextField("Password", _passwordController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
          utils.buildTextField("Confirm Password", _confirmPasswordController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),

          SizedBox(height: 20),
          utils.PrimaryButton(text: "Next", onPressed: () {
            _nextTab(_personalFormKey);
          },)
        ],
      ),
    );
  }

  Widget _buildKYCInfoForm() {
    return SingleChildScrollView(
      child: Form(
        key: _kycFormKey,
        child: Column(
          children: [
            _buildImagePicker("ID Proof", selectedImageKYC, (image) => selectedImageKYC = image),
            _buildImagePicker("License Copy", selectedLicenseCopy, (image) => selectedLicenseCopy = image),
            _buildImagePicker("Tax Certificate", selectedTaxCertificate, (image) => selectedTaxCertificate = image),
            _buildImagePicker("Partner Copy", selectedPartnerCopy, (image) => selectedPartnerCopy = image),
            SizedBox(height: 20),
            utils.PrimaryButton(text: "Next", onPressed: () {
              _nextTab(_kycFormKey);
            },)
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(String label, XFile? selectedFile, Function(XFile?) onImageSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.primaryBlack, fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: InkWell(
            onTap: () => _pickImage(onImageSelected),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  if (selectedFile != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(selectedFile.path),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Icon(Icons.image_outlined, color: Colors.grey, size: 50),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      selectedFile != null ? selectedFile.name : "Select Image",
                      style: TextStyle(
                        color: selectedFile != null ? Colors.black : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (selectedFile != null)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          onImageSelected(null);
                        });
                      },
                      icon: Icon(Icons.cancel, color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildBusinessInfoForm() {
    return Form(
      key: _businessFormKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          utils.buildTextField("Company Name", _companyNameController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
          utils.buildTextField("Address", _addressController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
          utils.buildTextField("City", _pincodeController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),

          SizedBox(height: 20),
          utils.PrimaryButton(text: "Submit", onPressed: _register)
        ],
      ),
    );
  }

}
