class SlotSelectionModel {
  int? id;
  String? doctorId;
  String? date;
  String? day;
  String? fromTime;
  String? toTime;
  String? timePerSlot;
  String? patientPerSlot;
  String? booked;
  String? isActive;
  String? isDelete;
  String? createdAt;
  String? updatedAt;

  SlotSelectionModel(
      {this.id,
      this.doctorId,
      this.date,
      this.day,
      this.fromTime,
      this.toTime,
      this.timePerSlot,
      this.patientPerSlot,
      this.booked,
      this.isActive,
      this.isDelete,
      this.createdAt,
      this.updatedAt});

  SlotSelectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    date = json['date'];
    day = json['day'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    timePerSlot = json['time_per_slot'];
    patientPerSlot = json['patient_per_slot'];
    booked = json['booked'];
    isActive = json['is_active'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor_id'] = this.doctorId;
    data['date'] = this.date;
    data['day'] = this.day;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['time_per_slot'] = this.timePerSlot;
    data['patient_per_slot'] = this.patientPerSlot;
    data['booked'] = this.booked;
    data['is_active'] = this.isActive;
    data['is_delete'] = this.isDelete;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  String formatTime() {
    if (fromTime != null && toTime != null) {
      return '$fromTime - $toTime';
    }
    return '';
  }
  
}