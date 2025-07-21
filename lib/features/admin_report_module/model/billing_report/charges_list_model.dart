class ChargesListModel {
  int? id;
  String? chargeName;

  ChargesListModel({this.id, this.chargeName});

  ChargesListModel.fromJson(Map<String, dynamic> json) {
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