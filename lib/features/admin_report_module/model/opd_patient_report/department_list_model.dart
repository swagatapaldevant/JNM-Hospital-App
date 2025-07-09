class DepartmentListModel {
  int? id;
  String? departmentName;

  DepartmentListModel({this.id, this.departmentName});

  DepartmentListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentName = json['department_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department_name'] = this.departmentName;
    return data;
  }
}