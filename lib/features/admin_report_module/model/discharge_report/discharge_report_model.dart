class DischargeReportModel {
  int? sectionId;
  String? admissionDate;
  String? dischargeDate;
  String? dischargeType;
  String? patientName;
  String? gender;
  int? patientId;
  String? uid;
  int? billId;
  String? admDate;
  String? disDate;
  String? billLink;

  DischargeReportModel(
      {this.sectionId,
        this.admissionDate,
        this.dischargeDate,
        this.dischargeType,
        this.patientName,
        this.gender,
        this.patientId,
        this.uid,
        this.billId,
        this.admDate,
        this.disDate,
        this.billLink});

  DischargeReportModel.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    admissionDate = json['admission_date'];
    dischargeDate = json['discharge_date'];
    dischargeType = json['discharge_type'];
    patientName = json['patient_name'];
    gender = json['gender'];
    patientId = json['patient_id'];
    uid = json['uid'];
    billId = json['bill_id'];
    admDate = json['adm_date'];
    disDate = json['dis_date'];
    billLink = json['bill_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section_id'] = this.sectionId;
    data['admission_date'] = this.admissionDate;
    data['discharge_date'] = this.dischargeDate;
    data['discharge_type'] = this.dischargeType;
    data['patient_name'] = this.patientName;
    data['gender'] = this.gender;
    data['patient_id'] = this.patientId;
    data['uid'] = this.uid;
    data['bill_id'] = this.billId;
    data['adm_date'] = this.admDate;
    data['dis_date'] = this.disDate;
    data['bill_link'] = this.billLink;
    return data;
  }
}