class OpdPatientReportDataModel {
  int? id;
  int? patientId;
  String? type;
  String? appointmentDate;
  String? patientName;
  String? phone;
  String? gender;
  int? dobYear;
  int? dobMonth;
  int? dobDay;
  String? doctorName;
  String? departmentName;
  String? creDate;

  OpdPatientReportDataModel(
      {this.id,
        this.patientId,
        this.type,
        this.appointmentDate,
        this.patientName,
        this.phone,
        this.gender,
        this.dobYear,
        this.dobMonth,
        this.dobDay,
        this.doctorName,
        this.departmentName,
        this.creDate});

  OpdPatientReportDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    type = json['type'];
    appointmentDate = json['appointment_date'];
    patientName = json['patient_name'];
    phone = json['phone'];
    gender = json['gender'];
    dobYear = json['dob_year'];
    dobMonth = json['dob_month'];
    dobDay = json['dob_day'];
    doctorName = json['doctor_name'];
    departmentName = json['department_name'];
    creDate = json['cre_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['patient_id'] = this.patientId;
    data['type'] = this.type;
    data['appointment_date'] = this.appointmentDate;
    data['patient_name'] = this.patientName;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['dob_year'] = this.dobYear;
    data['dob_month'] = this.dobMonth;
    data['dob_day'] = this.dobDay;
    data['doctor_name'] = this.doctorName;
    data['department_name'] = this.departmentName;
    data['cre_date'] = this.creDate;
    return data;
  }
}