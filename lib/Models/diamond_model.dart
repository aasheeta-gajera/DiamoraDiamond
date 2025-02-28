class Diamond {
  final String id;
  final String supplier;
  final String supplierContact;
  final String itemCode;
  final String lotNumber;
  final String shape;
  final double size;
  final double weightCarat;
  final String color;
  final String clarity;
  final String cut;
  final String polish;
  final String symmetry;
  final String fluorescence;
  final String certification;
  final String measurements;
  final int tablePercentage;
  final double purchasePrice;
  final double costPerCarat;
  final int totalDiamonds;
  final String purchaseDate;
  final String invoiceNumber;
  final String status;
  final String storageLocation;
  final bool pairingAvailable;
  final String imageUrl;
  final String remarks;

  Diamond({
    required this.id,
    required this.supplier,
    required this.supplierContact,
    required this.itemCode,
    required this.lotNumber,
    required this.shape,
    required this.size,
    required this.weightCarat,
    required this.color,
    required this.clarity,
    required this.cut,
    required this.polish,
    required this.symmetry,
    required this.fluorescence,
    required this.certification,
    required this.measurements,
    required this.tablePercentage,
    required this.purchasePrice,
    required this.costPerCarat,
    required this.totalDiamonds,
    required this.purchaseDate,
    required this.invoiceNumber,
    required this.status,
    required this.storageLocation,
    required this.pairingAvailable,
    required this.imageUrl,
    required this.remarks,
  });

  factory Diamond.fromJson(Map<String, dynamic> json) {
    return Diamond(
      id: json["_id"] ?? '',
      supplier: json["supplier"] ?? '',
      supplierContact: json["supplierContact"] ?? '',
      itemCode: json["itemCode"] ?? '',
      lotNumber: json["lotNumber"] ?? '',
      shape: json["shape"] ?? '',
      size: (json["size"] ?? 0).toDouble(),
      weightCarat: (json["weightCarat"] ?? 0).toDouble(),
      color: json["color"] ?? '',
      clarity: json["clarity"] ?? '',
      cut: json["cut"] ?? '',
      polish: json["polish"] ?? '',
      symmetry: json["symmetry"] ?? '',
      fluorescence: json["fluorescence"] ?? '',
      certification: json["certification"] ?? '',
      measurements: json["measurements"] ?? '',
      tablePercentage: json["tablePercentage"] ?? 0,
      purchasePrice: (json["purchasePrice"] ?? 0).toDouble(),
      costPerCarat: (json["costPerCarat"] ?? 0).toDouble(),
      totalDiamonds: json["totalDiamonds"] ?? 0,
      purchaseDate: json["purchaseDate"] ?? '',
      invoiceNumber: json["invoiceNumber"] ?? '',
      status: json["status"] ?? '',
      storageLocation: json["storageLocation"] ?? '',
      pairingAvailable: json["pairingAvailable"] ?? false,
      imageUrl: json["imageURL"] ?? '',
      remarks: json["remarks"] ?? '',
    );
  }
}
