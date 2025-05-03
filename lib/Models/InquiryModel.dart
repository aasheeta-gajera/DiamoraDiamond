class InquiryModel {
  final String id;
  final String userId;
  final String subject;
  final String message;
  final String diamondId;
  final String? diamondShape;
  final String? caratWeight;
  final String? color;
  final String? clarity;
  final String? certification;
  final String? response;
  final String? status;
  final String? respondedBy;

  InquiryModel({
    required this.id,
    required this.userId,
    required this.subject,
    required this.message,
    required this.diamondId,
    this.diamondShape,
    this.caratWeight,
    this.color,
    this.clarity,
    this.certification,
    this.response,
    this.status,
    this.respondedBy,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      diamondId: json['diamondId'] ?? '',
      diamondShape: json['diamondShape'],
      caratWeight: json['caratWeight'],
      color: json['color'],
      clarity: json['clarity'],
      certification: json['certification'],
      response: json['response'],
      status: json['status'],
      respondedBy: json['respondedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "subject": subject,
      "message": message,
      "diamondId": diamondId,
      "diamondShape": diamondShape,
      "caratWeight": caratWeight,
      "color": color,
      "clarity": clarity,
      "certification": certification,
      "response": response,
      "status": status,
      "respondedBy": respondedBy,
    };
  }
}
