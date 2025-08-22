import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'common_layout.dart';

class PatientDaycareDetailsScreen extends StatefulWidget {
  final List<DaycareDetailsModel> dayCareList;
  const PatientDaycareDetailsScreen({super.key, required this.dayCareList});

  @override
  State<PatientDaycareDetailsScreen> createState() =>
      _PatientDaycareDetailsScreenState();
}

class _PatientDaycareDetailsScreenState
    extends State<PatientDaycareDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    // Expecting a Map<String, dynamic> OR a typed object as arguments.
    final dynamic arg = ModalRoute.of(context)?.settings.arguments;
    final d = _DaycareAdapter(arg);

    return Scaffold(
      body: PatientDetailsScreenLayout(
        heading: 'Daycare Details',
        child: SliverList(
          delegate: SliverChildListDelegate.fixed([
            const SizedBox(height: 16),

            // ===== Summary =====
            _WhiteCard(
              child: Row(
                children: [
                  Expanded(
                    child: _summaryTile(
                      icon: Icons.local_hospital_outlined,
                      label: 'Admission',
                      value: d.admissionType,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryTile(
                      icon: Icons.event_available,
                      label: 'Admit Date',
                      value: d.admissionAtText,
                      color: Colors.teal,
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== Status & Quick facts =====
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statusChip(
                        label: d.isDischarged ? 'Discharged' : 'Admitted',
                        color: d.isDischarged ? Colors.green : Colors.orange,
                        icon:
                        d.isDischarged ? Icons.verified : Icons.hourglass_bottom,
                      ),
                      if (d.type.isNotEmpty)
                        _chip(icon: Icons.category_outlined, label: d.type.toUpperCase()),
                      if (d.packageType.isNotEmpty)
                        _chip(icon: Icons.medical_services_outlined, label: d.packageType),
                      if (d.packageAmountText.isNotEmpty)
                        _chip(icon: Icons.request_quote_outlined, label: d.packageAmountText),
                      if (d.insuranceIdText.isNotEmpty)
                        _chip(icon: Icons.shield_outlined, label: d.insuranceIdText),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (d.symptoms.isNotEmpty)
                    _kvRow(
                      icon: Icons.sick_outlined,
                      label: 'Symptoms',
                      value: d.symptoms,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== Care Team =====
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Care Team'),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.person_outline,
                    label: 'Doctor',
                    value: d.doctorName,
                  ),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.badge_outlined,
                    label: 'Department',
                    value: d.departmentName,
                  ),
                  if (d.diagnosisIdText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _kvRow(
                      icon: Icons.assignment_outlined,
                      label: 'Diagnosis ID',
                      value: d.diagnosisIdText,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== Facility =====
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Facility'),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.home_work_outlined,
                    label: 'Ward',
                    value: d.wardName,
                  ),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.bed_outlined,
                    label: 'Bed',
                    value: d.bedName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== Package & Insurance =====
            _WhiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Package & Insurance'),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.medical_information_outlined,
                    label: 'Package Type',
                    value: d.packageType.isEmpty ? '—' : d.packageType,
                  ),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.card_membership_outlined,
                    label: 'Package Name',
                    value: d.packageName.isEmpty ? '—' : d.packageName,
                  ),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.payments_outlined,
                    label: 'Package Amount',
                    value: d.packageAmountText.isEmpty ? '—' : d.packageAmountText,
                  ),
                  const SizedBox(height: 10),
                  _kvRow(
                    icon: Icons.shield_outlined,
                    label: 'Insurance',
                    value: d.insuranceIdText.isEmpty ? '—' : d.insuranceIdText,
                  ),
                  if (d.insuranceNo.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _kvRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Insurance No',
                      value: d.insuranceNo,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== Responsible Person (if any) =====
            if (d.hasResponsible)
              _WhiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Responsible Person'),
                    const SizedBox(height: 10),
                    if (d.responsiblePerson.isNotEmpty)
                      _kvRow(
                        icon: Icons.person_outline,
                        label: 'Name',
                        value: d.responsiblePerson,
                      ),
                    if (d.responsibleRelation.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _kvRow(
                        icon: Icons.group_outlined,
                        label: 'Relation',
                        value: d.responsibleRelation,
                      ),
                    ],
                    if (d.responsiblePhone.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _kvRow(
                              icon: Icons.call_outlined,
                              label: 'Phone',
                              value: d.responsiblePhone,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _miniAction(
                            tooltip: 'Copy',
                            icon: Icons.copy_rounded,
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: d.responsiblePhone));
                              _snack(context, 'Phone copied');
                            },
                          ),
                          const SizedBox(width: 6),
                          _miniAction(
                            tooltip: 'Call',
                            icon: Icons.phone_rounded,
                            onTap: () {
                              _snack(context, 'Would call ${d.responsiblePhone}');
                              // Add url_launcher to dial:
                              // launchUrl(Uri.parse('tel:${d.responsiblePhone}'));
                            },
                          ),
                        ],
                      ),
                    ],
                    if (d.responsibleAddress.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _kvRow(
                        icon: Icons.location_on_outlined,
                        label: 'Address',
                        value: d.responsibleAddress,
                        multiline: true,
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // ===== Footer actions =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _primaryButton(
                    icon: Icons.content_copy,
                    label: 'Copy Admission ID',
                    onPressed: () {
                      if (d.id != null) {
                        Clipboard.setData(ClipboardData(text: d.id.toString()));
                        _snack(context, 'Admission ID copied');
                      }
                    },
                  ),
                  if (!d.isDischarged)
                    _secondaryButton(
                      icon: Icons.logout_rounded,
                      label: 'Discharge',
                      onPressed: () {
                        _snack(context, 'Discharge flow to be implemented');
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ]),
        ),
      ),
    );
  }

  // ----- Small UI bits -----
  static Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.w800,
      color: Colors.black87,
    ),
  );

  static Widget _kvRow({
    required IconData icon,
    required String label,
    required String value,
    bool multiline = false,
  }) {
    return Row(
      crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blueGrey.withOpacity(0.12),
          child: Icon(icon, size: 18, color: Colors.blueGrey),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  )),
              const SizedBox(height: 2),
              Text(
                value.isEmpty ? '—' : value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _statusChip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _miniAction({
    required String tooltip,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(message: tooltip, child: Icon(icon, size: 18, color: Colors.indigo)),
        ),
      ),
    );
  }

  static Widget _primaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  static Widget _secondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.indigo,
        side: const BorderSide(color: Colors.indigo),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

// ===== Shared card used across sections (solid white) =====
class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, // SOLID WHITE
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ===== Argument adapter (handles Map or typed object gracefully) =====
class _DaycareAdapter {
  final dynamic _raw;
  _DaycareAdapter(this._raw);

  // ---------------- core readers ----------------
  dynamic _readKey(String key) {
    if (_raw == null) return null;

    // 1) Map
    if (_raw is Map<String, dynamic>) {
      return (_raw as Map<String, dynamic>)[key];
    }

    // 2) try toJson()
    try {
      final j = (_raw as dynamic).toJson?.call();
      if (j is Map) return j[key];
    } catch (_) {}

    // 3) try toMap()
    try {
      final m = (_raw as dynamic).toMap?.call();
      if (m is Map) return m[key];
    } catch (_) {}

    return null;
  }

  /// return first non-empty string among keys, else fallback
  String _s(List<String> keys, {String fallback = ''}) {
    for (final k in keys) {
      final v = _readKey(k);
      if (v != null) {
        final t = v.toString().trim();
        if (t.isNotEmpty) return t;
      }
    }
    return fallback;
  }

  /// return first numeric among keys (int/double or parsable), else null
  num? _n(List<String> keys) {
    for (final k in keys) {
      final v = _readKey(k);
      if (v == null) continue;
      if (v is num) return v;
      final d = num.tryParse(v.toString());
      if (d != null) return d;
    }
    return null;
  }

  /// returns true if any key is a truthy int/bool
  bool _boolFromInt(List<String> keys) {
    final v = _n(keys);
    if (v != null) return v != 0;
    final s = _s(keys);
    if (s.isEmpty) return false;
    // treat "1"/"true" as true
    return s == '1' || s.toLowerCase() == 'true';
  }

  String _string(dynamic v) => v == null ? '' : v.toString();

  // ---------------- public fields ----------------
  int? get id {
    final v = _n(['id']);
    return v?.toInt();
  }

  bool get isDischarged {
    // discharge_status: 0 = not discharged, 1 = discharged (adjust if different)
    return _boolFromInt(['discharge_status']);
  }

  String get admissionType =>
      _s(['admission_type', 'admissionType']).toUpperCase();

  String get admissionAtText =>
      _formatDateTime(_s(['admission_date', 'admissionDate']));

  String get type => _s(['type']);

  String get doctorName =>
      _s(['doctor_name', 'doctorName'], fallback: 'Unknown Doctor');

  String get departmentName =>
      _s(['department_name', 'departmentName'], fallback: '—');

  String get wardName => _s(['ward_name', 'wardName'], fallback: '—');

  String get bedName => _s(['bed_name', 'bedName'], fallback: '—');

  String get packageType => _s(['package_type', 'packageType']);

  String get packageName => _s(['package_name', 'packageName']);

  String get packageAmountText {
    final v = _n(['package_amount']);
    return v == null ? '' : _inr(v.toDouble());
  }

  String get insuranceIdText {
    final v = _s(['insurance_id', 'insuranceId']);
    return v.isEmpty ? '' : 'Insurance ID: $v';
  }

  String get insuranceNo => _s(['insurance_no', 'insuranceNo']);

  String get symptoms => _s(['symptoms']);

  String get diagnosisIdText {
    final v = _s(['diagnosis_id', 'diagnosisId']);
    return v.isEmpty ? '' : 'DX ID: $v';
  }

  // -------- Responsible person --------
  String get responsiblePerson => _s(['responsible_person', 'responsiblePerson']);

  String get responsibleRelation =>
      _s(['responsible_person_relation', 'responsiblePersonRelation']);

  String get responsiblePhone =>
      _s(['responsible_person_ph_no', 'responsiblePersonPhNo']);

  String get responsibleAddress =>
      _s(['responsible_person_address', 'responsiblePersonAddress']);

  bool get hasResponsible =>
      responsiblePerson.isNotEmpty ||
          responsibleRelation.isNotEmpty ||
          responsiblePhone.isNotEmpty ||
          responsibleAddress.isNotEmpty;

  // ---------------- utils ----------------
  static String _inr(num n) {
    final s = n.toStringAsFixed(2);
    final parts = s.split('.');
    final whole = parts[0];
    final dec = parts[1];
    final buf = StringBuffer();
    for (int i = 0; i < whole.length; i++) {
      final left = whole.length - i - 1;
      buf.write(whole[i]);
      if (left > 0 && left % 3 == 0) buf.write(',');
    }
    return '₹${buf.toString()}.$dec';
  }

  static String _formatDateTime(String iso) {
    if (iso.isEmpty) return '—';
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final dd = d.day.toString().padLeft(2, '0');
    final mm = months[d.month - 1];
    final yyyy = d.year.toString();
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$dd $mm $yyyy • $hh:$min';
  }
}

// --------- shared pieces copied from your other screens ---------
Widget _summaryTile({
  required IconData icon,
  required String label,
  required String value,
  required Color color,
  bool alignEnd = false,
}) =>
    _SummaryTile(
      icon: icon,
      label: label,
      value: value,
      color: color,
      alignEnd: alignEnd,
    );

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool alignEnd;
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}

// Simple floating snackbar helper
void _snack(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1400),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
