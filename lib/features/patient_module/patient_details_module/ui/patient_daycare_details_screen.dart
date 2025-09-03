import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_header.dart';
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
  final TextEditingController _search = TextEditingController();

  // Filters
  String _statusFilter = 'All'; // All | Admitted | Discharged
  String _typeFilter = 'All';   // All | New | Old
  String _dateFilter = 'All';   // All | Today | Upcoming | Past

  late List<DaycareDetailsModel> _sorted;

  bool _filtersExpanded = false;


  @override
  void initState() {
    super.initState();
    _sorted = [...widget.dayCareList]..sort((a, b) {
      final ad = _safeDate(_getAdmissionIso(a));
      final bd = _safeDate(_getAdmissionIso(b));
      return bd.compareTo(ad); // newest first
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
    _applyFilters(_sorted, _search.text, _statusFilter, _typeFilter, _dateFilter);
    final summary = _summaryStats(filtered);

    return Scaffold(
      body: PatientDetailsScreenLayout(
        
        slivers: [
          CommonHeader(title: "Daycare Details"),
          SliverList(
          delegate: SliverChildListDelegate.fixed([
            const SizedBox(height: 16),

            // ===== Summary =====
            // _WhiteCard(
            //   child: Row(
            //     children: [
            //       _summaryTile(
            //         icon: Icons.medical_services_outlined,
            //         label: 'Daycare',
            //         value: '${filtered.length}',
            //         color: Colors.indigo,
            //       ),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: _summaryTile(
            //           icon: Icons.local_hotel_outlined,
            //           label: 'Currently Admitted',
            //           value: '${summary.currentAdmitted}',
            //           color: Colors.deepOrange,
            //           alignEnd: true,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // const SizedBox(height: 12),

            // ===== Search & Filters =====
            // ===== Search & Filters (expandable) =====
            _ExpandableFilterCard(
              expanded: _filtersExpanded,
              onToggle: () => setState(() => _filtersExpanded = !_filtersExpanded),
              title: 'Search & Filters',
              searchField: _SearchField(
                controller: _search,
                hint: 'Search doctor, department, ward, bed, type, ID…',
                onChanged: (_) => setState(() {}),
              ),
              filters: _FilterBar(
                status: _statusFilter,
                onStatusChanged: (v) => setState(() => _statusFilter = v),
                type: _typeFilter,
                onTypeChanged: (v) => setState(() => _typeFilter = v),
                date: _dateFilter,
                onDateChanged: (v) => setState(() => _dateFilter = v),
              ),
            ),

            const SizedBox(height: 12),

            // ===== Empty =====
            if (filtered.isEmpty)
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: const _EmptyState(
                  title: 'No daycare records',
                  subtitle:
                  'Try clearing filters or searching with a different term.',
                ),
              ),

            // ===== List =====
            ...filtered.map((dc) => Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _DaycareTile(
                dc: dc,
                onTap: () {
                  HapticFeedback.selectionClick();
                  // TODO: Navigate to a detail view if you have one
                  // Navigator.pushNamed(context, RouteGenerator.kSomeScreen, arguments: dc);
                },
              ),
            )),

            const SizedBox(height: 28),
          ]),
        )],
      ),
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
            border: Border.all(color: Colors.cyan, width: 2)
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

}

  // ---------------- Helpers & Model accessors ----------------

  DateTime _safeDate(dynamic iso) {
    if (iso == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final d = DateTime.tryParse(iso.toString());
    return d ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  String? _getAdmissionIso(DaycareDetailsModel m) {
    final v = (m as dynamic).admissionDate ?? (m as dynamic).admission_date;
    return v?.toString();
  }

  String _doctorName(DaycareDetailsModel m) {
    final v = (m as dynamic).doctorName ?? (m as dynamic).doctor_name;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : 'Unknown Doctor';
  }

  String _department(DaycareDetailsModel m) {
    final v = (m as dynamic).departmentName ?? (m as dynamic).department_name;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  String _ward(DaycareDetailsModel m) {
    final v = (m as dynamic).wardName ?? (m as dynamic).ward_name;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  String _bed(DaycareDetailsModel m) {
    final v = (m as dynamic).bedName ?? (m as dynamic).bed_name;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  String _admissionType(DaycareDetailsModel m) {
    final v = (m as dynamic).admissionType ?? (m as dynamic).admission_type;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  String _type(DaycareDetailsModel m) {
    final v = (m as dynamic).type;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  bool _isDischarged(DaycareDetailsModel m) {
    final v = (m as dynamic).dischargeStatus ?? (m as dynamic).discharge_status;
    if (v is int) return v != 0;
    if (v is num) return v.toInt() != 0;
    if (v is String) return v == '1' || v.toLowerCase() == 'true';
    return false;
  }

  String _packageType(DaycareDetailsModel m) {
    final v = (m as dynamic).packageType ?? (m as dynamic).package_type;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '';
  }

  String _packageName(DaycareDetailsModel m) {
    final v = (m as dynamic).packageName ?? (m as dynamic).package_name;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '';
  }

  String _insuranceIdText(DaycareDetailsModel m) {
    final v = (m as dynamic).insuranceId ?? (m as dynamic).insurance_id;
    if (v == null) return '';
    return 'Insurance ID: $v';
  }

  String _symptoms(DaycareDetailsModel m) {
    final v = (m as dynamic).symptoms;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '';
  }

  List<DaycareDetailsModel> _applyFilters(
      List<DaycareDetailsModel> list,
      String q,
      String status,
      String type,
      String dateFilter,
      ) {
    final now = DateTime.now();
    Iterable<DaycareDetailsModel> res = list;
    final query = q.trim().toLowerCase();

    if (query.isNotEmpty) {
      res = res.where((m) {
        final doctor = _doctorName(m).toLowerCase();
        final dept = _department(m).toLowerCase();
        final ward = _ward(m).toLowerCase();
        final bed = _bed(m).toLowerCase();
        final t = _type(m).toLowerCase();
        final adt = _admissionType(m).toLowerCase();
        final id = ((m as dynamic).id)?.toString().toLowerCase() ?? '';
        return doctor.contains(query) ||
            dept.contains(query) ||
            ward.contains(query) ||
            bed.contains(query) ||
            t.contains(query) ||
            adt.contains(query) ||
            id.contains(query);
      });
    }

    if (status != 'All') {
      res = res.where((m) {
        final admitted = !_isDischarged(m);
        return status == 'Admitted' ? admitted : !admitted;
      });
    }

    if (type != 'All') {
      res = res.where((m) => _type(m).toLowerCase() == type.toLowerCase());
    }

    if (dateFilter != 'All') {
      res = res.where((m) {
        final d = _safeDate(_getAdmissionIso(m));
        if (dateFilter == 'Today') {
          final n = DateTime.now();
          final t = DateTime(n.year, n.month, n.day);
          return d.year == t.year && d.month == t.month && d.day == t.day;
        } else if (dateFilter == 'Upcoming') {
          return d.isAfter(now);
        } else if (dateFilter == 'Past') {
          return d.isBefore(DateTime(now.year, now.month, now.day));
        }
        return true;
      });
    }

    return res.toList();
  }

  _DaycareSummary _summaryStats(List<DaycareDetailsModel> list) {
    int currentAdmitted = 0;
    for (final m in list) {
      if (!_isDischarged(m)) currentAdmitted++;
    }
    return _DaycareSummary(currentAdmitted: currentAdmitted);
  }


class _DaycareSummary {
  final int currentAdmitted;
  _DaycareSummary({required this.currentAdmitted});
}

// ===================== UI Widgets =====================

class _DaycareTile extends StatelessWidget {
  final DaycareDetailsModel dc;
  final VoidCallback onTap;
  const _DaycareTile({required this.dc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Local accessors (same logic as screen helpers but scoped)
    String _doctorName() {
      final v = (dc as dynamic).doctorName ?? (dc as dynamic).doctor_name;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : 'Unknown Doctor';
    }

    String _department() {
      final v = (dc as dynamic).departmentName ?? (dc as dynamic).department_name;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    String _ward() {
      final v = (dc as dynamic).wardName ?? (dc as dynamic).ward_name;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    String _bed() {
      final v = (dc as dynamic).bedName ?? (dc as dynamic).bed_name;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    String _admissionType() {
      final v = (dc as dynamic).admissionType ?? (dc as dynamic).admission_type;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    String _type() {
      final v = (dc as dynamic).type;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    bool _isDischarged() {
      final v = (dc as dynamic).dischargeStatus ?? (dc as dynamic).discharge_status;
      if (v is int) return v != 0;
      if (v is num) return v.toInt() != 0;
      if (v is String) return v == '1' || v.toLowerCase() == 'true';
      return false;
    }

    String _admitIso() {
      final v = (dc as dynamic).admissionDate ?? (dc as dynamic).admission_date;
      return v?.toString() ?? '';
    }

    String _formatDateTime(String? iso) {
      if (iso == null || iso.isEmpty) return '—';
      final d = DateTime.tryParse(iso);
      if (d == null) return iso;
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      final dd = d.day.toString().padLeft(2, '0');
      final mm = months[d.month - 1];
      final yyyy = d.year.toString();
      final hh = d.hour.toString().padLeft(2, '0');
      final min = d.minute.toString().padLeft(2, '0');
      return '$dd $mm $yyyy • $hh:$min';
    }

    String _insuranceIdText() {
      final v = (dc as dynamic).insuranceId ?? (dc as dynamic).insurance_id;
      return v == null ? '' : 'Insurance ID: $v';
    }

    String _packageType() {
      final v = (dc as dynamic).packageType ?? (dc as dynamic).package_type;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '';
    }

    String _packageName() {
      final v = (dc as dynamic).packageName ?? (dc as dynamic).packageName;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '';
    }

    final admitted = !_isDischarged();
    final statusColor = admitted ? Colors.orange : Colors.green;
    final apptText = _formatDateTime(_admitIso());
    final idText = ((dc as dynamic).id)?.toString() ?? '—';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, // SOLID WHITE CARD
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
            // Leading circular gradient with tiny ID or 'DC'
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
                  _circleText(idText),
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
                  // Department + Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _department(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: statusColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          admitted ? 'Admitted' : 'Discharged',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Doctor
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                         "Dr. ${_doctorName()}",
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

                  // Date & Type & Admission Type
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event, size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text(apptText, style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
                        ],
                      ),
                      _chip(icon: Icons.category_outlined, label: _type().toUpperCase()),
                      if (_admissionType().isNotEmpty && _admissionType() != '—')
                        _chip(icon: Icons.local_hospital_outlined, label: _admissionType()),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Ward/Bed row
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _tag(icon: Icons.apartment_outlined, label: _ward()),
                      _tag(icon: Icons.bed_outlined, label: _bed()),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Package & Insurance chips (if any)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_packageType().isNotEmpty)
                        _chip(icon: Icons.medical_services_outlined, label: _packageType()),
                      if (_packageName().isNotEmpty)
                        _chip(icon: Icons.label_important_outline, label: _packageName()),
                      finalInsurance(_insuranceIdText()),
                    ].whereType<Widget>().toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? finalInsurance(String txt) {
    if (txt.isEmpty) return null;
    return _chip(icon: Icons.shield_outlined, label: txt);
  }

  static String _circleText(String id) {
    final digits = RegExp(r'\d+').allMatches(id).map((m) => m.group(0)!).join();
    if (digits.isEmpty) return 'DC';
    return digits.length <= 3 ? digits : digits.substring(digits.length - 3);
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
}

class _FilterBar extends StatelessWidget {
  final String status;
  final String type;
  final String date;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onDateChanged;

  const _FilterBar({
    required this.status,
    required this.type,
    required this.date,
    required this.onStatusChanged,
    required this.onTypeChanged,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _segmentedRow(
          label: 'Status',
          items: const ['All', 'Admitted', 'Discharged'],
          value: status,
          onChanged: onStatusChanged,
        ),
        const SizedBox(height: 8),
        _segmentedRow(
          label: 'Type',
          items: const ['All', 'New', 'Old'],
          value: type,
          onChanged: onTypeChanged,
        ),
        const SizedBox(height: 8),
        _segmentedRow(
          label: 'Date',
          items: const ['All', 'Today', 'Upcoming', 'Past'],
          value: date,
          onChanged: onDateChanged,
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
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
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
            fontWeight:selected? FontWeight.w700 : FontWeight.w600,
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

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.event_busy_outlined,
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
                  const Icon(Icons.tune_rounded, size: 20, color: Colors.indigo),
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
                    turns: expanded ? 0.5 : 0.0, // 0 = down, 0.5 = up
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // Search always visible
          searchField,

          // Smooth expand/collapse
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



