class ReferralListModel {
  int? id;
  String? referralName;

  ReferralListModel({this.id, this.referralName});

  ReferralListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referralName = json['referral_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['referral_name'] = this.referralName;
    return data;
  }
}