import '../Library/Utils.dart' as utils;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Library/DiamondBackground.dart';
import '../Library/api_service.dart';
import '../Models/UserModel.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form Keys
  final _personalFormKey = GlobalKey<FormState>();
  final _kycFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _nextTab(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _register() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

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
      idProof: _selectedImage?.path ?? "",
      licenseCopy: "",
      taxCertificate: "",
      partnerCopy: "",
      references: [Reference(name: "Ref1", phone: "9876543210")],
    );

    bool success = await ApiService.registerUser(user);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "User registered successfully!" : "Registration failed.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // DiamondBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'REGISTER',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height:20),
                TabBar(
                  controller: _tabController,
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
        ],
      ),
    );
  }

  Widget _buildPersonalInfoForm() {
    return Form(
      key: _personalFormKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          utils.buildTextField("Name", _nameController),
          utils.buildTextField("Email", _emailController),
          utils.buildTextField("Mobile No", _mobileController),
          utils.buildTextField("Username", _usernameController),
          utils.buildTextField("Password", _passwordController, obscureText: true),
          utils.buildTextField("Confirm Password", _confirmPasswordController, obscureText: true),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () => _nextTab(_personalFormKey), child: Text("Next")),
        ],
      ),
    );
  }

  Widget _buildKYCInfoForm() {
    return Form(
      key: _kycFormKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                _selectedImage != null
                    ? Image.file(
                  File(_selectedImage!.path),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 50, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt),
                  label: Text("Upload KYC Image"),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _nextTab(_kycFormKey),
            child: Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoForm() {
    return Form(
      key: _businessFormKey,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          utils.buildTextField("Company Name", _companyNameController),
          utils.buildTextField("Address", _addressController),
          utils.buildTextField("Pincode", _pincodeController),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _register, child: Text("Submit")),
        ],
      ),
    );
  }

}
