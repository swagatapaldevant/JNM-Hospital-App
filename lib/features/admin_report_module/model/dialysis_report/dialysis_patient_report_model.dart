class DialysisPatientReportData {
  int? id;
  String? type;
  String? admissionDate;
  String? dialysisType;
  String? patientName;
  String? phone;
  String? gender;
  int? dobYear;
  int? dobMonth;
  int? dobDay;
  String? guardianName;
  String? doctorName;
  String? departmentName;
  String? wardName;
  String? bedName;
  String? tpaName;
  String? creDate;

  DialysisPatientReportData(
      {this.id,
        this.type,
        this.admissionDate,
        this.dialysisType,
        this.patientName,
        this.phone,
        this.gender,
        this.dobYear,
        this.dobMonth,
        this.dobDay,
        this.guardianName,
        this.doctorName,
        this.departmentName,
        this.wardName,
        this.bedName,
        this.tpaName,
        this.creDate});

  DialysisPatientReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    admissionDate = json['admission_date'];
    dialysisType = json['dialysis_type'];
    patientName = json['patient_name'];
    phone = json['phone'];
    gender = json['gender'];
    dobYear = json['dob_year'];
    dobMonth = json['dob_month'];
    dobDay = json['dob_day'];
    guardianName = json['guardian_name'];
    doctorName = json['doctor_name'];
    departmentName = json['department_name'];
    wardName = json['ward_name'];
    bedName = json['bed_name'];
    tpaName = json['tpa_name'];
    creDate = json['cre_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['admission_date'] = this.admissionDate;
    data['dialysis_type'] = this.dialysisType;
    data['patient_name'] = this.patientName;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['dob_year'] = this.dobYear;
    data['dob_month'] = this.dobMonth;
    data['dob_day'] = this.dobDay;
    data['guardian_name'] = this.guardianName;
    data['doctor_name'] = this.doctorName;
    data['department_name'] = this.departmentName;
    data['ward_name'] = this.wardName;
    data['bed_name'] = this.bedName;
    data['tpa_name'] = this.tpaName;
    data['cre_date'] = this.creDate;
    return data;
  }
}