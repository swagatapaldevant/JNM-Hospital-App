class IpdPatientReportData {
  int? id;
  String? type;
  String? admissionDate;
  String? admissionType;
  String? patientName;
  String? phone;
  String? gender;
  int? dobYear;
  int? dobMonth;
  int? dobDay;
  String? guardianName;
  String? doctorName;
  String? departmentName;
  String? dischargeAt;
  String? wardName;
  String? bedName;
  String? tpaName;
  String? creDate;
  String? disDate;

  IpdPatientReportData(
      {this.id,
        this.type,
        this.admissionDate,
        this.admissionType,
        this.patientName,
        this.phone,
        this.gender,
        this.dobYear,
        this.dobMonth,
        this.dobDay,
        this.guardianName,
        this.doctorName,
        this.departmentName,
        this.dischargeAt,
        this.wardName,
        this.bedName,
        this.tpaName,
        this.creDate,
        this.disDate});

  IpdPatientReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    admissionDate = json['admission_date'];
    admissionType = json['admission_type'];
    patientName = json['patient_name'];
    phone = json['phone'];
    gender = json['gender'];
    dobYear = json['dob_year'];
    dobMonth = json['dob_month'];
    dobDay = json['dob_day'];
    guardianName = json['guardian_name'];
    doctorName = json['doctor_name'];
    departmentName = json['department_name'];
    dischargeAt = json['discharge_at'];
    wardName = json['ward_name'];
    bedName = json['bed_name'];
    tpaName = json['tpa_name'];
    creDate = json['cre_date'];
    disDate = json['dis_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['admission_date'] = this.admissionDate;
    data['admission_type'] = this.admissionType;
    data['patient_name'] = this.patientName;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['dob_year'] = this.dobYear;
    data['dob_month'] = this.dobMonth;
    data['dob_day'] = this.dobDay;
    data['guardian_name'] = this.guardianName;
    data['doctor_name'] = this.doctorName;
    data['department_name'] = this.departmentName;
    data['discharge_at'] = this.dischargeAt;
    data['ward_name'] = this.wardName;
    data['bed_name'] = this.bedName;
    data['tpa_name'] = this.tpaName;
    data['cre_date'] = this.creDate;
    data['dis_date'] = this.disDate;
    return data;
  }
}