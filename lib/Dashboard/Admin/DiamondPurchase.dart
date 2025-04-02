
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';
import '../../Models/SupplierModel.dart';

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

  final List<String> shapes = [
    "Round",
    "Princess",
    "Cushion",
    "Oval",
    "Pear",
    "Marquise",
    "Heart",
    "Emerald",
    "Radiant",
    "Asscher",
    "Mitchell",
    "Other",
  ];
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
    setState(() => isLoading = true);

    try {
      Diamond diamond = Diamond(
        supplier: _selectedSupplier?.name??'',
        supplierContact: _supplierContact ?? "",
        itemCode: _companyName ?? "",
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
      );

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/purchaseDiamond"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(diamond.toJson()),
      );

      setState(() => isLoading = false);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        utils.showCustomSnackbar('Diamond purchased successfully!', true);
        resetForm();
      } else {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        String message = jsonData["message"];
        utils.showCustomSnackbar(message, false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: $e', false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers() async {
    try {
      final response = await http.get(Uri.parse("${ApiService.baseUrl}/getAllSuppliers"));

      print("Raw API Response: ${response.body}");  // Debugging Step

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Decoded API Response: $data");  // Debugging Step

        if (data is Map<String, dynamic> && data.containsKey("data")) {
          setState(() {
            suppliers = (data["data"] as List)
                .map((json) => Supplier.fromJson(json))
                .toList();

            for (var supplier in suppliers) {
              _supplierContact = suppliers.first.contact;
            }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColour,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text("PURCHASE",style: TextStyleHelper.mediumWhite,),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: AppColors.primaryColour,)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Shape ", style: TextStyleHelper.bigWhite),
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          NeverScrollableScrollPhysics(), // Prevents scrolling inside a scrollable parent
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 4,
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
                              color:
                                  isSelected
                                      ? AppColors.primaryWhite
                                      : AppColors.primaryColour, // Change background color
                              border: Border.all(
                                color: Colors.white,
                              ), // Black border
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  shapeImages[shape]!,
                                  width: 40,
                                  height: 40,
                                  color:
                                      isSelected
                                          ? AppColors.primaryColour
                                          : Colors.black, // Change image color
                                ),
                                SizedBox(height: 5),
                                Text(
                                  shape,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black, // Change text color
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

                SizedBox(height: 10),

                utils.buildDropdownField(
                  label: "Supplier",
                  value: _selectedSupplier?.companyName, // Ensure this exists in the items list
                  items: suppliers.map((supplier) => {
                    "supplier": supplier.companyName,  // Primary identifier
                    "supplierContact": supplier.contact,
                    "itemCode": supplier.gstNumber,
                    "lotNumber": supplier.email,
                  }).toList(), // Convert to List<Map<String, String>>
                  onChanged: (value) {
                    setState(() {
                      final selectedSupplierData = suppliers.firstWhere(
                            (supplier) => supplier.companyName == value,
                        orElse: () => Supplier.empty(), // Provide a default empty Supplier object
                      );

                      if (selectedSupplierData.companyName.isNotEmpty) {
                        _selectedSupplier = selectedSupplierData;
                        _supplierContact = selectedSupplierData.contact;
                        _companyName = selectedSupplierData.companyName;
                        _supplierEmail = selectedSupplierData.email;
                      }
                    });
                  },
                ),




                utils.buildTextField(
                  "Supplier Contact",
                  TextEditingController(text: _supplierContact),
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                  readOnly: true,
                ),

                utils.buildTextField(
                  "Supplier Email",
                  TextEditingController(text: _supplierEmail),
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                  readOnly: true,
                ),

                utils.buildTextField(
                  "company Name",
                  TextEditingController(text: _companyName),
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                  readOnly: true,
                ),

                utils.buildTextField(
                  "Invoice Number",
                  invoiceNumberController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),

                SizedBox(height: 10),

                _buildRangeSlider("Size (mm)", sizeMin, sizeMax, 3.0, 16.0, (
                  min,
                  max,
                ) {
                  setState(() {
                    sizeMin = min;
                    sizeMax = max;
                  });
                }),
                _buildRangeSlider(
                  "Weight (Carat)",
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
                _buildSlider(
                  "Clarity",
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
                _buildSlider("Cut", cutValue, 0, cutGrades.length - 1, cutGrades, (
                  value,
                ) {
                  setState(() {
                    cutValue = value;
                  });
                }),
                _buildSlider(
                  "Polish",
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
                _buildSlider(
                  "Symmetry",
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

                _buildSlider(
                  "Certifications",
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

                _buildSlider(
                  "Locations",
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

                _buildSlider(
                  "Fluorescence",
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

                _buildRangeSlider(
                  "Measurements",
                  measurementsMinValue,
                  measurementsMaxValue,
                  4.0, // Min diamond size in mm
                  11.0, // Max diamond size in mm
                  (start, end) {
                    setState(() {
                      measurementsMinValue = start;
                      measurementsMaxValue = end;
                    });
                  },
                ),

                _buildRangeSlider(
                  "Table Percentage",
                  tablePercentageMinValue,
                  tablePercentageMaxValue,
                  50.0, // Min table percentage
                  75.0, // Max table percentage
                  (start, end) {
                    setState(() {
                      tablePercentageMinValue = start;
                      tablePercentageMaxValue = end;
                    });
                  },
                ),

                utils.buildTextField(
                  "Total Diamond",
                  totalDiamondsController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: utils.buildTextField(
                      "Purchase Date",
                      TextEditingController(
                        text:
                            _selectedPurchaseDate != null
                                ? "${_selectedPurchaseDate!.year}-${_selectedPurchaseDate!.month.toString().padLeft(2, '0')}-${_selectedPurchaseDate!.day.toString().padLeft(2, '0')}"
                                : "",
                      ),
                      textColor: Colors.black, // Text color set to black
                      hintColor: Colors.grey, // Hint color remains grey
                      readOnly: true, // Non-editable field
                      icon: Icons.calendar_today, // Calendar icon
                    ),
                  ),
                ),

                SizedBox(height: 10),
                Text("Color:", style: TextStyle(fontSize: 18)),

                Wrap(
                  spacing: 8.0,
                  children:
                      colors
                          .map(
                            (color) => ChoiceChip(
                              checkmarkColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              selectedColor: Colors.black,
                              label: Text(
                                color,
                                style: TextStyle(
                                  color:
                                      _selectedColors.contains(color)
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
                                side: BorderSide(
                                  color: Colors.black,
                                ), // Keeps the border black
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                          .toList(),
                ),

                Divider(height: 30),

                _buildSwitch(
                  "Diamond Pair:",
                  isPairSelected,
                  (value) => setState(() => isPairSelected = value),
                ),

                Center(
                  child: utils.PrimaryButton(
                    text: "Purchase",
                    onPressed: () {
                      submitForm();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.primaryColour,
          fontWeight: FontWeight.bold,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryColour,
      activeTrackColor: AppColors.primaryWhite,
      inactiveTrackColor: AppColors.grey,
      inactiveThumbColor: AppColors.primaryWhite,
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
