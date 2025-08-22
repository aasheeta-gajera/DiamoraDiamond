import 'dart:convert';
import 'package:daimo/Library/AppStrings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
import '../../Library/AppStyle.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/SupplierModel.dart';
import 'AdminDashboard.dart';

class AddSupplier extends StatefulWidget {
  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  bool isLoading = false;

  Future<void> addSupplier() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    // Create Supplier Object
    Supplier newSupplier = Supplier(
      id: "", // Backend will assign this
      name: nameController.text,
      contact: contactController.text,
      email: emailController.text,
      address: addressController.text,
      gstNumber: gstController.text,
      companyName: companyNameController.text,
    );

    try {
      // Convert to JSON string and encrypt it
      String jsonData = jsonEncode({
        "name": newSupplier.name,
        "contact": newSupplier.contact,
        "email": newSupplier.email,
        "address": newSupplier.address,
        "gstNumber": newSupplier.gstNumber,
        "companyName": newSupplier.companyName,
      });

      String encryptedBody = ApiService.encryptData(jsonData); // Encrypt the payload

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/Admin/supplier"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"data": encryptedBody}), // Send encrypted in 'data' key
      );

      setState(() => isLoading = false);

      final responseBody = jsonDecode(response.body);

      // If response contains encrypted 'data', decrypt and parse it
      if (responseBody.containsKey("data")) {
        final decryptedString = ApiService.decryptData(responseBody["data"]);
        final decryptedResponse = jsonDecode(decryptedString);

        if (response.statusCode == 200 || response.statusCode == 201) {
          utils.showCustomSnackbar('Supplier added successfully!', true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        } else {
          utils.showCustomSnackbar(decryptedResponse["message"] ?? 'Failed to add supplier', false);
        }
      } else {
        // Fallback for unencrypted response
        utils.showCustomSnackbar(responseBody["message"] ?? 'Failed to add supplier', false);
      }

      // Clear form fields
      nameController.clear();
      contactController.clear();
      emailController.clear();
      addressController.clear();
      gstController.clear();
      companyNameController.clear();
    } catch (error) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: $error', false);
      print('Error adding supplier: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.addSupplier,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    utils.buildTextField(
                      AppString.supplierName,
                      nameController,
                      textColor: AppColors.primaryWhite,
                      hintColor: Colors.grey,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Supplier Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    utils.buildTextField(
                      AppString.contact,
                      contactController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      textColor: AppColors.primaryWhite,
                      hintColor: Colors.grey,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Contact is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    utils.buildTextField(
                      AppString.email,
                      emailController,
                      textColor: AppColors.primaryWhite,
                      hintColor: Colors.grey,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },                    ),
                    const SizedBox(height: 16),
                    utils.buildTextField(
                      AppString.address,
                      addressController,
                      textColor: AppColors.primaryWhite,
                      hintColor: Colors.grey,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Address is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    utils.buildTextField(
                      AppString.gstNumber,
                      gstController,
                      maxLength: 15,
                      textColor: AppColors.primaryWhite,
                      hintColor: Colors.grey,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'GST Number is required';
                          //27ABCDE1234F1Z5
                        }
                        // final gstRegExp = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                        // if (!gstRegExp.hasMatch(value.trim().toUpperCase())) {
                        //   return 'Please enter a valid 15-character GST Number';
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    utils.buildTextField(
                      AppString.companyName,
                      companyNameController,
                      textColor: AppColors.primaryWhite,
                      hintColor: Colors.grey,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Company Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.primaryWhite,
                          )
                        : utils.PrimaryButton(
                            text: AppString.addSupplier,
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                addSupplier();
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
