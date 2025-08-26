class RateEnquiryModelResponse {
  final int id;
  final String chargeName;
  final double chargeAmount;

  RateEnquiryModelResponse({required this.id, required this.chargeName, required this.chargeAmount});

  factory RateEnquiryModelResponse.fromJson(Map<String, dynamic> json) {
    return RateEnquiryModelResponse(
      id: json['id'],
      chargeName: json['charge_name'],
      chargeAmount: double.tryParse(json['charge_amount'].toString()) ?? 0.0,
    );
  }
}

class RateEnquiryModel {
  RateEnquiryModelResponse? rateEnqModel;
  int? quantity;
  double? discountPercentage;
  double? finalAmount;

  RateEnquiryModel({required this.rateEnqModel, required this.quantity, this.discountPercentage, this.finalAmount});
}