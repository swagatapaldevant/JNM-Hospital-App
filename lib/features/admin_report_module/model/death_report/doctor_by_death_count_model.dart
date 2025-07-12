class DoctorByDeathCountModel {
  String? doctorName;
  int? totalCount;

  DoctorByDeathCountModel({this.doctorName, this.totalCount});

  DoctorByDeathCountModel.fromJson(Map<String, dynamic> json) {
    doctorName = json['doctor_name'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctor_name'] = this.doctorName;
    data['total_count'] = this.totalCount;
    return data;
  }
}