class PatientStatisticsModel {
  int? totalPatient;
  int? newPatient;
  int? oldPatient;
  String? income;

  PatientStatisticsModel(
      {this.totalPatient, this.newPatient, this.oldPatient, this.income});

  PatientStatisticsModel.fromJson(Map<String, dynamic> json) {
    totalPatient = json['total_patient'];
    newPatient = json['new_patient'];
    oldPatient = json['old_patient'];
    income = json['income'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_patient'] = this.totalPatient;
    data['new_patient'] = this.newPatient;
    data['old_patient'] = this.oldPatient;
    data['income'] = this.income;
    return data;
  }
}