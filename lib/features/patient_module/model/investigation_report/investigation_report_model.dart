class InvestigationReportModel {
  String? field;
  String? reportStatus;
  List<String> multiValues = [];
  DateTime? fromDate;
  DateTime? toDate;
  final List<Map<int, String>> charges;

  InvestigationReportModel({
    this.field,
    this.reportStatus,
    this.multiValues = const [],
    this.fromDate,
    this.toDate,
    this.charges = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'reportStatus': reportStatus,
      'multiValues': multiValues,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'charges': charges,
    };
  }
}

class InvstReportResModel {
  int? id;
  int billNo;
  DateTime? billDate;
  String? patientName;
  String? age;
  String? gender;
  String? bed;
  String? doctorName;
  String? status;

  InvstReportResModel({
    required this.billNo,
    this.billDate,
    this.patientName,
    this.age,
    this.gender,
    this.bed,
    this.doctorName,
    this.id, 
    this.status
  });

  factory InvstReportResModel.fromJson(Map<String, dynamic> json) {
    return InvstReportResModel(
      billNo: json['billNo'],
      billDate: DateTime.parse(json['billDate']),
      patientName: json['patientName'],
      age: json['age'],
      gender: json['gender'],
      bed: json['bed'],
      doctorName: json['doctorName'],
      id: json['id'],
    );
  }

}
