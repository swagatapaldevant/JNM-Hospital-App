class RateEnquiryModelResponse {
  final String id;
  final String name;
  final double rate;

  RateEnquiryModelResponse({required this.id, required this.name, required this.rate});
}

class RateEnquiryModel {
  RateEnquiryModelResponse? rateEnqModel;
  int? quantity;
  double? discountPercentage;
  double? finalAmount;

  RateEnquiryModel({required this.rateEnqModel, required this.quantity, this.discountPercentage, this.finalAmount});
}