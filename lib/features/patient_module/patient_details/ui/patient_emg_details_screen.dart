import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/ui/common_header.dart';
import 'common_layout.dart';

class PatientEmgDetailsScreen extends StatefulWidget {
  final List<EmgDetailsModel> emgList;
  const PatientEmgDetailsScreen({super.key, required this.emgList});

  @override
  State<PatientEmgDetailsScreen> createState() =>
      _PatientEmgDetailsScreenState();
}

class _PatientEmgDetailsScreenState extends State<PatientEmgDetailsScreen> {
  final TextEditingController _search = TextEditingController();

  // Filters
  String _statusFilter = 'All'; // All | Paid | Pending
  String _typeFilter = 'All'; // All | New | Old
  String _dateFilter = 'All'; // All | Today | Upcoming | Past

  late List<EmgDetailsModel> _sorted;

  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();
    _sorted = [...widget.emgList]..sort((a, b) {
        final ad = _safeDate(_getAppointmentIso(a));
        final bd = _safeDate(_getAppointmentIso(b));
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
    final filtered = _applyFilters(
        _sorted, _search.text, _statusFilter, _typeFilter, _dateFilter);
    final summary = _summaryStats(filtered);

    return Scaffold(
      body: PatientDetailsScreenLayout(
        slivers: [
          // SliverToBoxAdapter(
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
          //             "Emergency (EMG)",
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
          CommonHeader(title: "Emergency (EMG)"),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              const SizedBox(height: 16),

              // ===== Summary =====
              _WhiteCard(
                child: Row(
                  children: [
                    _summaryTile(
                      icon: Icons.emergency_outlined,
                      label: 'EMG Visits',
                      value: '${filtered.length}',
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 12),
                    if (summary.totalDue > 0)
                      Expanded(
                        child: _summaryTile(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Total Due',
                          value: _inr(summary.totalDue),
                          color: Colors.deepOrange,
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
                  hint: 'Search doctor, department, UID, billing id…',
                  onChanged: (_) => setState(() {}),
                ),
                filters: _FilterBar(
                  status: _statusFilter,
                  onStatusChanged: (v) => setState(() => _statusFilter = v),
                  //type: _typeFilter,
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
                    title: 'No EMG records',
                    subtitle:
                        'Try clearing filters or searching with a different term.',
                  ),
                ),

              // ===== List =====
              ...filtered.map((e) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: _EmgTile(
                      emg: e,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        // Navigate to a detailed EMG view if you add one:
                        // Navigator.pushNamed(context, RouteGenerator.kEmgDetail, arguments: e);
                      },
                    ),
                  )),

              const SizedBox(height: 28),
            ]),
          )
        ],
      ),
    );
  }

  // ---------------- Helpers & accessors ----------------

  DateTime _safeDate(dynamic iso) {
    if (iso == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final d = DateTime.tryParse(iso.toString());
    return d ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  String? _getAppointmentIso(EmgDetailsModel m) {
    final v = (m as dynamic).appointmentDate ?? (m as dynamic).appointment_date;
    return v?.toString();
  }

  String _doctor(EmgDetailsModel m) {
    final v = (m as dynamic).doctorName ?? (m as dynamic).doctor_name;
    return (v?.toString().trim().isNotEmpty ?? false)
        ? v.toString()
        : 'Unknown Doctor';
  }

  String _department(EmgDetailsModel m) {
    final v = (m as dynamic).departmentName ?? (m as dynamic).department_name;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  String _type(EmgDetailsModel m) {
    final v = (m as dynamic).type;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  String _uid(EmgDetailsModel m) {
    final v = (m as dynamic).uid;
    return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
  }

  double _due(EmgDetailsModel m) {
    final v = (m as dynamic).dueAmount ?? (m as dynamic).due_amount;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  int _billStatus(EmgDetailsModel m) {
    final v = (m as dynamic).billStatus ?? (m as dynamic).bill_status;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is num) return v.toInt();
    return 0;
  }

  List<EmgDetailsModel> _applyFilters(
    List<EmgDetailsModel> list,
    String q,
    String status,
    String type,
    String dateFilter,
  ) {
    final now = DateTime.now();
    Iterable<EmgDetailsModel> res = list;
    final query = q.trim().toLowerCase();

    if (query.isNotEmpty) {
      res = res.where((m) {
        final doctor = _doctor(m).toLowerCase();
        final dept = _department(m).toLowerCase();
        final uid = _uid(m).toLowerCase();
        final billingId =
            ((m as dynamic).billingId ?? (m as dynamic).billing_id)
                    ?.toString()
                    .toLowerCase() ??
                '';
        final id = ((m as dynamic).id)?.toString().toLowerCase() ?? '';
        final t = _type(m).toLowerCase();
        return doctor.contains(query) ||
            dept.contains(query) ||
            uid.contains(query) ||
            billingId.contains(query) ||
            id.contains(query) ||
            t.contains(query);
      });
    }

    if (status != 'All') {
      res = res.where((m) {
        final paid = _billStatus(m) == 2; // 2 => Paid (per your sample)
        return status == 'Paid' ? paid : !paid;
      });
    }

    if (type != 'All') {
      res = res.where((m) => _type(m).toLowerCase() == type.toLowerCase());
    }

    if (dateFilter != 'All') {
      res = res.where((m) {
        final d = _safeDate(_getAppointmentIso(m));
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

  _EmgSummary _summaryStats(List<EmgDetailsModel> list) {
    double totalDue = 0;
    for (final m in list) {
      totalDue += _due(m);
    }
    return _EmgSummary(totalDue: totalDue);
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

class _EmgSummary {
  final double totalDue;
  _EmgSummary({required this.totalDue});
}

// ===================== UI Widgets =====================

class _EmgTile extends StatelessWidget {
  final EmgDetailsModel emg;
  final VoidCallback onTap;
  const _EmgTile({required this.emg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    String _doctor() {
      final v = (emg as dynamic).doctorName ?? (emg as dynamic).doctor_name;
      return (v?.toString().trim().isNotEmpty ?? false)
          ? v.toString()
          : 'Unknown Doctor';
    }

    String _department() {
      final v =
          (emg as dynamic).departmentName ?? (emg as dynamic).department_name;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    String _uid() {
      final v = (emg as dynamic).uid;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    String _type() {
      final v = (emg as dynamic).type;
      return (v?.toString().trim().isNotEmpty ?? false) ? v.toString() : '—';
    }

    int _billStatus() {
      final v = (emg as dynamic).billStatus ?? (emg as dynamic).bill_status;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? 0;
      if (v is num) return v.toInt();
      return 0;
    }

    double _due() {
      final v = (emg as dynamic).dueAmount ?? (emg as dynamic).due_amount;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    String _appointmentIso() {
      final v =
          (emg as dynamic).appointmentDate ?? (emg as dynamic).appointment_date;
      return v?.toString() ?? '';
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

    final paid = _billStatus() == 2;
    final statusColor = paid ? Colors.green : Colors.orange;
    final apptText = _formatDateTime(_appointmentIso());
    final due = _due();

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
            // Gradient circle with UID tail
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
                  _circleText(_uid()),
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
                  // Department + Paid/Pending
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(999),
                          border:
                              Border.all(color: statusColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          paid ? 'Paid' : 'Pending',
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
                          "Dr  ${_doctor()}",
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

                  // Date & Type & UID
                  Wrap(
                    spacing: 10,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.event,
                              size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text(apptText,
                              style: const TextStyle(
                                  fontSize: 12.5, color: Colors.black54)),
                        ],
                      ),
                      // if (_type().trim().isNotEmpty && _type() != '—')
                      //   _chip(
                      //       icon: Icons.category_outlined,
                      //       label: _type().toUpperCase()),
                      if (_uid() != '—')
                        _chip(icon: Icons.tag, label: 'UHID: ${_uid()}'),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Due pill
                  if (due > 0)
                    _moneyPill(
                      icon: Icons.account_balance_wallet,
                      label: 'Due',
                      value: _inr(due),
                      emphasize: due > 0,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _circleText(String uid) {
    final digits =
        RegExp(r'\d+').allMatches(uid).map((m) => m.group(0)!).join();
    if (digits.isEmpty) return 'EMG';
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

  static Widget _moneyPill({
    required IconData icon,
    required String label,
    required String value,
    bool emphasize = false,
  }) {
    final color = emphasize ? Colors.red : Colors.blueGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: color.shade700,
            ),
          ),
        ],
      ),
    );
  }

  static String _inr(num? v) {
    final n = (v ?? 0).toDouble();
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
}

// ===== Filters/Search/Containers/Empty =====

class _FilterBar extends StatelessWidget {
  final String status;
  //final String type;
  final String date;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onDateChanged;

  const _FilterBar({
    required this.status,
    //required this.type,
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
          items: const ['All', 'Paid', 'Pending'],
          value: status,
          onChanged: onStatusChanged,
        ),
        // const SizedBox(height: 8),
        // _segmentedRow(
        //   label: 'Type',
        //   items: const ['All', 'New', 'Old'],
        //   value: type,
        //   onChanged: onTypeChanged,
        // ),
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
    final color = selected ? Colors.indigo : Colors.blueGrey;
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
        Icon(Icons.emergency_outlined,
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

// ---------- Shared summary INR ----------
String _inr(num? v) {
  final n = (v ?? 0).toDouble();
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
                  color: Colors.black54,
                )),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                )),
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
