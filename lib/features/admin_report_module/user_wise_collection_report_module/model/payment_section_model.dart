/// ---------- MODELS ----------
// class Payment {
//   final String section;
//   final double amount;
//   final String mode;
//   final DateTime dateTime;
//
//   Payment({
//     required this.section,
//     required this.amount,
//     required this.mode,
//     required this.dateTime,
//   });
//
//   factory Payment.fromJson(Map<String, dynamic> j) {
//     double _toD(dynamic v) {
//       if (v == null) return 0.0;
//       if (v is num) return v.toDouble();
//       return double.tryParse(v.toString().trim()) ?? 0.0;
//     }
//
//     DateTime _toDt(dynamic v) {
//       final raw = (v ?? '').toString().trim();
//       if (raw.isEmpty) return DateTime.fromMillisecondsSinceEpoch(0);
//       final iso = raw.contains(' ') ? raw.replaceFirst(' ', 'T') : raw;
//       return DateTime.tryParse(iso) ?? DateTime.fromMillisecondsSinceEpoch(0);
//     }
//
//     return Payment(
//       section: (j['section'] ?? '').toString().trim(),
//       amount: _toD(j['payment_amount']),   // <-- string or number OK
//       mode: (j['payment_mode'] ?? '').toString().trim(),
//       dateTime: _toDt(j['payment_date']),  // <-- "yyyy-MM-dd HH:mm:ss" OK
//     );
//   }
// }
