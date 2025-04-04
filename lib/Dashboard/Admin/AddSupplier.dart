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
      id: "", // ID will be generated by the backend
      name: nameController.text,
      contact: contactController.text,
      email: emailController.text,
      address: addressController.text,
      gstNumber: gstController.text,
      companyName: companyNameController.text,
    );

    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/supplier"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": newSupplier.name,
          "contact": newSupplier.contact,
          "email": newSupplier.email,
          "address": newSupplier.address,
          "gstNumber": newSupplier.gstNumber,
          "companyName": newSupplier.companyName,
        }),
      );

      final responseData = jsonDecode(response.body);

      setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success Message
        utils.showCustomSnackbar('Supplier Added successfully!', true);

        // Clear form fields
        nameController.clear();
        contactController.clear();
        emailController.clear();
        addressController.clear();
        gstController.clear();
        companyNameController.clear();
      } else {
        utils.showCustomSnackbar('Failed to add supplier', false);
      }
    } catch (error) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: $error', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text(AppString.addSupplier, style: TextStyleHelper.mediumPrimaryColour),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
          Form(
            key: _formKey,
            child: Column(
              children: [
                utils.buildTextField(
                  AppString.supplierName,
                  nameController,
                  textColor: AppColors.primaryColour,
                  hintColor: Colors.grey,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Supplier Name is required";
                    }
                    return null;
                  },
                ),
                utils.buildTextField(
                  AppString.contact,
                  contactController,
                  textColor: AppColors.primaryColour,
                  hintColor: Colors.grey,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Contact is required";
                    }
                    return null;
                  },
                ),
                utils.buildTextField(
                 AppString.email,
                  emailController,
                  textColor: AppColors.primaryColour,
                  hintColor: Colors.grey,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                utils.buildTextField(
                  AppString.address,
                  addressController,
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
                  AppString.gstNumber,
                  gstController,
                  textColor: AppColors.primaryColour,
                  hintColor: Colors.grey,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "GST Number is required";
                    }
                    return null;
                  },
                ),
                utils.buildTextField(
                  AppString.companyName,
                  companyNameController,
                  textColor: AppColors.primaryColour,
                  hintColor: Colors.grey,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Company Name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator()
                    : utils.PrimaryButton(
                      text: AppString.addSupplier,
                      onPressed: () {
                        addSupplier();
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
