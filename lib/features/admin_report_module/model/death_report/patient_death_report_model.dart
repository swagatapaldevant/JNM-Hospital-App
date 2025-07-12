class PatientDeathReportModel {
  String? dischargeDate;
  String? dischargeType;
  String? patientName;
  String? gender;
  String? admissionDate;
  String? doctorName;
  int? patientId;
  String? admDate;
  String? disDate;

  PatientDeathReportModel(
      {this.dischargeDate,
        this.dischargeType,
        this.patientName,
        this.gender,
        this.admissionDate,
        this.doctorName,
        this.patientId,
        this.admDate,
        this.disDate});

  PatientDeathReportModel.fromJson(Map<String, dynamic> json) {
    dischargeDate = json['discharge_date'];
    dischargeType = json['discharge_type'];
    patientName = json['patient_name'];
    gender = json['gender'];
    admissionDate = json['admission_date'];
    doctorName = json['doctor_name'];
    patientId = json['patient_id'];
    admDate = json['adm_date'];
    disDate = json['dis_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discharge_date'] = this.dischargeDate;
    data['discharge_type'] = this.dischargeType;
    data['patient_name'] = this.patientName;
    data['gender'] = this.gender;
    data['admission_date'] = this.admissionDate;
    data['doctor_name'] = this.doctorName;
    data['patient_id'] = this.patientId;
    data['adm_date'] = this.admDate;
    data['dis_date'] = this.disDate;
    return data;
  }
}