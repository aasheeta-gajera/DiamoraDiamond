class Supplier {
  final String id;
  final String name;
  final String contact;
  final String email;
  final String address;
  final String gstNumber;
  final String companyName;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    required this.email,
    required this.address,
    required this.gstNumber,
    required this.companyName,
  });

  // Factory method to create a Supplier object from JSON
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      contact: json['contact'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      companyName: json['companyName'] ?? '',
    );
  }

  // Provide an empty instance to prevent null errors
  factory Supplier.empty() {
    return Supplier(
      id: '',
      name: '',
      contact: '',
      email: '',
      address: '',
      gstNumber: '',
      companyName: '',
    );
  }

  @override
  String toString() {
    return 'Supplier(id: $id, name: $name, contact: $contact, email: $email, address: $address, gstNumber: $gstNumber, company: $companyName)';
  }
}
