class AppointmentModel {
  final int id;
  final int? slotId;
  final int? departmentId;
  final int? doctorId;
  final DateTime? appointmentDateUtc; // Calendar/day
  final DateTime? appointmentTimeUtc; // Actual time slot
  final String uhid;
  final String name;
  final String phone;
  final String gender;
  final String? address;
  final String? bookingName;
  final String? ds; // e.g. "Dr."
  final String? doctorName;
  final String? appDateRaw; // sometimes server gives a ready-made string

  AppointmentModel({
    required this.id,
    this.slotId,
    this.departmentId,
    this.doctorId,
    this.appointmentDateUtc,
    this.appointmentTimeUtc,
    required this.uhid,
    required this.name,
    required this.phone,
    required this.gender,
    this.address,
    this.bookingName,
    this.ds,
    this.doctorName,
    this.appDateRaw,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> j) {
    DateTime? parseZ(dynamic v) {
      if (v == null) return null;
      try {
        // API returns "....Z" (UTC). toLocal() converts to IST automatically.
        return DateTime.parse(v.toString()).toLocal();
      } catch (_) {
        return null;
      }
    }

    return AppointmentModel(
      id: j['id'] as int,
      slotId: j['slot_id'] as int?,
      departmentId: j['department_id'] as int?,
      doctorId: j['doctor_id'] as int?,
      appointmentDateUtc: parseZ(j['appointment_date']),
      appointmentTimeUtc: parseZ(j['appointment_time']),
      uhid: (j['uhid'] ?? '').toString(),
      name: (j['name'] ?? '').toString(),
      phone: (j['phone'] ?? '').toString(),
      gender: (j['gender'] ?? '').toString(),
      address: j['address']?.toString(),
      bookingName: j['booking_name']?.toString(),
      ds: j['ds']?.toString(),
      doctorName: j['doctor_name']?.toString(),
      appDateRaw: j['app_date']?.toString(),
    );
  }

  // Prefer appointmentTime when present; else fall back to appointmentDate.
  DateTime? get whenLocal => appointmentTimeUtc ?? appointmentDateUtc;

  String get doctorDisplay {
    final prefix = (ds ?? '').trim();
    final dname = (doctorName ?? '').trim();
    return ([prefix, dname]..removeWhere((s) => s.isEmpty)).join(' ');
  }
}
