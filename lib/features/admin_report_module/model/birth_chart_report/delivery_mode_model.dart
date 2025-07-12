class DeliveryModeModel {
  String? deliveryMode;
  int? totalCount;

  DeliveryModeModel({this.deliveryMode, this.totalCount});

  DeliveryModeModel.fromJson(Map<String, dynamic> json) {
    deliveryMode = json['delivery_mode'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivery_mode'] = this.deliveryMode;
    data['total_count'] = this.totalCount;
    return data;
  }
}