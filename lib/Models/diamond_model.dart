class Diamond {
  final String id, supplier, itemCode, shape, color, clarity, cut, certification, status, imageURL;
  final double weightCarat, purchasePrice;

  Diamond({
    required this.id,
    required this.supplier,
    required this.itemCode,
    required this.shape,
    required this.color,
    required this.clarity,
    required this.cut,
    required this.certification,
    required this.status,
    required this.imageURL,
    required this.weightCarat,
    required this.purchasePrice,
  });

  /// **Convert JSON to Diamond Object**
  factory Diamond.fromJson(Map<String, dynamic> json) {
    return Diamond(
      id: json["_id"],
      supplier: json["supplier"],
      itemCode: json["itemCode"],
      shape: json["shape"],
      color: json["color"],
      clarity: json["clarity"],
      cut: json["cut"],
      certification: json["certification"],
      status: json["status"],
      imageURL: json["imageURL"],
      weightCarat: (json["weightCarat"] as num).toDouble(),
      purchasePrice: (json["purchasePrice"] as num).toDouble(),
    );
  }
}
