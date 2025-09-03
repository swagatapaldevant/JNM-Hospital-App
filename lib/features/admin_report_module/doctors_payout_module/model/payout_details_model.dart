class PayoutDetailRow {
  final int billingId;
  final String uid;
  final String name;         // patient name
  final int patientId;
  final double amount;       // bill amount (not used in table)
  final DateTime billDate;
  final String section;
  final String doctorName;
  final double doctorFees;
  final String commissionType;   // 'rs' / '%'
  final double commissionAmount; // "doctor paid"
  final int chargeId;
  final String type;             // 'old' | 'new'

  const PayoutDetailRow({
    required this.billingId,
    required this.uid,
    required this.name,
    required this.patientId,
    required this.amount,
    required this.billDate,
    required this.section,
    required this.doctorName,
    required this.doctorFees,
    required this.commissionType,
    required this.commissionAmount,
    required this.chargeId,
    required this.type,
  });

  factory PayoutDetailRow.fromMap(Map<String, dynamic> m) {
    double _toD(v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      final s = v.toString().trim();
      return double.tryParse(s) ?? 0;
    }

    DateTime _toDt(v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      final s = v.toString().replaceFirst(' ', 'T'); // "yyyy-MM-dd HH:mm:ss"
      return DateTime.tryParse(s) ??
          DateTime.fromMillisecondsSinceEpoch(0);
    }

    return PayoutDetailRow(
      billingId: ((m['billing_id'] ?? 0) as num).toInt(),
      uid: (m['uid'] ?? '').toString(),
      name: (m['name'] ?? '').toString(),
      patientId: ((m['patient_id'] ?? 0) as num).toInt(),
      amount: _toD(m['amount']),
      billDate: _toDt(m['bill_date']),
      section: (m['section'] ?? '').toString(),
      doctorName: (m['doctor_name'] ?? '').toString(),
      doctorFees: _toD(m['doctor_fees']),
      commissionType: (m['commission_type'] ?? '').toString(),
      commissionAmount: _toD(m['commission_amount']),
      chargeId: ((m['charge_id'] ?? 0) as num).toInt(),
      type: (m['type'] ?? '').toString(),
    );
  }
}
