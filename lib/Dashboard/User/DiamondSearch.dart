
import 'dart:convert';
import 'package:daimo/Library/ApiService.dart';
import 'package:daimo/Library/AppStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Library/AppColour.dart';
import '../../Library/AppImages.dart';
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
    final String apiUrl = "${ApiService.baseUrl}/getAllPurchasedDiamonds";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      ApiService().printLargeResponse(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          diamonds = (data["diamonds"] as List)
              .map((json) => Diamond.fromJson(json))
              .toList();
          filteredDiamonds = List.from(diamonds);
          isLoading = false;
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('${e}', false);
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
      backgroundColor: AppColors.primaryColour,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.primaryWhite,
        title: Text("Diamond Search", style: TextStyleHelper.mediumPrimaryColour),
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
          Column(
            children: [
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Shape Selection
                            Text("Shape", style: TextStyleHelper.bigWhite),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
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
                                      color: isSelected ? AppColors.primaryColour : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          shapeImages[shape]!,
                                          width: 40,
                                          height: 40,
                                          color: isSelected ? Colors.white : Colors.black,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          shape,
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            SizedBox(height: 16),
                            
                            // Size Range Slider
                            _buildRangeSlider(
                              "Size (mm)",
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
                            
                            // Weight Range Slider
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
                            
                            // Clarity Slider
                            _buildSlider(
                              "Clarity",
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
                            
                            // Cut Slider
                            _buildSlider(
                              "Cut",
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
                            
                            // Polish Slider
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
                            
                            // Symmetry Slider
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
                            
                            // Certification Slider
                            _buildSlider(
                              "Certification",
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
                            
                            // Location Slider
                            _buildSlider(
                              "Location",
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
                            
                            // Fluorescence Slider
                            _buildSlider(
                              "Fluorescence",
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
                            
                            // Measurements Range Slider
                            _buildRangeSlider(
                              "Measurements",
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
                            
                            // Table Percentage Range Slider
                            _buildRangeSlider(
                              "Table Percentage",
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
                            
                            // Color Selection
                            Text("Color:", style: TextStyleHelper.mediumWhite),
                            Wrap(
                              spacing: 8.0,
                              children: colors.map((color) => ChoiceChip(
                                checkmarkColor: Colors.white,
                                backgroundColor: Colors.transparent,
                                selectedColor: Colors.black,
                                label: Text(
                                  color,
                                  style: TextStyle(
                                    color: _selectedColors.contains(color) ? Colors.white : Colors.black,
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
                                  side: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              )).toList(),
                            ),
                            
                            SizedBox(height: 16),
                            
                            // Pairing Switch
                            SwitchListTile(
                              title: Text("Pairing Available", style: TextStyle(color: Colors.white)),
                              value: isPairSelected,
                              onChanged: (bool value) {
                                setState(() {
                                  isPairSelected = value;
                                });
                              },
                              activeColor: AppColors.primaryColour,
                            ),
                            
                            SizedBox(height: 16),
                            
                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: resetFilters,
                                  child: Text("Reset"),
                                  style: ElevatedButton.styleFrom(
                                    // primary: Colors.grey,
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
                                  child: Text("Search"),
                                  style: ElevatedButton.styleFrom(
                                    // primary: AppColors.primaryColour,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
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
            color: AppColors.primaryColour,
          ),
        ),
        SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryColour,
            inactiveTrackColor: AppColors.greyLight,
            thumbColor: AppColors.primaryColour,
            overlayColor: AppColors.primaryColour.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: options[value.toInt()],
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: options.map((option) => Text(
              option,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}