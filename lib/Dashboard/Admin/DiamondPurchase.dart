
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';

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

  String? _selectedSupplier;
  String _supplierContact = "";
  String _itemCode = "";
  String _lotNumber = "";
  double measurementsMinValue = 4.0;
  double measurementsMaxValue = 11.0;
  double tablePercentageMinValue = 50.0;
  double tablePercentageMaxValue = 75.0;

  final List<Map<String, String>> suppliers = [
    {
      "supplier": "ABC Diamonds",
      "supplierContact": "+91 9876543210",
      "itemCode": "ABC123",
      "lotNumber": "LOT001",
    },
    {
      "supplier": "XYZ Gems",
      "supplierContact": "+91 9876543222",
      "itemCode": "XYZ567",
      "lotNumber": "LOT002",
    },
    {
      "supplier": "GemStar Ltd.",
      "supplierContact": "+1 212-555-7890",
      "itemCode": "GEM890",
      "lotNumber": "LOT003",
    },
    {
      "supplier": "Shine Bright Co.",
      "supplierContact": "+44 7896-123456",
      "itemCode": "SBC456",
      "lotNumber": "LOT004",
    },
    {
      "supplier": "Luxury Stones",
      "supplierContact": "+91 9876543333",
      "itemCode": "LS789",
      "lotNumber": "LOT005",
    },
    {
      "supplier": "Blue Diamond Traders",
      "supplierContact": "+1 305-555-6789",
      "itemCode": "BDT234",
      "lotNumber": "LOT006",
    },
    {
      "supplier": "Opulent Gems",
      "supplierContact": "+61 412-987-654",
      "itemCode": "OG567",
      "lotNumber": "LOT007",
    },
    {
      "supplier": "Regal Diamonds",
      "supplierContact": "+971 50-9876543",
      "itemCode": "RD890",
      "lotNumber": "LOT008",
    },
    {
      "supplier": "Elite Carats",
      "supplierContact": "+33 6-1234-5678",
      "itemCode": "EC345",
      "lotNumber": "LOT009",
    },
    {
      "supplier": "Royal Jewelers",
      "supplierContact": "+81 90-1234-5678",
      "itemCode": "RJ678",
      "lotNumber": "LOT010",
    },
  ];

  // RangeValues _priceRange = RangeValues(500, 3000);
  // RangeValues _caratRange = RangeValues(0.5, 5.0);
  // String _selectedClarity = "VS1";
  // String _selectedCut = "Excellent";
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
      _itemCode = "";
      _lotNumber = "";
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
        supplier: _selectedSupplier ?? "",
        supplierContact: _supplierContact ?? "",
        itemCode: _itemCode ?? "",
        lotNumber: _lotNumber ?? "",
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
        // Get.to(DiamondHomeAdmin());
      } else {
        utils.showCustomSnackbar('Failed to purchase diamond.', false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: $e', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          children: [
            // First part: Filters for diamond purchase
            Text(
              'PURCHASE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlack,
              ),
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Shape:", style: TextStyleHelper.bigBlack),
                GridView.builder(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Prevents scrolling inside a scrollable parent
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 items per row
                    crossAxisSpacing: 4, // Space between columns
                    mainAxisSpacing: 8, // Space between rows
                    childAspectRatio: 1, // Adjust the height-width ratio
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
                                  ? Colors.black
                                  : Colors.white, // Change background color
                          border: Border.all(
                            color: Colors.black,
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
                                      ? Colors.white
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

            // Wrap(
            //   spacing: 8.0,
            //   children: shapeImages.keys.map((shape) => ChoiceChip(
            //     checkmarkColor: Colors.white,
            //     backgroundColor: Colors.white,
            //     selectedColor: Colors.black,
            //     label: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Image.asset(
            //           shapeImages[shape]!, // Fetch image dynamically
            //           width: 24,
            //           height: 24,
            //         ),
            //         SizedBox(width: 5),
            //         Text(
            //           shape,
            //           style: TextStyle(
            //             color: _selectedShapes.contains(shape) ? Colors.white : Colors.black,
            //           ),
            //         ),
            //       ],
            //     ),
            //     selected: _selectedShapes.contains(shape),
            //     onSelected: (selected) {
            //       setState(() {
            //         if (selected) {
            //           _selectedShapes.add(shape);
            //         } else {
            //           _selectedShapes.remove(shape);
            //         }
            //       });
            //     },
            //     shape: RoundedRectangleBorder(
            //       side: BorderSide(color: Colors.black),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   )).toList(),
            // ),
            SizedBox(height: 10),

            utils.buildDropdownField(
              label: "Supplier",
              value: _selectedSupplier,
              items: suppliers,
              onChanged: (value) {
                setState(() {
                  _selectedSupplier = value;
                  final selectedSupplierData = suppliers.firstWhere(
                    (supplier) => supplier["supplier"] == value,
                  );
                  _supplierContact = selectedSupplierData["supplierContact"]!;
                  _itemCode = selectedSupplierData["itemCode"]!;
                  _lotNumber = selectedSupplierData["lotNumber"]!;
                });
              },
            ),

            utils.buildTextField(
              "Supplier Contact",
              TextEditingController(text: _supplierContact),
              textColor: AppColors.primaryBlack,
              hintColor: Colors.grey,
              readOnly: true,
            ),

            utils.buildTextField(
              "Item Code",
              TextEditingController(text: _itemCode),
              textColor: AppColors.primaryBlack,
              hintColor: Colors.grey,
              readOnly: true,
            ),
            utils.buildTextField(
              "Lot Number",
              TextEditingController(text: _lotNumber),
              textColor: AppColors.primaryBlack,
              hintColor: Colors.grey,
              readOnly: true,
            ),

            utils.buildTextField(
              "Invoice Number",
              invoiceNumberController,
              textColor: AppColors.primaryBlack,
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

            // _buildSlider(
            //   "Measurements",
            //   measurementsValue,
            //   0,
            //   100,
            //   List.generate(101, (index) => index.toString()),
            //   (value) {
            //     setState(() {
            //       measurementsValue = value;
            //     });
            //   },
            // ),
            // _buildSlider(
            //   "Table Percentage",
            //   tablePercentageValue,
            //   0,
            //   100,
            //   List.generate(101, (index) => "$index%"),
            //   (value) {
            //     setState(() {
            //       tablePercentageValue = value;
            //     });
            //   },
            // ),
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
              "Purchase Price",
              purchaseController,
              textColor: AppColors.primaryBlack,
              hintColor: Colors.grey,
            ),
            utils.buildTextField(
              "Total Diamond",
              totalDiamondsController,
              textColor: AppColors.primaryBlack,
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
                          backgroundColor: Colors.white,
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
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items:
          options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.primaryBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryWhite,
      activeTrackColor: AppColors.primaryBlack,
      inactiveTrackColor: AppColors.grey,
      inactiveThumbColor: AppColors.primaryBlack,
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
            color: Colors.black, // Black text
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
                          Colors.black54, // Slightly gray for better visibility
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
                  activeColor: Colors.black, // Black active color
                  inactiveColor: Colors.black12, // Light gray for inactive
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
                        color: Colors.white, // White background
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
        style: TextStyleHelper.mediumBlack,
      ),
      RangeSlider(
        values: RangeValues(
          min.clamp(rangeMin, rangeMax),
          max.clamp(rangeMin, rangeMax),
        ),
        min: rangeMin,
        max: rangeMax,
        activeColor: AppColors.primaryBlack,
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
