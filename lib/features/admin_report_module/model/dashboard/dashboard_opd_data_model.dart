class DashboardOpdDataModel {
  int? doctorId;
  String? doctorName;
  String? salutation;
  String? empid;
  int? visitCount;
  String? oldCount;
  String? newCount;

  DashboardOpdDataModel(
      {this.doctorId,
        this.doctorName,
        this.salutation,
        this.empid,
        this.visitCount,
        this.oldCount,
        this.newCount});

  DashboardOpdDataModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctor_id'];
    doctorName = json['doctor_name'];
    salutation = json['salutation'];
    empid = json['empid'];
    visitCount = json['visit_count'];
    oldCount = json['old_count'];
    newCount = json['new_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_id'] = this.doctorId;
    data['doctor_name'] = this.doctorName;
    data['salutation'] = this.salutation;
    data['empid'] = this.empid;
    data['visit_count'] = this.visitCount;
    data['old_count'] = this.oldCount;
    data['new_count'] = this.newCount;
    return data;
  }
}