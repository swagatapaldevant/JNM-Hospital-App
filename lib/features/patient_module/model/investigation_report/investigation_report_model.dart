class ReadyReportFilter {
  String? field;
  String? reportStatus;
  // List<String> multiValues = [];
  final DateTime? fromDate;
  final DateTime? toDate;
  // final List<Map<int, String>> charges;
  final String? fieldValue; 

  ReadyReportFilter({
    this.field,
    this.reportStatus,
    // this.multiValues = const [], 
    this.fromDate,
    this.toDate,
    // this.charges = const [],
    this.fieldValue
  });

  Map<String, String?> toJson() {
    return {
      'field_name': field,
      'reportStatus': reportStatus,
      // 'multiValues': multiValues,
      'from_date': fromDate?.toIso8601String(),
      'to_date': toDate?.toIso8601String(),
      'field_value': fieldValue,
    };
  }
}

// {
// 	"from_date" : "2023-08-12",
// 	"to_date" : "2025-08-12",
// 	"status_value" : '3-4',
// 	"field_name" : "",
// 	"field_value" : ""
// }

class InvstReportResModel {
    InvstReportResModel({
        required this.id,
        required this.billId,
        required this.uid,
        required this.billCreatedDate,
        required this.patientName,
        required this.patientId,
        required this.phone,
        required this.gender,
        required this.dobYear,
        required this.dobMonth,
        required this.dobDay,
        required this.referralName,
        required this.doctorName,
        required this.section,
        required this.sectionId,
        required this.bedName,
    });

    final int? id;
    final int? billId;
    final String? uid;
    final DateTime? billCreatedDate;
    final String? patientName;
    final int? patientId;
    final String? phone;
    final String? gender;
    final int? dobYear;
    final int? dobMonth;
    final int? dobDay;
    final String? referralName;
    final dynamic doctorName;
    final String? section;
    final int? sectionId;
    final dynamic bedName;

    factory InvstReportResModel.fromJson(Map<String, dynamic> json){ 
        return InvstReportResModel(
            id: json["id"],
            billId: json["bill_id"],
            uid: json["uid"],
            billCreatedDate: DateTime.tryParse(json["bill_created_date"] ?? ""),
            patientName: json["patient_name"],
            patientId: json["patient_id"],
            phone: json["phone"],
            gender: json["gender"],
            dobYear: json["dob_year"],
            dobMonth: json["dob_month"],
            dobDay: json["dob_day"],
            referralName: json["referral_name"],
            doctorName: json["doctor_name"],
            section: json["section"],
            sectionId: json["section_id"],
            bedName: json["bed_name"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "bill_id": billId,
        "uid": uid,
        "bill_created_date": billCreatedDate?.toIso8601String(),
        "patient_name": patientName,
        "patient_id": patientId,
        "phone": phone,
        "gender": gender,
        "dob_year": dobYear,
        "dob_month": dobMonth,
        "dob_day": dobDay,
        "referral_name": referralName,
        "doctor_name": doctorName,
        "section": section,
        "section_id": sectionId,
        "bed_name": bedName,
    };

}

