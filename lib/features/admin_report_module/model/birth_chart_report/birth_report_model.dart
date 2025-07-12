class BirthReportModel {
  int? id;
  String? name;
  String? gender;
  String? address;
  String? district;
  String? state;
  String? pinCode;
  String? guardianName;
  String? doctorName;
  String? dateOfBirth;
  String? weight;
  String? diagnosis;
  String? operation;
  String? deliveryMode;
  String? creDate;

  BirthReportModel(
      {this.id,
        this.name,
        this.gender,
        this.address,
        this.district,
        this.state,
        this.pinCode,
        this.guardianName,
        this.doctorName,
        this.dateOfBirth,
        this.weight,
        this.diagnosis,
        this.operation,
        this.deliveryMode,
        this.creDate});

  BirthReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    address = json['address'];
    district = json['district'];
    state = json['state'];
    pinCode = json['pin_code'];
    guardianName = json['guardian_name'];
    doctorName = json['doctor_name'];
    dateOfBirth = json['date_of_birth'];
    weight = json['weight'];
    diagnosis = json['diagnosis'];
    operation = json['operation'];
    deliveryMode = json['delivery_mode'];
    creDate = json['cre_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['district'] = this.district;
    data['state'] = this.state;
    data['pin_code'] = this.pinCode;
    data['guardian_name'] = this.guardianName;
    data['doctor_name'] = this.doctorName;
    data['date_of_birth'] = this.dateOfBirth;
    data['weight'] = this.weight;
    data['diagnosis'] = this.diagnosis;
    data['operation'] = this.operation;
    data['delivery_mode'] = this.deliveryMode;
    data['cre_date'] = this.creDate;
    return data;
  }
}