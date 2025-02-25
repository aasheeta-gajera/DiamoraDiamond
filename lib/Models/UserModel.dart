class UserModel {
  String userId;
  String password;
  String email;
  String mobile;
  String city;
  String userType;
  String address;
  String companyName;
  String contactName;
  String idProof;
  String licenseCopy;
  String taxCertificate;
  String partnerCopy;
  List<Reference> references;

  UserModel({
    required this.userId,
    required this.password,
    required this.email,
    required this.mobile,
    required this.city,
    required this.userType,
    required this.address,
    required this.companyName,
    required this.contactName,
    required this.idProof,
    required this.licenseCopy,
    required this.taxCertificate,
    required this.partnerCopy,
    required this.references,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "password": password,
      "email": email,
      "mobile": mobile,
      "city": city,
      "userType": userType,
      "address": address,
      "company_name": companyName,
      "contact_name": contactName,
      "id_proof": idProof,
      "license_copy": licenseCopy,
      "tax_certificate": taxCertificate,
      "partner_copy": partnerCopy,
      "references": references.map((ref) => ref.toJson()).toList(),
    };
  }
}

class Reference {
  String name;
  String phone;

  Reference({required this.name, required this.phone});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
    };
  }
}
