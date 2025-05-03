
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/ApiService.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'Login.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  // Image and Document Picker
  final ImagePicker _picker = ImagePicker();
  File? _idProofImage;
  File? _licenseCopyImage;
  File? _taxCertificateImage;
  File? _partnerCopyImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      // initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          switch (type) {
            case 'idProof':
              _idProofImage = File(pickedFile.path);
              break;
            case 'licenseCopy':
              _licenseCopyImage = File(pickedFile.path);
              break;
            case 'taxCertificate':
              _taxCertificateImage = File(pickedFile.path);
              break;
            case 'partnerCopy':
              _partnerCopyImage = File(pickedFile.path);
              break;
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: AppColors.error,
        colorText: AppColors.primaryWhite,
      );
    }
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: AppColors.error,
        colorText: AppColors.primaryWhite,
      );
      return;
    }

    if (_idProofImage == null || _licenseCopyImage == null || 
        _taxCertificateImage == null || _partnerCopyImage == null) {
      Get.snackbar(
        'Error',
        'Please upload all required documents',
        backgroundColor: AppColors.error,
        colorText: AppColors.primaryWhite,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiService.baseUrl}/register'),
      );

      // Add text fields
      request.fields.addAll({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'mobile': _mobileController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'contact_name': _contactNameController.text,
      });

      // Add files
      request.files.add(await http.MultipartFile.fromPath(
        'idProof',
        _idProofImage!.path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'licenseCopy',
        _licenseCopyImage!.path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'taxCertificate',
        _taxCertificateImage!.path,
      ));
      request.files.add(await http.MultipartFile.fromPath(
        'partnerCopy',
        _partnerCopyImage!.path,
      ));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseData);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Registration successful',
          backgroundColor: AppColors.success,
          colorText: AppColors.primaryWhite,
        );
        Get.off(() => const LogIn());
      } else {
        print(decodedResponse['message']);
        Get.snackbar(
          'Error',
          decodedResponse['message'] ?? 'Registration failed',
          backgroundColor: AppColors.error,
          colorText: AppColors.primaryWhite,
        );
        print('sajkhdihbdjh  ${decodedResponse['message']}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        backgroundColor: AppColors.error,
        colorText: AppColors.primaryWhite,
      );
      print('sssssssssssssssssssss  ${e}');

    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildDocumentUpload(String title, File? file, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyleHelper.mediumWhite.copyWith(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    file?.path.split('/').last ?? 'No file selected',
                    style: TextStyleHelper.mediumBlack.copyWith(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              PopupMenuButton<ImageSource>(
                icon: const Icon(Icons.upload_file),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ImageSource.gallery,
                    child: Row(
                      children: [
                        Icon(Icons.photo_library),
                        SizedBox(width: 8),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: ImageSource.camera,
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt),
                        SizedBox(width: 8),
                        Text('Camera'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: ImageSource.gallery,
                    child: Row(
                      children: [
                        Icon(Icons.folder),
                        SizedBox(width: 8),
                        Text('Files'),
                      ],
                    ),
                  ),
                ],
                onSelected: (source) => _pickImage(source, type),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          TextFormField(
            controller: _nameController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: AppString.name,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
          ),
          const SizedBox(height: 16),

          // Email Field
          TextFormField(
            controller: _emailController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: AppString.email,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _passwordController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: AppString.password,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
            obscureText: !_isPasswordVisible,
          ),
          const SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            controller: _confirmPasswordController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: AppString.confirmPassword,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
            obscureText: !_isConfirmPasswordVisible,
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mobile Field
          TextFormField(
            controller: _mobileController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            maxLength: 10,
            decoration: InputDecoration(
              labelText: AppString.mobileNo,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Address Field
          TextFormField(
            controller: _addressController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: AppString.address,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
          ),
          const SizedBox(height: 16),

          // City Field
          TextFormField(
            controller: _cityController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: AppString.city,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.location_city_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
          ),
          const SizedBox(height: 16),

          // Contact Name Field
          TextFormField(
            controller: _contactNameController,
            style: TextStyleHelper.mediumBlack.copyWith(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: AppString.contactName,
              labelStyle: TextStyleHelper.mediumBlack.copyWith(
                fontSize: 14,
              ),
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.primaryWhite,
            ),
          ),
          const SizedBox(height: 24),
          //
          // // Document Uploads
          // _buildDocumentUpload('ID Proof', _idProofImage, 'idProof'),
          // const SizedBox(height: 16),
          // _buildDocumentUpload('License Copy', _licenseCopyImage, 'licenseCopy'),
          // const SizedBox(height: 16),
          // _buildDocumentUpload('Tax Certificate', _taxCertificateImage, 'taxCertificate'),
          // const SizedBox(height: 16),
          // _buildDocumentUpload('Partner Copy', _partnerCopyImage, 'partnerCopy'),
        ],
      ),
    );
  }

  Widget _buildKYCTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Document Uploads
          _buildDocumentUpload('ID Proof', _idProofImage, 'idProof'),
          const SizedBox(height: 16),
          _buildDocumentUpload('License Copy', _licenseCopyImage, 'licenseCopy'),
          const SizedBox(height: 16),
          _buildDocumentUpload('Tax Certificate', _taxCertificateImage, 'taxCertificate'),
          const SizedBox(height: 16),
          _buildDocumentUpload('Partner Copy', _partnerCopyImage, 'partnerCopy'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text("Register", style: TextStyleHelper.mediumPrimaryColour),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: AppColors.primaryColour,
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColour,
              AppColors.secondaryColour,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 48, // fix the height of the TabBar
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primaryWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab, // make indicator match full tab size
                    labelColor: AppColors.primaryColour,
                    unselectedLabelColor: AppColors.primaryWhite,
                    labelPadding: EdgeInsets.zero, // remove extra horizontal padding if needed
                    tabs: const [
                      Tab(text: 'Personal Info'),
                      Tab(text: 'KYC Info'),
                      Tab(text: 'Business Info'),
                    ],
                  ),
                ),
              )
      ,


              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildPersonalInfoTab(),
                    _buildKYCTab(),
                    _buildBusinessInfoTab(),
                  ],
                ),
              ),

              // Register Button and Login Link
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppString.register,
                                style: TextStyleHelper.mediumBlack.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.off(() => const LogIn()),
                        child: Text(
                          AppString.alreadyHaveAccount,
                          style: TextStyleHelper.mediumWhite.copyWith(
                            fontSize: 14,
                            color: AppColors.primaryColour,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
