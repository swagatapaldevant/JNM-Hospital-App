class SectionListModel {
  int? id;
  String? chargesSectionName;
  bool? status;
  String? createdAt;
  String? updatedAt;

  SectionListModel(
      {this.id,
        this.chargesSectionName,
        this.status,
        this.createdAt,
        this.updatedAt});

  SectionListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargesSectionName = json['charges_section_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['charges_section_name'] = this.chargesSectionName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}