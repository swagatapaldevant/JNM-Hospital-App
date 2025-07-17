class TpaListModel {
  int? id;
  String? tpaName;
  String? contactPersonName;
  String? contactPersonPhNo;
  int? status;
  String? createdAt;
  String? updatedAt;

  TpaListModel(
      {this.id,
        this.tpaName,
        this.contactPersonName,
        this.contactPersonPhNo,
        this.status,
        this.createdAt,
        this.updatedAt});

  TpaListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tpaName = json['tpa_name'];
    contactPersonName = json['contact_person_name'];
    contactPersonPhNo = json['contact_person_ph_no'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tpa_name'] = this.tpaName;
    data['contact_person_name'] = this.contactPersonName;
    data['contact_person_ph_no'] = this.contactPersonPhNo;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}