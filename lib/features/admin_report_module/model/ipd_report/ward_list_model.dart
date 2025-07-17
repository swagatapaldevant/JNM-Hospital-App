class WardListModel {
  int? id;
  String? wardName;
  int? status;
  String? createdAt;
  String? updatedAt;

  WardListModel(
      {this.id, this.wardName, this.status, this.createdAt, this.updatedAt});

  WardListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wardName = json['ward_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ward_name'] = this.wardName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}