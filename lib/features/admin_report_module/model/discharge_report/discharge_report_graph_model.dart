class DischargeReportGraphModel {
  String? dischargeType;
  int? totalCount;

  DischargeReportGraphModel({this.dischargeType, this.totalCount});

  DischargeReportGraphModel.fromJson(Map<String, dynamic> json) {
    dischargeType = json['discharge_type'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discharge_type'] = this.dischargeType;
    data['total_count'] = this.totalCount;
    return data;
  }
}