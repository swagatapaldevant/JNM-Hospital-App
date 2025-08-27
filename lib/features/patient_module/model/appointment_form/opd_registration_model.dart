class OPDRegistrationModel {
  final String uhid;
  final String mobile;
  final String name;
  final String gender;
  final String dob;
  final String address;
  final String? department;
  final String? doctor;
  final String date;
  final String time;

  OPDRegistrationModel({
    required this.uhid,
    required this.mobile,
    required this.name,
    required this.gender,
    required this.dob,
    required this.address,
    this.department,
    this.doctor,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      "uhid": uhid,
      "mobile": mobile,
      "name": name,
      "gender": gender,
      "dob": dob,
      "address": address,
      "department": department,
      "doctor": doctor,
      "date": date,
      "time": time,
    };
  }


  factory OPDRegistrationModel.fromJson(Map<String, dynamic> json) {
    return OPDRegistrationModel(
      uhid: json["uhid"] ?? "",
      mobile: json["mobile"] ?? "",
      name: json["name"] ?? "",
      gender: json["gender"] ?? "",
      dob: json["dob"] ?? "",
      address: json["address"] ?? "",
      department: json["department"],
      doctor: json["doctor"],
      date: json["date"] ?? "",
      time: json["time"] ?? "",
    );
  }
}
