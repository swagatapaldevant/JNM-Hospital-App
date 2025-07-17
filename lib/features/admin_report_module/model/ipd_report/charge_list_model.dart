class ChargeListModel {
  int? id;
  String? chargeName;

  ChargeListModel({this.id, this.chargeName});

  ChargeListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargeName = json['charge_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['charge_name'] = this.chargeName;
    return data;
  }
}