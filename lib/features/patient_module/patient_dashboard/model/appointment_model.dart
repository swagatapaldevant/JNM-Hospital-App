class AppointmentModel {
    AppointmentModel({
        required this.id,
        required this.slotId,
        required this.departmentId,
        required this.doctorId,
        required this.appointmentDate,
        required this.bookingTime,
        required this.bookingBy,
        required this.appointmentTime,
        required this.uhid,
        required this.name,
        required this.phone,
        required this.gender,
        required this.dobYear,
        required this.dobMonth,
        required this.dobDay,
        required this.address,
        required this.isRegister,
        required this.isDelete,
        required this.createdAt,
        required this.updatedAt,
        required this.bs,
        required this.bookingName,
        required this.ds,
        required this.doctorName,
        required this.appDate,
    });

    final int? id;
    final int? slotId;
    final int? departmentId;
    final int? doctorId;
    final DateTime? appointmentDate;
    final DateTime? bookingTime;
    final int? bookingBy;
    final DateTime? appointmentTime;
    final String? uhid;
    final String? name;
    final String? phone;
    final String? gender;
    final int? dobYear;
    final int? dobMonth;
    final int? dobDay;
    final String? address;
    final bool? isRegister;
    final bool? isDelete;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final dynamic bs;
    final String? bookingName;
    final String? ds;
    final String? doctorName;
    final String? appDate;

    factory AppointmentModel.fromJson(Map<String, dynamic> json){ 
        return AppointmentModel(
            id: json["id"],
            slotId: json["slot_id"],
            departmentId: json["department_id"],
            doctorId: json["doctor_id"],
            appointmentDate: DateTime.tryParse(json["appointment_date"] ?? ""),
            bookingTime: DateTime.tryParse(json["booking_time"] ?? ""),
            bookingBy: json["booking_by"],
            appointmentTime: DateTime.tryParse(json["appointment_time"] ?? ""),
            uhid: json["uhid"],
            name: json["name"],
            phone: json["phone"],
            gender: json["gender"],
            dobYear: json["dob_year"],
            dobMonth: json["dob_month"],
            dobDay: json["dob_day"],
            address: json["address"],
            isRegister: json["is_register"],
            isDelete: json["is_delete"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
            bs: json["bs"],
            bookingName: json["booking_name"],
            ds: json["ds"],
            doctorName: json["doctor_name"],
            appDate: json["app_date"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "slot_id": slotId,
        "department_id": departmentId,
        "doctor_id": doctorId,
        "appointment_date": appointmentDate?.toIso8601String(),
        "booking_time": bookingTime?.toIso8601String(),
        "booking_by": bookingBy,
        "appointment_time": appointmentTime?.toIso8601String(),
        "uhid": uhid,
        "name": name,
        "phone": phone,
        "gender": gender,
        "dob_year": dobYear,
        "dob_month": dobMonth,
        "dob_day": dobDay,
        "address": address,
        "is_register": isRegister,
        "is_delete": isDelete,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "bs": bs,
        "booking_name": bookingName,
        "ds": ds,
        "doctor_name": doctorName,
        "app_date": appDate,
    };

}