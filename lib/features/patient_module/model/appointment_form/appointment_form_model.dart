class AppointmentFormData {
  final String? department;
  final String doctor;
  final DateTime appointmentDate;
  final String slotTime;
  final String? uhid;
  final String? mobileNo;
  final String name;
  final String gender;
  final int? year;
  final int? month;
  final String? day;
  final String? address;

  AppointmentFormData({
    this.department,
    required this.doctor,
    required this.appointmentDate,
    required this.slotTime,
    this.uhid,
    this.mobileNo,
    required this.name,
    required this.gender,
    this.year,
    this.month,
    this.day,
    this.address,
  });

  /// Convert Dart object → JSON
  Map<String, dynamic> toJson() {
    return {
      "department": department,
      "doctor": doctor,
      "appointmentDate": appointmentDate.toIso8601String(),
      "slotTime": slotTime,
      "uhid": uhid,
      "mobileNo": mobileNo,
      "name": name,
      "gender": gender,
      "year": year,
      "month": month,
      "day": day,
      "address": address,
    };
  }

  /// Convert JSON → Dart object
  factory AppointmentFormData.fromJson(Map<String, dynamic> json) {
    return AppointmentFormData(
      department: json["department"],
      doctor: json["doctor"] ?? "",
      appointmentDate: DateTime.tryParse(json["appointmentDate"] ?? "") ?? DateTime.now(),
      slotTime: json["slotTime"] ?? "",
      uhid: json["uhid"],
      mobileNo: json["mobileNo"],
      name: json["name"] ?? "",
      gender: json["gender"] ?? "",
      year: json["year"],
      month: json["month"],
      day: json["day"],
      address: json["address"],
    );
  }
}

