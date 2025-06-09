import 'dart:convert';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
import '../../Library/AppStrings.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/DiamondModel.dart';
import 'DiamondInventory.dart';

class DiamondSearch extends StatefulWidget {
  const DiamondSearch({super.key});

  @override
  _DiamondSearchState createState() => _DiamondSearchState();
}

class _DiamondSearchState extends State<DiamondSearch> {
  List<Diamond> diamonds = [];
  List<Diamond> filteredDiamonds = [];
  bool isLoading = true;
  
  // Search filters - matching DiamondPurchaseForm
  List<String> _selectedShapes = [];
  double sizeMin = 3.0, sizeMax = 16.0;
  double weightCaratMin = 0.25, weightCaratMax = 10.0;
  double clarityValue = 2.0;
  double cutValue = 1.0;
  double polishValue = 1.0;
  double symmetryValue = 1.0;
  double fluorescenceValue = 0.0;
  double measurementsMinValue = 4.0;
  double measurementsMaxValue = 11.0;
  double tablePercentageMinValue = 50.0;
  double tablePercentageMaxValue = 75.0;
  List<String> _selectedColors = [];
  double _selectedCertification = 1.0;
  double _selectedLocation = 1.0;
  bool isPairSelected = false;

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

  final List<String> clarities = [
    "FL", "IF", "VVS1", "VVS2", "VS1", "VS2", "SI1", "SI2", "I1", "I2", "I3"
  ];
  
  final List<String> cuts = [
    "Ideal", "Excellent", "Very Good", "Good", "Fair", "Poor"
  ];
  
  final List<String> colors = [
    "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
  ];
  
  final List<String> certifications = ["GIA", "IGI", "HRD"];
  
  final List<String> locations = ["Mumbai", "Surat", "New York"];
  
  final List<String> polishes = ["Excellent", "Very Good", "Good", "Fair"];
  
  final List<String> symmetries = ["Excellent", "Very Good", "Good", "Fair"];

  @override
  void initState() {
    super.initState();
    fetchDiamonds();
  }

  Future<void> fetchDiamonds() async {
    final String apiUrl = "${ApiService.baseUrl}/Admin/getAllPurchasedDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      ApiService().printLargeResponse(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> encryptedResponse = json.decode(response.body);

        if (encryptedResponse.containsKey("data")) {
          final decryptedString = ApiService.decryptData(encryptedResponse["data"]);
          final Map<String, dynamic> data = json.decode(decryptedString);

          setState(() {
            diamonds = (data["diamonds"] as List)
                .map((json) => Diamond.fromJson(json))
                .toList();
            filteredDiamonds = List.from(diamonds);
            isLoading = false;
          });
        } else {
          utils.showCustomSnackbar("Invalid response from server", false);
          setState(() => isLoading = false);
        }
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print(e);
      utils.showCustomSnackbar('Error: $e', false);
    }
  }

  void applyFilters() {
    setState(() {
      filteredDiamonds = diamonds.where((diamond) {
        // Shape filter
        if (_selectedShapes.isNotEmpty) {
          List<String> diamondShapes = diamond.shape?.split(",").map((s) => s.trim()).toList() ?? [];
          bool hasSelectedShape = false;
          for (String shape in _selectedShapes) {
            if (diamondShapes.contains(shape)) {
              hasSelectedShape = true;
              break;
            }
          }
          if (!hasSelectedShape) return false;
        }
        
        // Size filter
        if (diamond.size != null) {
          if (diamond.size! < sizeMin || diamond.size! > sizeMax) return false;
        }
        
        // Weight filter
        if (diamond.weightCarat != null) {
          if (diamond.weightCarat! < weightCaratMin || diamond.weightCarat! > weightCaratMax) return false;
        }
        
        // Clarity filter
        if (diamond.clarity != clarities[clarityValue.toInt()]) return false;
        
        // Cut filter
        if (diamond.cut != cuts[cutValue.toInt()]) return false;
        
        // Polish filter
        if (diamond.polish != polishes[polishValue.toInt()]) return false;
        
        // Symmetry filter
        if (diamond.symmetry != symmetries[symmetryValue.toInt()]) return false;
        
        // Color filter
        if (_selectedColors.isNotEmpty) {
          bool hasSelectedColor = false;
          for (String color in _selectedColors) {
            if (diamond.color == color) {
              hasSelectedColor = true;
              break;
            }
          }
          if (!hasSelectedColor) return false;
        }
        
        // Certification filter
        if (diamond.certification != certifications[_selectedCertification.toInt()]) return false;
        
        // Location filter
        if (diamond.storageLocation != locations[_selectedLocation.toInt()]) return false;
        
        // Fluorescence filter
        List<String> fluorescenceLevels = ["None", "Faint", "Medium", "Strong", "Very Strong"];
        if (diamond.fluorescence != fluorescenceLevels[fluorescenceValue.toInt()]) return false;
        
        // Measurements filter
        if (diamond.measurements != null) {
          double? measurements = double.tryParse(diamond.measurements!);
          if (measurements != null) {
            if (measurements < measurementsMinValue || measurements > measurementsMaxValue) return false;
          }
        }
        
        // Table percentage filter
        if (diamond.tablePercentage != null) {
          if (diamond.tablePercentage! < tablePercentageMinValue || diamond.tablePercentage! > tablePercentageMaxValue) return false;
        }
        
        // Pairing filter
        if (isPairSelected && diamond.pairingAvailable != true) return false;
        
        return true;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      _selectedShapes = [];
      sizeMin = 3.0;
      sizeMax = 16.0;
      weightCaratMin = 0.25;
      weightCaratMax = 10.0;
      clarityValue = 2.0;
      cutValue = 1.0;
      polishValue = 1.0;
      symmetryValue = 1.0;
      fluorescenceValue = 0.0;
      measurementsMinValue = 4.0;
      measurementsMaxValue = 11.0;
      tablePercentageMinValue = 50.0;
      tablePercentageMaxValue = 75.0;
      _selectedColors = [];
      _selectedCertification = 1.0;
      _selectedLocation = 1.0;
      isPairSelected = false;
      filteredDiamonds = List.from(diamonds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.diamondSearch,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.overlayLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
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
                          clarities.length - 1,
                          clarities,
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
                          cuts.length - 1,
                          cuts,
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
                          AppString.certification,
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
                          AppString.location,
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
                          4,
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
                          (min, max) {
                            setState(() {
                              measurementsMinValue = min;
                              measurementsMaxValue = max;
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
                          (min, max) {
                            setState(() {
                              tablePercentageMinValue = min;
                              tablePercentageMaxValue = max;
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
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Pairing Switch
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SwitchListTile(
                      title: Text(
                        AppString.pairingAvailable,
                        style: TextStyleHelper.mediumWhite.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: isPairSelected,
                      onChanged: (bool value) {
                        setState(() {
                          isPairSelected = value;
                        });
                      },
                      activeColor: AppColors.primaryColour,
                      activeTrackColor: AppColors.primaryWhite,
                      inactiveTrackColor: AppColors.grey,
                      inactiveThumbColor: AppColors.primaryWhite,
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: resetFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.overlayLight,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppString.reset,
                            style: TextStyleHelper.mediumWhite.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            applyFilters();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiamondInventory(
                                  diamonds: filteredDiamonds,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColour,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppString.search,
                            style: TextStyleHelper.mediumWhite.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
          style: TextStyleHelper.mediumWhite.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options.map((option) => Text(
              option,
              style: TextStyleHelper.mediumWhite.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )).toList(),
          ),
        ),
        const SizedBox(height: 15),
        LayoutBuilder(
          builder: (context, constraints) {
            double sliderWidth = constraints.maxWidth - 40;
            double positionLeft = ((value - min) / (max - min) * sliderWidth)
                .clamp(0, sliderWidth);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  activeColor: AppColors.primaryColour,
                  inactiveColor: Colors.white12,
                  onChanged: onChanged,
                ),
                Positioned(
                  top: -10,
                  left: positionLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        options[value.toInt()],
                        style: TextStyleHelper.mediumBlack.copyWith(
                          fontWeight: FontWeight.bold,
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
          style: TextStyleHelper.mediumWhite.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        RangeSlider(
          values: RangeValues(
            min.clamp(rangeMin, rangeMax),
            max.clamp(rangeMin, rangeMax),
          ),
          min: rangeMin,
          max: rangeMax,
          activeColor: AppColors.primaryColour,
          inactiveColor: Colors.white12,
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
}