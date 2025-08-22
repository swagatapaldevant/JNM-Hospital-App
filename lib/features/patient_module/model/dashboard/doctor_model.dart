class DoctorModel {
    DoctorModel({
        required this.doctorId,
        required this.name,
        required this.details,
        required this.avilableTime1,
        required this.avilableTime,
        required this.inOutStatus,
        required this.inOutDetails,
        required this.color,
    });

    final int? doctorId;
    final String? name;
    final String? details;
    final String? avilableTime1;
    final String? avilableTime;
    final String? inOutStatus;
    final InOutDetails? inOutDetails;
    final String? color;

    factory DoctorModel.fromJson(Map<String, dynamic> json){ 
        return DoctorModel(
            doctorId: json["doctor_id"],
            name: json["name"],
            details: json["details"],
            avilableTime1: json["avilable_time1"],
            avilableTime: json["avilable_time"],
            inOutStatus: json["in_out_status"],
            inOutDetails: json["in_out_details"] == null ? null : InOutDetails.fromJson(json["in_out_details"]),
            color: json["color"],
        );
    }

    Map<String, dynamic> toJson() => {
        "doctor_id": doctorId,
        "name": name,
        "details": details,
        "avilable_time1": avilableTime1,
        "avilable_time": avilableTime,
        "in_out_status": inOutStatus,
        "in_out_details": inOutDetails?.toJson(),
        "color": color,
    };

}

class InOutDetails {
    InOutDetails({
        required this.id,
        required this.section,
        required this.sectionId,
        required this.doctorId,
        required this.patientId,
        required this.patientType,
        required this.date,
        required this.inTime,
        required this.outTime,
        required this.status,
        required this.isDelete,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final String? section;
    final int? sectionId;
    final int? doctorId;
    final int? patientId;
    final String? patientType;
    final DateTime? date;
    final dynamic inTime;
    final dynamic outTime;
    final int? status;
    final int? isDelete;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory InOutDetails.fromJson(Map<String, dynamic> json){ 
        return InOutDetails(
            id: json["id"],
            section: json["section"],
            sectionId: json["section_id"],
            doctorId: json["doctor_id"],
            patientId: json["patient_id"],
            patientType: json["patient_type"],
            date: DateTime.tryParse(json["date"] ?? ""),
            inTime: json["in_time"],
            outTime: json["out_time"],
            status: json["status"],
            isDelete: json["is_delete"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "section": section,
        "section_id": sectionId,
        "doctor_id": doctorId,
        "patient_id": patientId,
        "patient_type": patientType,
        "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2,'0')}",
        "in_time": inTime,
        "out_time": outTime,
        "status": status,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };

}
