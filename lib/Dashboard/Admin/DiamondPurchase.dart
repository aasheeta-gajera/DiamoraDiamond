
import 'dart:async';

import 'package:daimo/Library/AppStrings.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';
import '../../Models/SupplierModel.dart';
import 'Inventory.dart';

class DiamondPurchaseForm extends StatefulWidget {
  @override
  _DiamondPurchaseFormState createState() => _DiamondPurchaseFormState();
}

class _DiamondPurchaseFormState extends State<DiamondPurchaseForm> {
  String? selectedShape;
  double sizeMin = 3.0, sizeMax = 16.0;
  double weightCaratMin = 0.25, weightCaratMax = 10.0;
  double clarityValue = 2.0;
  double cutValue = 1.0;

  double polishValue = 1.0;
  double symmetryValue = 1.0;

  double fluorescenceValue = 0.0;
  // double measurementsValue = 0.0;
  // double tablePercentageValue = 0.0;

  double purchasePriceValue = 0.0;
  double totalDiamondsValue = 0.0;

  String _supplierContact = "";

  List<Supplier> suppliers = [];
  Supplier? _selectedSupplier;
  String _companyName = "";
  String _supplierEmail = "";
  String supplierGst = "";
  String _supplierName = "";
  double measurementsMinValue = 4.0;
  double measurementsMaxValue = 11.0;
  double tablePercentageMinValue = 50.0;
  double tablePercentageMaxValue = 75.0;

  List<String> _selectedShapes = [];

  final Map<String, String> shapeImages = {
    "Round": "Assets/Images/Round.png",
    "Princess": "Assets/Images/Round.png",
    "Emerald": "Assets/Images/emerald.png",
    "Asscher": "Assets/Images/Round.png",
    "Marquise": "Assets/Images/Marquise.png",
    "Oval": "Assets/Images/Oval.png",
    "Pear": "Assets/Images/Pear.png",
    "Heart": "Assets/Images/Heart.png",
    "Cushion": "Assets/Images/Cushion.png",
    "Radiant": "Assets/Images/Round.png",
  };

  List<String> _selectedColors = [];
  String _selectedColor = "D";

  double _selectedCertification = 1.0;
  double _selectedLocation = 1.0;
  bool isPairSelected = false;
  DateTime? _selectedPurchaseDate;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedPurchaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedPurchaseDate) {
      setState(() {
        _selectedPurchaseDate = pickedDate;
      });
    }
  }

  // Selection variables for the second part of the screen
  String? selectedCertification,
      selectedLocation,
      shape,
      color,
      clarity,
      shade,
      cut,
      polish,
      symmetry,
      lab;

  // final List<String> shapes = [
  //   "Round",
  //   "Princess",
  //   "Cushion",
  //   "Oval",
  //   "Pear",
  //   "Marquise",
  //   "Heart",
  //   "Emerald",
  //   "Radiant",
  //   "Asscher",
  //   "Mitchell",
  //   "Other",
  // ];
  final List<String> clarities = [
    "FL",
    "IF",
    "VVS1",
    "VVS2",
    "VS1",
    "VS2",
    "SI1",
    "SI2",
    "I1",
    "I2",
    "I3",
  ];
  final List<String> cuts = [
    "Ideal",
    "Excellent",
    "Very Good",
    "Good",
    "Fair",
    "Poor",
  ];
  final List<String> colors = [
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
  ];
  final List<String> symmetries = ["Excellent", "Very Good", "Good", "Fair"];
  final List<String> certifications = ["GIA", "IGI", "HRD"];
  final List<String> locations = ["Mumbai", "Surat", "New York"];
  final List<String> polishes = ["Excellent", "Very Good", "Good", "Fair"];

  final List<String> clarityLevels = [
    "SI2",
    "SI1",
    "VS2",
    "VS1",
    "VVS2",
    "VVS1",
    "IF",
    "FL",
  ];
  final List<String> cutGrades = ["Good", "Very Good", "Ideal", "Astor Ideal"];

  final TextEditingController supplierController = TextEditingController();
  final TextEditingController supplierContactController =
  TextEditingController();
  final TextEditingController lotNumberController = TextEditingController();
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController purchaseController = TextEditingController();
  final TextEditingController totalDiamondsController = TextEditingController();

  void resetForm() {
    setState(() {
      _selectedSupplier = null;
      _supplierContact = "";
      _companyName = "";
      _supplierName = "";
      supplierGst = "";
      _supplierEmail = "";
      _selectedShapes = [];
      sizeMin = 0.0;
      weightCaratMin = 0.0;
      _selectedColors = [];
      clarityValue = 0.0;
      cutValue = 0.0;
      polishValue = 0.0;
      symmetryValue = 0.0;
      fluorescenceValue = 0.0;
      _selectedCertification = 0.0;
      tablePercentageMinValue = 0.0;
      measurementsMinValue = 0;
      purchaseController.clear();
      totalDiamondsController.clear();
      invoiceNumberController.clear();
      _selectedPurchaseDate = null;
      _selectedLocation = 0.0;
      isPairSelected = false;
    });
  }

  bool isLoading = false;

  Future submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    try {
      Diamond diamond = Diamond(
        supplier: _supplierName.toString() ?? '',
        supplierContact: _supplierContact ?? "",
        itemCode: supplierGst ?? "",
        lotNumber: _supplierEmail ?? "",
        shape: _selectedShapes.isNotEmpty ? _selectedShapes.join(", ") : "",
        size: sizeMin,
        weightCarat: weightCaratMin,
        color: _selectedColors.isNotEmpty ? _selectedColors.join(", ") : "",
        clarity: clarityValue.toString(),
        cut: cutValue.toString(),
        polish: polishValue.toString(),
        symmetry: symmetryValue.toString(),
        fluorescence: fluorescenceValue.toString(),
        certification: _selectedCertification.toString(),
        measurements: measurementsMinValue.toString(),
        tablePercentage: tablePercentageMinValue.toInt(),
        purchasePrice: int.tryParse(purchaseController.text) ?? 0,
        totalDiamonds: int.tryParse(totalDiamondsController.text) ?? 0,
        invoiceNumber: invoiceNumberController.text,
        purchaseDate: _selectedPurchaseDate?.toIso8601String() ?? "",
        status: "In Stock",
        storageLocation: _selectedLocation.toString(),
        pairingAvailable: isPairSelected,
        imageURL: "",
        remarks: "",
        paymentStatus: "Pending",  // <-- REQUIRED!
        paymentMethod: "Credit Card",
        transactionId: "TXN001",
        paymentDate: DateTime.now()
      );

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/Admin/purchaseDiamond"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(diamond.toJson()),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        utils.showCustomSnackbar('Diamond purchased successfully!', true);
        resetForm();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Inventory()));
      } else {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        String message = jsonData["message"];
        utils.showCustomSnackbar(message, false);
        print(message);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: $e', false);
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    try {
      final response = await http.get(Uri.parse("${ApiService.baseUrl}/Admin/getAllSuppliers"));

      print("Raw API Response: ${response.body}");  // Debugging Step

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Decoded API Response: $data");  // Debugging Step

        if (data is Map<String, dynamic> && data.containsKey("data")) {
          setState(() {
            suppliers = (data["data"] as List)
                .map((json) => Supplier.fromJson(json))
                .toList();

            // for (var supplier in suppliers) {
            //   _supplierContact = suppliers.first.contact;
            // }
          });
        }
        else {
          print("Unexpected API format: $data");  // Debugging Output
        }
      } else {
        print("API Error: ${response.statusCode}");
        throw Exception("Failed to load suppliers");
      }
    } catch (error) {
      print("Error fetching suppliers: $error");
    }
  }
  String? validateInvoiceNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invoice Number is required';
    }
    if (value.length != 10) {
      return 'Invoice Number must be 10 digits long';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Invoice Number must contain only digits';
    }
    return null;
  }

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.purchase,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Shape Selection
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.shape,
                          style: TextStyleHelper.mediumWhite.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: shapeImages.length,
                          itemBuilder: (context, index) {
                            String shape = shapeImages.keys.elementAt(index);
                            bool isSelected = _selectedShapes.contains(shape);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedShapes.remove(shape);
                                  } else {
                                    _selectedShapes.add(shape);
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.transparent
                                      : AppColors.secondaryColour,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.backgroundBlack
                                        : AppColors.primaryWhite,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                // padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      shapeImages[shape]!,
                                      width: 40,
                                      height: 40,
                                      color: isSelected
                                          ? AppColors.backgroundBlack
                                          : Colors.white,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      shape,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Supplier Selection
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: utils.buildDropdownField(
                      label: "Company",
                      value: _selectedSupplier?.companyName,
                      items: suppliers.map((supplier) => {
                        "supplier": supplier.companyName,
                        "supplierContact": supplier.contact,
                        "itemCode": supplier.gstNumber,
                        "lotNumber": supplier.email,
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          final selectedSupplierData = suppliers.firstWhere(
                                (supplier) => supplier.companyName == value,
                            // orElse: () => Supplier.empty(),
                          );

                          if (selectedSupplierData.companyName.isNotEmpty) {
                            _selectedSupplier = selectedSupplierData;
                            _supplierName = selectedSupplierData.name;
                            _supplierContact = selectedSupplierData.contact;
                            _companyName = selectedSupplierData.companyName;
                            _supplierEmail = selectedSupplierData.email;
                              supplierGst = selectedSupplierData.gstNumber;
                          }
                        });
                      },
                    ),
                  ),

                  // Supplier Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        utils.buildTextField(
                          AppString.supplier,
                          TextEditingController(text: _supplierName),
                          textColor: AppColors.primaryWhite,
                          hintColor: Colors.grey,
                          readOnly: true,
                        ),
                        utils.buildTextField(
                          AppString.supplierContact,
                          TextEditingController(text: _supplierContact),
                          textColor: AppColors.primaryWhite,
                          hintColor: Colors.grey,
                          readOnly: true,
                        ),
                        utils.buildTextField(
                          AppString.supplierEmail,
                          TextEditingController(text: _supplierEmail),
                          textColor: AppColors.primaryWhite,
                          hintColor: Colors.grey,
                          readOnly: true,
                        ),
                        utils.buildTextField(
                          AppString.invoiceNumber,
                          invoiceNumberController,
                          textColor: AppColors.primaryWhite,
                          hintColor: Colors.grey,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          validator: validateInvoiceNumber,
                        ),
                      ],
                    ),
                  ),

                  // Diamond Specifications
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRangeSlider(
                          AppString.size,
                          sizeMin,
                          sizeMax,
                          3.0,
                          16.0,
                              (min, max) {
                            setState(() {
                              sizeMin = min;
                              sizeMax = max;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildRangeSlider(
                          AppString.weight,
                          weightCaratMin,
                          weightCaratMax,
                          0.25,
                          10.0,
                              (min, max) {
                            setState(() {
                              weightCaratMin = min;
                              weightCaratMax = max;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSlider(
                          AppString.clarity,
                          clarityValue,
                          0,
                          clarityLevels.length - 1,
                          clarityLevels,
                              (value) {
                            setState(() {
                              clarityValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSlider(
                          AppString.cut,
                          cutValue,
                          0,
                          cutGrades.length - 1,
                          cutGrades,
                              (value) {
                            setState(() {
                              cutValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSlider(
                          AppString.polish,
                          polishValue,
                          0,
                          polishes.length - 1,
                          polishes,
                              (value) {
                            setState(() {
                              polishValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSlider(
                          AppString.symmetry,
                          symmetryValue,
                          0,
                          symmetries.length - 1,
                          symmetries,
                              (value) {
                            setState(() {
                              symmetryValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSlider(
                          AppString.certifications,
                          _selectedCertification,
                          0,
                          certifications.length - 1,
                          certifications,
                              (value) {
                            setState(() {
                              _selectedCertification = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSlider(
                          AppString.locations,
                          _selectedLocation,
                          0,
                          locations.length - 1,
                          locations,
                              (value) {
                            setState(() {
                              _selectedLocation = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSlider(
                          AppString.fluorescence,
                          fluorescenceValue,
                          0,
                          5,
                          ["None", "Faint", "Medium", "Strong", "Very Strong"],
                              (value) {
                            setState(() {
                              fluorescenceValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildRangeSlider(
                          AppString.measurements,
                          measurementsMinValue,
                          measurementsMaxValue,
                          4.0,
                          11.0,
                              (start, end) {
                            setState(() {
                              measurementsMinValue = start;
                              measurementsMaxValue = end;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildRangeSlider(
                          AppString.tablePercentage,
                          tablePercentageMinValue,
                          tablePercentageMaxValue,
                          50.0,
                          75.0,
                              (start, end) {
                            setState(() {
                              tablePercentageMinValue = start;
                              tablePercentageMaxValue = end;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Color Selection
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.color,
                          style: TextStyleHelper.mediumWhite.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8.0,
                          children: colors.map((color) => ChoiceChip(
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.black,
                            label: Text(
                              color,
                              style: TextStyle(
                                color: _selectedColors.contains(color)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            selected: _selectedColors.contains(color),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedColors.add(color);
                                } else {
                                  _selectedColors.remove(color);
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Additional Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        utils.buildTextField(
                          AppString.totalDiamond,
                          totalDiamondsController,
                          textColor: AppColors.primaryWhite,
                          hintColor: Colors.grey,
                          keyboardType: TextInputType.number
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: utils.buildTextField(
                              AppString.purchaseDate,
                              TextEditingController(
                                text: _selectedPurchaseDate != null
                                    ? "${_selectedPurchaseDate!.year}-${_selectedPurchaseDate!.month.toString().padLeft(2, '0')}-${_selectedPurchaseDate!.day.toString().padLeft(2, '0')}"
                                    : "",
                              ),
                              textColor: Colors.black,
                              hintColor: Colors.grey,
                              readOnly: true,
                              icon: Icons.calendar_today,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: utils.PrimaryButton(
                        text: AppString.purchase,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitForm();
                          }

                        },
                      ),
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

  Widget _buildSlider(
      String label,
      double value,
      double min,
      double max,
      List<String> options,
      Function(double) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColour, // Black text
          ),
        ),
        SizedBox(height: 8),

        // Gray-colored option labels above the slider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
            options.map((option) {
              return Text(
                option,
                style: TextStyle(
                  fontSize: 12,
                  color:
                  Colors.white, // Slightly gray for better visibility
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 15), // Add space for tooltip to avoid cutting

        LayoutBuilder(
          builder: (context, constraints) {
            double sliderWidth = constraints.maxWidth - 40; // Avoid overflow
            double positionLeft = ((value - min) / (max - min) * sliderWidth)
                .clamp(0, sliderWidth);

            return Stack(
              clipBehavior: Clip.none, // Allow overflow
              children: [
                // Slider Widget
                Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  activeColor: AppColors.primaryColour, // Black active color
                  inactiveColor: Colors.white12, // Light gray for inactive
                  onChanged: (newValue) {
                    onChanged(newValue);
                  },
                ),

                // Value Tooltip
                Positioned(
                  top: -10, // Increase this to prevent the cut-off
                  left: positionLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey, // White background
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ], // Subtle shadow
                      ),
                      child: Text(
                        options[value.toInt()],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Black text
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

Widget _buildRangeSlider(
    String label,
    double min,
    double max,
    double rangeMin,
    double rangeMax,
    Function(double, double) onChanged,
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label: ${min.toStringAsFixed(2)} - ${max.toStringAsFixed(2)}",
        style: TextStyleHelper.mediumWhite,
      ),
      RangeSlider(
        values: RangeValues(
          min.clamp(rangeMin, rangeMax),
          max.clamp(rangeMin, rangeMax),
        ),
        min: rangeMin,
        max: rangeMax,
        activeColor: AppColors.primaryColour,
        inactiveColor: AppColors.greyLight,
        divisions: 10,
        labels: RangeLabels(
          min.clamp(rangeMin, rangeMax).toStringAsFixed(2),
          max.clamp(rangeMin, rangeMax).toStringAsFixed(2),
        ),
        onChanged: (values) {
          onChanged(
            values.start.clamp(rangeMin, rangeMax),
            values.end.clamp(rangeMin, rangeMax),
          );
        },
      ),
    ],
  );
}
