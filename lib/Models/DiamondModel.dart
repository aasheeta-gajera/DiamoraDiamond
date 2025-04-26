class Diamond {
  String? supplier;
  String? supplierContact;
  String? itemCode;
  String? lotNumber;
  String? shape;
  double? size;
  double? weightCarat;
  String? color;
  String? clarity;
  String? cut;
  String? polish;
  String? symmetry;
  String? fluorescence;
  String? certification;
  String? measurements;
  int? tablePercentage;
  int? purchasePrice;
  int? totalDiamonds;
  String? invoiceNumber;
  String? purchaseDate;
  String? status;
  String? storageLocation;
  bool? pairingAvailable;
  String? imageURL;
  String? remarks;
  int? totalPurchasePrice;

  Diamond(
      {
        this.supplier,
        this.supplierContact,
        this.itemCode,
        this.lotNumber,
        this.shape,
        this.size,
        this.weightCarat,
        this.color,
        this.clarity,
        this.cut,
        this.polish,
        this.symmetry,
        this.fluorescence,
        this.certification,
        this.measurements,
        this.tablePercentage,
        this.purchasePrice,
        this.totalDiamonds,
        this.invoiceNumber,
        this.purchaseDate,
        this.status,
        this.storageLocation,
        this.pairingAvailable,
        this.imageURL,
        this.remarks,
        this.totalPurchasePrice
      });

  Diamond.fromJson(Map<String, dynamic> json) {
    supplier = json['supplier'];
    supplierContact = json['supplierContact'];
    itemCode = json['itemCode'];
    lotNumber = json['lotNumber'];
    shape = json['shape'];
    size = (json['size'] as num?)?.toDouble();
    weightCarat = (json['weightCarat'] as num?)?.toDouble();
    color = json['color'];
    clarity = json['clarity'];
    cut = json['cut'];
    polish = json['polish'];
    symmetry = json['symmetry'];
    fluorescence = json['fluorescence'];
    certification = json['certification'];
    measurements = json['measurements'];
    tablePercentage = json['tablePercentage'];
    purchasePrice = (json['purchasePrice'] as num?)?.toInt();
    totalDiamonds = json['totalDiamonds'];
    invoiceNumber = json['invoiceNumber'];
    purchaseDate = json['purchaseDate'];
    status = json['status'];
    storageLocation = json['storageLocation'];
    pairingAvailable = json['pairingAvailable'];
    imageURL = json['imageURL'];
    remarks = json['remarks'];
    totalPurchasePrice = (json['totalPurchasePrice'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supplier'] = this.supplier;
    data['supplierContact'] = this.supplierContact;
    data['itemCode'] = this.itemCode;
    data['lotNumber'] = this.lotNumber;
    data['shape'] = this.shape;
    data['size'] = this.size;
    data['weightCarat'] = this.weightCarat;
    data['color'] = this.color;
    data['clarity'] = this.clarity;
    data['cut'] = this.cut;
    data['polish'] = this.polish;
    data['symmetry'] = this.symmetry;
    data['fluorescence'] = this.fluorescence;
    data['certification'] = this.certification;
    data['measurements'] = this.measurements;
    data['tablePercentage'] = this.tablePercentage;
    data['purchasePrice'] = this.purchasePrice;
    data['totalDiamonds'] = this.totalDiamonds;
    data['invoiceNumber'] = this.invoiceNumber;
    data['purchaseDate'] = this.purchaseDate;
    data['status'] = this.status;
    data['storageLocation'] = this.storageLocation;
    data['pairingAvailable'] = this.pairingAvailable;
    data['imageURL'] = this.imageURL;
    data['remarks'] = this.remarks;
    data['totalPurchasePrice'] = this.totalPurchasePrice;
    return data;
  }
}
