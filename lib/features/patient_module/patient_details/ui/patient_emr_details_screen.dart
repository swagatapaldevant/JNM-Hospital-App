import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/ui/common_header.dart';
import 'common_layout.dart';

class PatientEmrDetailsScreen extends StatefulWidget {
  final List<EmrDetailsModel> emrList;
  const PatientEmrDetailsScreen({super.key, required this.emrList});

  @override
  State<PatientEmrDetailsScreen> createState() =>
      _PatientEmrDetailsScreenState();
}

class _PatientEmrDetailsScreenState extends State<PatientEmrDetailsScreen> {
  final TextEditingController _search = TextEditingController();

  // Filters
  String _sectionFilter = 'All'; // All | OPD | IPD | EMG | Daycare
  String _dateFilter = 'All'; // All | Today | Past
  String _doctorFilter = 'All'; // All | <Doctor Names>

  late List<EmrDetailsModel> _sorted;
  late List<String> _doctors;

  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();

    _sorted = [...widget.emrList]..sort((a, b) {
        final ad = _safeDate(_getDateIso(a));
        final bd = _safeDate(_getDateIso(b));
        return bd.compareTo(ad); // newest first
      });

    final docs = <String>{};
    for (final e in widget.emrList) {
      final name = _doctor(e);
      if (name.trim().isNotEmpty) docs.add(name);
    }
    _doctors = ['All', ...docs.toList()..sort()];
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _applyFilters(
      _sorted,
      _search.text,
      _sectionFilter,
      _dateFilter,
      _doctorFilter,
    );

    return Scaffold(
      body: PatientDetailsScreenLayout(slivers: [
        //   SliverToBoxAdapter(
        //   child: Padding(
        //     padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        //     child: Row(
        //       children: [
        //         _roundIconButton(
        //             icon: Icons.arrow_back_ios_new_rounded,
        //             onTap: () => Navigator.pop(context)),
        //         const SizedBox(width: 12),
        //         Expanded(
        //           child: Text(
        //             "EMR Records",
        //             style: TextStyle(
        //               color: Colors.black87,
        //               fontSize: 20,
        //               fontWeight: FontWeight.w700,
        //               letterSpacing: 0.2,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        CommonHeader(title: "Emergency (EMR)"),
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            const SizedBox(height: 16),

            // ===== Summary =====
            _WhiteCard(
              child: Row(
                children: [
                  _summaryTile(
                    icon: Icons.description_outlined,
                    label: 'Records',
                    value: '${filtered.length}',
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _summaryTile(
                      icon: Icons.biotech_outlined,
                      label: 'With Tests',
                      value:
                          '${filtered.where((e) => _tests(e).isNotEmpty).length}',
                      color: Colors.teal,
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== Search & Filters =====
            // ===== Search & Filters (expandable) =====
            _ExpandableFilterCard(
              expanded: _filtersExpanded,
              onToggle: () =>
                  setState(() => _filtersExpanded = !_filtersExpanded),
              title: 'Search & Filters',
              searchField: _SearchField(
                controller: _search,
                hint: 'Search diagnosis, medicine, doctor, section…',
                onChanged: (_) => setState(() {}),
              ),
              filters: _FilterBar(
                section: _sectionFilter,
                onSectionChanged: (v) => setState(() => _sectionFilter = v),
                date: _dateFilter,
                onDateChanged: (v) => setState(() => _dateFilter = v),
                doctor: _doctorFilter,
                doctorItems: _doctors,
                onDoctorChanged: (v) => setState(() => _doctorFilter = v),
              ),
            ),

            const SizedBox(height: 12),

            // ===== Empty =====
            if (filtered.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: const _EmptyState(
                  title: 'No EMR records found',
                  subtitle:
                      'Try clearing filters or searching with a different term.',
                ),
              ),

            // ===== EMR list =====
            ...filtered.map((emr) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: _EmrTile(
                    emr: emr,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _showEmrBottomSheet(context, emr);
                    },
                  ),
                )),

            const SizedBox(height: 28),
          ]),
        ),
      ]),
    );
  }

  Widget _roundIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      radius: 28,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.cyan, width: 2)),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

// ---------------- Helpers: parsing & accessors ----------------

DateTime _safeDate(dynamic iso) {
  if (iso == null) return DateTime.fromMillisecondsSinceEpoch(0);
  final d = DateTime.tryParse(iso.toString());
  if (d != null) return d;
  // fallback for "yyyy-MM-dd HH:mm:ss"
  try {
    final s = iso.toString().replaceFirst(' ', 'T');
    return DateTime.tryParse(s) ?? DateTime.fromMillisecondsSinceEpoch(0);
  } catch (_) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}

String? _getDateIso(EmrDetailsModel m) {
  final v = (m as dynamic).date;
  return v?.toString();
}

String _doctor(EmrDetailsModel m) {
  final v = (m as dynamic).doctorName ?? (m as dynamic).doctor_name;
  return (v?.toString().trim().isNotEmpty ?? false)
      ? v.toString()
      : 'Unknown Doctor';
}

String _section(EmrDetailsModel m) {
  final v = (m as dynamic).section;
  if (v == null) return '—';
  final s = v.toString().toUpperCase();
  switch (s) {
    case 'OPD':
      return 'OPD';
    case 'IPD':
      return 'IPD';
    case 'EMG':
      return 'EMG';
    default:
      return s; // Daycare, etc.
  }
}

String _formatDateTime(String? iso) {
  if (iso == null || iso.isEmpty) return '—';
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  final dd = d.day.toString().padLeft(2, '0');
  final mm = months[d.month - 1];
  final yyyy = d.year.toString();

  // Convert to 12-hour format
  int hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final hh = hour.toString().padLeft(2, '0');
  final min = d.minute.toString().padLeft(2, '0');
  final period = d.hour >= 12 ? 'PM' : 'AM';

  return '$dd $mm $yyyy • $hh:$min $period';
}

List<Map<String, dynamic>> _parseMapList(dynamic v) {
  if (v == null) return const [];
  if (v is List) {
    return v.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }
  // Stringified JSON array
  final s = v.toString();
  try {
    final decoded = json.decode(s);
    if (decoded is List) {
      return decoded.map((e) => (e as Map).cast<String, dynamic>()).toList();
    }
  } catch (_) {}
  return const [];
}

List<String> _parseStringList(dynamic v) {
  if (v == null) return const [];
  if (v is List) return v.map((e) => e.toString()).toList();
  try {
    final decoded = json.decode(v.toString());
    if (decoded is List) return decoded.map((e) => e.toString()).toList();
  } catch (_) {}
  return const [];
}

String _stripHtml(String? html) {
  if (html == null || html.isEmpty) return '';
  final noTags = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return html.replaceAll(noTags, '').trim();
}

// Accessors for tiles / filters
List<Map<String, dynamic>> _vitals(EmrDetailsModel m) =>
    _parseMapList((m as dynamic).vitals);

List<Map<String, dynamic>> _diagnosis(EmrDetailsModel m) =>
    _parseMapList((m as dynamic).diagnosis);

List<Map<String, dynamic>> _medicines(EmrDetailsModel m) =>
    _parseMapList((m as dynamic).medicines);

List<Map<String, dynamic>> _progress(EmrDetailsModel m) =>
    _parseMapList((m as dynamic).progressNote);

List<Map<String, dynamic>> _nursing(EmrDetailsModel m) => _parseMapList(
    (m as dynamic).nursingInstructions);

List<String> _tests(EmrDetailsModel m) =>
    _parseStringList((m as dynamic).testName);

// ---------------- Filters ----------------

List<EmrDetailsModel> _applyFilters(
  List<EmrDetailsModel> list,
  String q,
  String section,
  String date,
  String doctor,
) {
  Iterable<EmrDetailsModel> res = list;
  final query = q.trim().toLowerCase();
  final now = DateTime.now();

  if (query.isNotEmpty) {
    res = res.where((m) {
      final diag = _diagnosis(m)
          .map((e) => (e['diagnosis'] ?? '').toString().toLowerCase())
          .join(' ');
      final meds = _medicines(m)
          .map((e) => (e['medicine'] ?? '').toString().toLowerCase())
          .join(' ');
      final doc = _doctor(m).toLowerCase();
      final sec = _section(m).toLowerCase();
      final tests = _tests(m).join(' ').toLowerCase();
      return diag.contains(query) ||
          meds.contains(query) ||
          doc.contains(query) ||
          sec.contains(query) ||
          tests.contains(query);
    });
  }

  if (section != 'All') {
    res = res.where((m) => _section(m).toUpperCase() == section.toUpperCase());
  }

  if (doctor != 'All') {
    res = res.where((m) => _doctor(m) == doctor);
  }

  if (date != 'All') {
    res = res.where((m) {
      final d = _safeDate(_getDateIso(m));
      if (date == 'Today') {
        final n = DateTime.now();
        return d.year == n.year && d.month == n.month && d.day == n.day;
      } else if (date == 'Past') {
        return d.isBefore(DateTime(now.year, now.month, now.day));
      }
      return true;
    });
  }

  return res.toList();
}

// ---------------- Bottom sheet ----------------

void _showEmrBottomSheet(BuildContext context, EmrDetailsModel emr) {
  final vitals = _vitals(emr);
  final diagnosis = _diagnosis(emr);
  final meds = _medicines(emr);
  final progress = _progress(emr);
  final nursing = _nursing(emr);
  final tests = _tests(emr);
  final advice = _stripHtml(((emr as dynamic).advice)?.toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) {
      return SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, c) {
            return SingleChildScrollView(
              controller: c,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_section(emr)} • ${_doctor(emr)}',
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        _formatDateTime((emr as dynamic).date),
                        style: const TextStyle(
                            fontSize: 12.5, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  if (vitals.isNotEmpty) ...[
                    _sheetSection('Vitals'),
                    const SizedBox(height: 8),
                    _vitalsGrid(vitals.first),
                    const SizedBox(height: 14),
                  ],

                  if (diagnosis.isNotEmpty) ...[
                    _sheetSection('Diagnosis'),
                    const SizedBox(height: 8),
                    ...diagnosis
                        .map((d) => _bullet(d['diagnosis']?.toString() ?? '—')),
                    const SizedBox(height: 14),
                  ],

                  if (meds.isNotEmpty) ...[
                    _sheetSection('Medicines'),
                    const SizedBox(height: 8),
                    ...meds.map((m) => _bullet(
                          '${m['medicine'] ?? ''} • ${m['dose'] ?? ''} • ${m['when'] ?? ''}'
                              .replaceAll(' •  • ', '')
                              .trim(),
                        )),
                    const SizedBox(height: 14),
                  ],

                  if (progress.isNotEmpty) ...[
                    _sheetSection('Progress Notes'),
                    const SizedBox(height: 8),
                    ...progress.map(
                        (p) => _bullet(p['observation']?.toString() ?? '—')),
                    const SizedBox(height: 14),
                  ],

                  if (nursing.isNotEmpty) ...[
                    _sheetSection('Nursing Instructions'),
                    const SizedBox(height: 8),
                    ...nursing.map(
                        (n) => _bullet(n['instructions']?.toString() ?? '—')),
                    const SizedBox(height: 14),
                  ],

                  if (tests.isNotEmpty) ...[
                    _sheetSection('Investigations'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tests
                          .map((t) =>
                              _chip(icon: Icons.biotech_outlined, label: t))
                          .toList(),
                    ),
                    const SizedBox(height: 14),
                  ],

                  if (advice.isNotEmpty) ...[
                    _sheetSection('Advice'),
                    const SizedBox(height: 8),
                    Text(
                      advice,
                      style: const TextStyle(
                          fontSize: 14.5, color: Colors.black87, height: 1.35),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

// ---------- Shared bullet list item ----------
Widget _bullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.isEmpty ? '—' : text,
            style: const TextStyle(
              fontSize: 14.5,
              color: Colors.black87,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}

// ---------- Shared chip (diagnosis/tests/etc.) ----------
Widget _chip({
  required IconData icon,
  required String label,
  Color color = Colors.indigo,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withOpacity(0.25)),
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
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    ),
  );
}

// ====== bottom-sheet small UIs ======
Widget _sheetSection(String title) => Text(
      title,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );

Widget _vitalsGrid(Map<String, dynamic> v) {
  String _v(String k) =>
      (v[k]?.toString().trim().isEmpty ?? true) ? '—' : v[k].toString();

  final items = [
    ['Pulse', _v('pulse')],
    ['Temp', _v('temperature')],
    [
      'BP',
      (_v('bp_systolic') == '—' && _v('bp_diastolic') == '—')
          ? '—'
          : '${_v('bp_systolic')}/${_v('bp_diastolic')}'
    ],
    ['SpO₂', _v('SpO2')],
    ['Resp', _v('respiratory')],
    ['Wt', _v('weight')],
    ['Ht', _v('height')],
  ];

  return Wrap(
    spacing: 10,
    runSpacing: 10,
    children: items
        .map((e) =>
            _tag(icon: Icons.monitor_heart_outlined, label: '${e[0]}: ${e[1]}'))
        .toList(),
  );
}

// ---------- Shared tag chip ----------
Widget _tag({required IconData icon, required String label}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.blueGrey.withOpacity(0.08),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.blueGrey.withOpacity(0.25)),
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
            color: Colors.blueGrey,
          ),
        ),
      ],
    ),
  );
}

// ===================== Tile =====================

class _EmrTile extends StatelessWidget {
  final EmrDetailsModel emr;
  final VoidCallback onTap;
  const _EmrTile({required this.emr, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // accessors scoped to tile
    String _doctor() {
      final v = (emr as dynamic).doctorName ?? (emr as dynamic).doctor_name;
      return (v?.toString().trim().isNotEmpty ?? false)
          ? v.toString()
          : 'Unknown Doctor';
    }

    String _section() {
      final v = (emr as dynamic).section?.toString().toUpperCase() ?? '—';
      return v;
    }

    String _dateText() {
      final iso = (emr as dynamic).date?.toString();
      if (iso == null || iso.isEmpty) return '—';
      final d = DateTime.tryParse(iso);
      if (d == null) return iso;

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];

      final dd = d.day.toString().padLeft(2, '0');
      final mm = months[d.month - 1];
      final yyyy = d.year.toString();

      // Convert to 12-hour format
      int hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
      final hh = hour.toString().padLeft(2, '0');
      final min = d.minute.toString().padLeft(2, '0');
      final period = d.hour >= 12 ? 'PM' : 'AM';

      return '$dd $mm $yyyy • $hh:$min $period';
    }

    List<Map<String, dynamic>> _vitals() {
      final raw = (emr as dynamic).vitals;
      try {
        final list = (raw is String) ? json.decode(raw) : raw;
        if (list is List)
          return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
      } catch (_) {}
      return const [];
    }

    List<Map<String, dynamic>> _diag() {
      final raw = (emr as dynamic).diagnosis;
      try {
        final list = (raw is String) ? json.decode(raw) : raw;
        if (list is List)
          return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
      } catch (_) {}
      return const [];
    }

    List<Map<String, dynamic>> _meds() {
      final raw = (emr as dynamic).medicines;
      try {
        final list = (raw is String) ? json.decode(raw) : raw;
        if (list is List)
          return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
      } catch (_) {}
      return const [];
    }

    final vitals = _vitals();
    final diag = _diag();
    final meds = _meds();

    String? pulse =
        vitals.isNotEmpty ? vitals.first['pulse']?.toString() : null;
    String? temp =
        vitals.isNotEmpty ? vitals.first['temperature']?.toString() : null;
    String? spo2 = vitals.isNotEmpty
        ? (vitals.first['SpO2'] ?? vitals.first['spo2'])?.toString()
        : null;

    String diagText =
        diag.isNotEmpty ? (diag.first['diagnosis']?.toString() ?? '') : '';
    String medText =
        meds.isNotEmpty ? (meds.first['medicine']?.toString() ?? '') : '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Row(
          children: [
            // Leading circle with section initials
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00C2FF),
                    Color(0xFF7F5AF0),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  _section().length >= 3
                      ? _section().substring(0, 3)
                      : _section(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section + date
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _section(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event,
                              size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text(_dateText(),
                              style: const TextStyle(
                                  fontSize: 12.5, color: Colors.black54)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Doctor
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Dr ${_doctor()}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Quick vitals row (chips)
                  if (pulse != null || temp != null || spo2 != null) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (pulse != null)
                          _tag(
                              icon: Icons.monitor_heart_outlined,
                              label: 'Pulse: $pulse'),
                        if (temp != null)
                          _tag(
                              icon: Icons.thermostat_outlined,
                              label: 'Temp: $temp'),
                        if (spo2 != null)
                          _tag(
                              icon: Icons.bloodtype_outlined,
                              label: 'SpO₂: $spo2'),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Diagnosis/Medicine chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (diagText.isNotEmpty)
                        _chip(
                            icon: Icons.assignment_turned_in_outlined,
                            label: diagText),
                      if (medText.isNotEmpty)
                        _chip(icon: Icons.medication_outlined, label: medText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _tag({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.blueGrey.withOpacity(0.25)),
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
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _chip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
}

// ===================== Filters/Search/Containers/Empty =====================

class _FilterBar extends StatelessWidget {
  final String section;
  final String date;
  final String doctor;
  final ValueChanged<String> onSectionChanged;
  final ValueChanged<String> onDateChanged;
  final ValueChanged<String> onDoctorChanged;
  final List<String> doctorItems;

  const _FilterBar({
    required this.section,
    required this.date,
    required this.doctor,
    required this.onSectionChanged,
    required this.onDateChanged,
    required this.onDoctorChanged,
    required this.doctorItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _segmentedRow(
          label: 'Section',
          items: const ['All', 'OPD', 'IPD', 'EMG', 'DAYCARE'],
          value: section,
          onChanged: onSectionChanged,
        ),
        const SizedBox(height: 8),
        _segmentedRow(
          label: 'Date',
          items: const ['All', 'Today', 'Past'],
          value: date,
          onChanged: onDateChanged,
        ),
        const SizedBox(height: 8),
        _doctorRow(
          label: 'Doctor',
          items: doctorItems,
          value: doctor,
          onChanged: onDoctorChanged,
        ),
      ],
    );
  }

  Widget _segmentedRow({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              )),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items
                  .map((it) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _segChip(
                          label: it,
                          selected: value == it,
                          onTap: () => onChanged(it),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _doctorRow({
    required String label,
    required List<String> items,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              )),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: items
                  .map((it) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _segChip(
                          label: it,
                          selected: value == it,
                          onTap: () => onChanged(it),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _segChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = selected ? Colors.indigo : Colors.grey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.45)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  const _SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Colors.indigo),
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.description_outlined,
            size: 64, color: Colors.blueGrey.withOpacity(0.4)),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
        const SizedBox(height: 8),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black54.withOpacity(0.8),
                height: 1.3)),
      ],
    );
  }
}

// ---------- Shared summary tile ----------
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
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment:
              alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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

class _ExpandableFilterCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final String title;
  final Widget searchField;
  final Widget filters;

  const _ExpandableFilterCard({
    required this.expanded,
    required this.onToggle,
    required this.title,
    required this.searchField,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row (tap to toggle)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded,
                      size: 20, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns:
                        expanded ? 0.5 : 0.0, // arrow rotates up when expanded
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // Search always visible
          searchField,

          // Smooth expand/collapse body
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeOut,
            sizeCurve: Curves.easeOut,
            crossFadeState:
                expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: const SizedBox(height: 0),
            secondChild: Column(
              children: [
                const SizedBox(height: 12),
                _softDivider(),
                const SizedBox(height: 12),
                filters,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _softDivider() => Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.06), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      );
}
