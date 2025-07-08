class OpdPatientGraphDataModel {
  String? departmentName;
  String? newCount;
  String? oldCount;

  OpdPatientGraphDataModel({this.departmentName, this.newCount, this.oldCount});

  OpdPatientGraphDataModel.fromJson(Map<String, dynamic> json) {
    departmentName = json['department_name'];
    newCount = json['new_count'];
    oldCount = json['old_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department_name'] = this.departmentName;
    data['new_count'] = this.newCount;
    data['old_count'] = this.oldCount;
    return data;
  }
}