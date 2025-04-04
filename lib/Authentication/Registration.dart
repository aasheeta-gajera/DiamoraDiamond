
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/SharedPrefService.dart';
import '../Library/Utils.dart' as utils;
import '../Library/ApiService.dart';
import '../Models/UserModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'Login.dart';
import 'package:uuid/uuid.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _personalFormKey = GlobalKey<FormState>();
  final _kycFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _refNumberController = TextEditingController();
  final TextEditingController _refNameController = TextEditingController();

  XFile? selectedImageKYC;
  XFile? selectedLicenseCopy;
  XFile? selectedTaxCertificate;
  XFile? selectedPartnerCopy;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    String? licenseCopyBase64 = await _convertImageToBase64(
      selectedLicenseCopy,
    );
    String? taxCertificateBase64 = await _convertImageToBase64(
      selectedTaxCertificate,
    );
    String? partnerCopyBase64 = await _convertImageToBase64(
      selectedPartnerCopy,
    );
    var uuid = Uuid();
    String id = uuid.v4();
    await SharedPrefService.setString('userId',id);
    UserModel user = UserModel(
      userId: id.toString(),
      password: _passwordController.text,
      email: _emailController.text,
      mobile: _mobileController.text,
      city: _cityController.text,
      userType: "customer",
      address: _addressController.text,
      companyName: _companyNameController.text,
      contactName: _nameController.text,
      idProof: idProofBase64 ?? "",
      licenseCopy: "",
      taxCertificate: taxCertificateBase64 ?? "",
      partnerCopy: partnerCopyBase64 ?? "",
      business_type: _selectedBusinessType.toString(),
      terms_agreed: _termsAgreed,
      references: [
        Reference(
          name: _refNameController.text,
          phone: _refNumberController.text,
        ),
      ],
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
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);

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

  String? _selectedBusinessType;
  bool _termsAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColour,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text("REGISTER", style: TextStyleHelper.mediumPrimaryColour),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: AppColors.primaryColour,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),

          // Dark Overlay for readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          PopScope(
            canPop: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primaryWhite,
                    unselectedLabelColor: AppColors.primaryWhite,
                    indicatorColor: AppColors.primaryWhite,
                    physics: NeverScrollableScrollPhysics(),
                    onTap: (index) {
                      if (_tabController.index == 0 &&
                          (_personalFormKey.currentState?.validate() ??
                              false)) {
                        _tabController.animateTo(index);
                      } else if (_tabController.index == 1 &&
                          (_kycFormKey.currentState?.validate() ?? false)) {
                        _tabController.animateTo(index);
                      } else if (_tabController.index == 2 &&
                          !_businessFormKey.currentState!.validate()) {
                        _tabController.animateTo(index);
                      }
                    },
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
          utils.buildTextField(
            "Name",
            _nameController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name cannot be empty";
              }
              return null;
            },
          ),
          utils.buildTextField(
            "Email",
            _emailController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email cannot be empty";
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          utils.buildTextField(
            "Mobile No",
            _mobileController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Mobile number cannot be empty";
              } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return "Enter a valid 10-digit mobile number";
              }
              return null;
            },
          ),
          utils.buildTextField(
            "Address",
            _addressController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Address is required";
              }
              return null;
            },
          ),
          utils.buildTextField(
            "City",
            _cityController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "City is required";
              }
              return null;
            },
          ),
          // utils.buildTextField(
          //   "Username",
          //   _usernameController,
          //   textColor: AppColors.primaryColour,
          //   hintColor: Colors.grey,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return "Username cannot be empty";
          //     } else if (value.length < 4) {
          //       return "Username must be at least 4 characters";
          //     }
          //     return null;
          //   },
          // ),
          utils.buildTextField(
            "Password",
            _passwordController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password cannot be empty";
              } else if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          utils.buildTextField(
            "Confirm Password",
            _confirmPasswordController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Confirm Password cannot be empty";
              } else if (value != _passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          utils.PrimaryButton(
            text: "Next",
            onPressed: () {
              if (_nameController.text.toString().trim().isEmpty) {
                utils.showCustomSnackbar("Please Enter Name", false);
              } else if (_emailController.text.toString().trim().isEmpty) {
                utils.showCustomSnackbar("Please Enter Email", false);
              } else if (_mobileController.text.toString().trim().isEmpty) {
                utils.showCustomSnackbar("Please Enter Mobile Number", false);
              } else if (_passwordController.text.toString().trim().isEmpty) {
                utils.showCustomSnackbar("Please Enter Password", false);
              } else if (_passwordController.text.trim().isEmpty) {
                utils.showCustomSnackbar("Please Enter Password", false);
              } else if (_addressController.text.trim().isEmpty) {
                utils.showCustomSnackbar("Please Enter Address", false);
              } else if (_cityController.text.trim().isEmpty) {
                utils.showCustomSnackbar("Please Enter City", false);
              } else if (!RegExp(
                r'^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
              ).hasMatch(_passwordController.text.trim())) {
                utils.showCustomSnackbar(
                  "Password must be at least 8 characters long, include one uppercase letter, one number, and one special character.",
                  false,
                );
              } else if (_confirmPasswordController.text.trim().isEmpty) {
                utils.showCustomSnackbar(
                  "Please Enter Confirm Password",
                  false,
                );
              } else if (_passwordController.text.trim() !=
                  _confirmPasswordController.text.trim()) {
                utils.showCustomSnackbar("Passwords do not match", false);
              } else {
                _nextTab(_personalFormKey);
              }
            },
          ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildImagePicker(
                AppString.idProof,
                selectedImageKYC,
                (image) => setState(() => selectedImageKYC = image),
                selectedImageKYC == null ? "ID Proof is required" : null,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: _buildImagePicker("License Copy", selectedLicenseCopy, (image) => setState(() => selectedLicenseCopy = image), selectedLicenseCopy == null ? "License Copy is required" : null),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildImagePicker(
                AppString.taxCertificate,
                selectedTaxCertificate,
                (image) => setState(() => selectedTaxCertificate = image),
                null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildImagePicker(
              AppString.partnerCopy,
                selectedPartnerCopy,
                (image) => setState(() => selectedPartnerCopy = image),
                null,
              ),
            ),

            SizedBox(height: 20),
            utils.PrimaryButton(
              text: AppString.next,
              onPressed: () {
                if (selectedImageKYC == null) {
                  utils.showCustomSnackbar("Please Attach ID Proof", false);}
                // } else if (selectedLicenseCopy == null) {
                //   utils.showCustomSnackbar(
                //     "Please Attach License Copy Proof",
                //     false,
                //   );
                // } else if (selectedTaxCertificate == null) {
                //   utils.showCustomSnackbar(
                //     "Please Attach Tax Certificate Proof",
                //     false,
                //   );
                // } else if (selectedPartnerCopy == null) {
                //   utils.showCustomSnackbar(
                //     "Please Attach Partner Copy Proof",
                //     false,
                //   );
                // }
                else {
                  _nextTab(_kycFormKey);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(
    String label,
    XFile? selectedFile,
    Function(XFile?) onImageSelected,
    String? errorText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryWhite,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white),
          ),
          child: InkWell(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedImage = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (pickedImage != null) {
                setState(() {
                  onImageSelected(pickedImage);
                });
              }
            },
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
                    Icon(
                      Icons.image_outlined,
                      color: AppColors.primaryWhite,
                      size: 50,
                    ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      selectedFile != null ? selectedFile.name : "Select Image",
                      style: TextStyle(
                        color:
                            selectedFile != null
                                ? AppColors.primaryWhite
                                : AppColors.primaryWhite,
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
                      icon: Icon(Icons.cancel, color: Colors.redAccent),
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
          utils.buildTextField(
            AppString.companyName,
            _companyNameController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            // validator: (value) {
            //   if (value == null || value.trim().isEmpty) {
            //     return "Company Name is required";
            //   }
            //   return null;
            // },
          ),
          utils.buildTextField(
            AppString.referenceName,
            _refNameController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            validator: (value) {},
          ),
          utils.buildTextField(
            AppString.referenceNumber,
            _refNumberController,
            textColor: AppColors.primaryColour,
            hintColor: Colors.grey,
            validator: (value) {},
          ),

          // Business Type Dropdown
          Text(
            AppString.businessType,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColour,
            ),
          ),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: AppString.businessType,
              labelStyle: TextStyle(
                color: Colors.white,
              ), // Set label color to white
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryWhite),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryWhite, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            style: TextStyle(color: Colors.white),
            dropdownColor: Colors.black,
            value: _selectedBusinessType,
            items:
                ["Retailer", "Wholesaler", "Manufacturer"]
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _selectedBusinessType = value!;
              });
            },
            validator:
                (value) =>
                    value == null ? "Please select a business type" : null,
          ),

          SizedBox(height: 20),

          // Terms & Conditions Checkbox
          Row(
            children: [
              Checkbox(
                value: _termsAgreed,
                activeColor:
                    AppColors
                        .primaryColour, // Changes the box color when checked
                checkColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    _termsAgreed = value!;
                  });
                },
              ),
              Expanded(
                child: Text(
                  AppString.term,
                  style: TextStyleHelper.mediumWhite,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          utils.PrimaryButton(
            text: AppString.submit,
            onPressed: () {
              if (_termsAgreed == false) {
    utils.showCustomSnackbar("Please Accept T&C", false);
              } else {
                _register();
              }
            },
          ),
        ],
      ),
    );
  }
}
