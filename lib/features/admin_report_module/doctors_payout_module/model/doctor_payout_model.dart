class DoctorCollectionData {
  final String docName;
  final int patients;
  final double total;
  final double docPaid;
  final double rainbow;
  final int newlyRegistered; // maps from "new"
  final int chargeId;

  const DoctorCollectionData({
    required this.docName,
    required this.patients,
    required this.total,
    required this.docPaid,
    required this.rainbow,
    required this.newlyRegistered,
    required this.chargeId,
  });

  factory DoctorCollectionData.fromMap(Map<String, dynamic> m) {
    return DoctorCollectionData(
      docName: (m['doc_name'] ?? '').toString(),
      patients: ((m['patients'] ?? 0) as num).toInt(),
      total: ((m['total'] ?? 0) as num).toDouble(),
      docPaid: ((m['doc_paid'] ?? 0) as num).toDouble(),
      rainbow: ((m['rainbow'] ?? 0) as num).toDouble(),
      newlyRegistered: ((m['new'] ?? 0) as num).toInt(),
      chargeId: ((m['charge_id'] ?? 0) as num).toInt(),
    );
    // If your API uses strings for numbers, the (num) casts still work via toDouble()/toInt()
  }
}
