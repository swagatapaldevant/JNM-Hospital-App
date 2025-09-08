import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details/ui/common_header.dart';
import 'common_layout.dart';

class PatientOpdDetailsScreen extends StatefulWidget {
  final List<OpdDetailsModel> opdList;
  const PatientOpdDetailsScreen({super.key, required this.opdList});

  @override
  State<PatientOpdDetailsScreen> createState() => _PatientOpdDetailsScreenState();
}

class _PatientOpdDetailsScreenState extends State<PatientOpdDetailsScreen> {
  final TextEditingController _search = TextEditingController();

  // Filters
  String _statusFilter = 'All'; // All | Paid | Pending
  String _typeFilter = 'All';   // All | New | Old
  String _dateFilter = 'All';   // All | Today | Upcoming | Past

  late List<OpdDetailsModel> _sorted;

  bool _filtersExpanded = false;


  @override
  void initState() {
    super.initState();
    _sorted = [...widget.opdList]..sort((a, b) {
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
    // keep your existing state/helpers: _sorted, _applyFilters, _summaryStats, etc.
    final filtered = _applyFilters(_sorted, _search.text, _statusFilter, _typeFilter, _dateFilter);
    final summary = _summaryStats(filtered);

    return Scaffold(
      body: PatientDetailsScreenLayout(
       
        slivers: [
          
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
        //             "OPD Visits",
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
        
        CommonHeader(title: "OPD Visits"),

          SliverList(
          delegate: SliverChildListDelegate.fixed([
            const SizedBox(height: 16),

            // ---- Summary (solid white card) ----
            _WhiteCard(
              child: Row(
                children: [
                  _summaryTile(
                    icon: Icons.local_hospital,
                    label: 'Visits',
                    value: '${filtered.length}',
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 12),
                  if(summary.totalDue > 0)
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

            // ---- Search & Filters (solid white card) ----
            // ---- Search & Filters (expandable) ----
            _ExpandableFilterCard(
              expanded: _filtersExpanded,
              onToggle: () => setState(() => _filtersExpanded = !_filtersExpanded),
              searchField: _SearchField(
                controller: _search,
                hint: 'Search doctor, department, ticket, UID…',
                onChanged: (_) => setState(() {}),
              ),
              filters: _FilterBar(
                status: _statusFilter,
                onStatusChanged: (v) => setState(() => _statusFilter = v),
                // type: _typeFilter,
                onTypeChanged: (v) => setState(() => _typeFilter = v),
                date: _dateFilter,
                onDateChanged: (v) => setState(() => _dateFilter = v),
              ),
            ),


            const SizedBox(height: 12),

            // ---- Empty state ----
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: const _EmptyState(
                  title: 'No OPD visits found',
                  subtitle: 'Try clearing filters or searching with a different term.',
                ),
              ),

            // ---- OPD list ----
            ...filtered.map((opd) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: _OpdTile(
                opd: opd,
                onTap: () {
                  HapticFeedback.selectionClick();
                  // Navigator.pushNamed(context, RouteGenerator.kSomeDetail, arguments: opd);
                },
              ),
            )),

            const SizedBox(height: 28),
          ]),
        )],
      ),
    );
  }

  // ---------------- Helpers & Mappers ----------------
  
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


  DateTime _safeDate(dynamic iso) {
    if (iso == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final d = DateTime.tryParse(iso.toString());
    return d ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  String? _getAppointmentIso(OpdDetailsModel m) {
    // handle both snake_case and camelCase from model
    // ignore: unnecessary_cast
    final dynamic dateVal =
    (m.appointmentDate ?? (m as dynamic).appointment_date) as dynamic;
    return dateVal?.toString();
  }

  String _doctorName(OpdDetailsModel m) {
    final dn = m.doctorName ?? (m as dynamic).doctor_name;
    return (dn?.toString().trim().isNotEmpty ?? false) ? dn.toString() : 'Unknown Doctor';
  }

  String _departmentName(OpdDetailsModel m) {
    final dd = m.departmentName ?? (m as dynamic).department_name;
    return (dd?.toString().trim().isNotEmpty ?? false) ? dd.toString() : '—';
  }

  int _billStatus(OpdDetailsModel m) {
    final bs = m.billStatus ?? (m as dynamic).bill_status;
    if (bs is int) return bs;
    if (bs is String) return int.tryParse(bs) ?? 0;
    return 0;
  }

  String _type(OpdDetailsModel m) {
    final t = m.type ?? (m as dynamic).type;
    return (t?.toString().trim().isNotEmpty ?? false) ? t.toString() : '—';
  }

  double _due(OpdDetailsModel m) {
    final d = m.dueAmount ?? (m as dynamic).due_amount;
    if (d is num) return d.toDouble();
    if (d is String) return double.tryParse(d) ?? 0.0;
    return 0.0;
  }

  String _uid(OpdDetailsModel m) {
    final u = m.uid ?? (m as dynamic).uid;
    return (u?.toString().trim().isNotEmpty ?? false) ? u.toString() : '—';
  }

  int _ticket(OpdDetailsModel m) {
    final t = m.ticketNo ?? (m as dynamic).ticket_no;
    if (t is int) return t;
    if (t is String) return int.tryParse(t) ?? 0;
    return 0;
  }

  List<OpdDetailsModel> _applyFilters(
      List<OpdDetailsModel> list,
      String q,
      String status,
      String type,
      String dateFilter,
      ) {
    final now = DateTime.now();
    Iterable<OpdDetailsModel> res = list;
    final query = q.trim().toLowerCase();

    if (query.isNotEmpty) {
      res = res.where((m) {
        final doctor = _doctorName(m).toLowerCase();
        final dept = _departmentName(m).toLowerCase();
        final ticket = _ticket(m).toString();
        final uid = _uid(m).toLowerCase();
        return doctor.contains(query) ||
            dept.contains(query) ||
            ticket.contains(query) ||
            uid.contains(query);
      });
    }

    if (status != 'All') {
      res = res.where((m) {
        final paid = _isPaid(_billStatus(m));
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
          final nowD = DateTime.now();
          final t = DateTime(nowD.year, nowD.month, nowD.day);
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

  _OpdSummary _summaryStats(List<OpdDetailsModel> list) {
    double totalDue = 0;
    for (final m in list) {
      totalDue += _due(m);
    }
    return _OpdSummary(totalDue: totalDue);
  }

  static bool _isPaid(int billStatus) {
    // Common mapping: 1 = Pending/Unpaid, 2 = Paid (adjust if your API differs)
    return billStatus == 2;
  }
}

class _OpdSummary {
  final double totalDue;
  _OpdSummary({required this.totalDue});
}

// ===================== UI Widgets =====================

class _OpdTile extends StatelessWidget {
  final OpdDetailsModel opd;
  final VoidCallback onTap;
  const _OpdTile({required this.opd, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Accessors to be robust for snake/camel case
    String _doctorName() {
      final dn = opd.doctorName ?? (opd as dynamic).doctor_name;
      return (dn?.toString().trim().isNotEmpty ?? false) ? dn.toString() : 'Unknown Doctor';
    }

    String _departmentName() {
      final dd = opd.departmentName ?? (opd as dynamic).department_name;
      return (dd?.toString().trim().isNotEmpty ?? false) ? dd.toString() : '—';
    }

    String _appointmentIso() {
      final v = opd.appointmentDate ?? (opd as dynamic).appointment_date;
      return v?.toString() ?? '';
    }

    int _ticket() {
      final t = opd.billingId ?? (opd as dynamic).ticket_no;
      if (t is int) return t;
      if (t is String) return int.tryParse(t) ?? 0;
      return 0;
    }

    // String _type() {
    //   final t = opd.type ?? (opd as dynamic).type;
    //   return (t?.toString().trim().isNotEmpty ?? false) ? t.toString() : '—';
    // }

    double _due() {
      final d = opd.dueAmount ?? (opd as dynamic).due_amount;
      if (d is num) return d.toDouble();
      if (d is String) return double.tryParse(d) ?? 0.0;
      return 0.0;
    }

    int _billStatus() {
      final bs = opd.billStatus ?? (opd as dynamic).bill_status;
      if (bs is int) return bs;
      if (bs is String) return int.tryParse(bs) ?? 0;
      return 0;
    }

    String _uid() {
      final u = opd.uid ?? (opd as dynamic).uid;
      return (u?.toString().trim().isNotEmpty ?? false) ? u.toString() : '—';
    }

    final statusPaid = _billStatus() == 2;
    final statusColor = statusPaid ? Colors.green : Colors.orange;
    final apptText = _formatDateTime(_appointmentIso());

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
            // Leading circular gradient with ticket
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF00C2FF),
                    Color(0xFF7F5AF0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _ticket() == 0 ? 'OPD' : _ticket().toString(),
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
                  // Row: Department + Paid/Pending
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _departmentName(),
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
                          statusPaid ? 'Paid' : 'Pending',
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
                         "Dr  ${_doctorName()}",
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
                          const Icon(Icons.event, size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text(apptText, style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
                        ],
                      ),
                      // _chip(icon: Icons.category_outlined, label: (_type()).toUpperCase()),
                      if (_uid() != '—') _chip(icon: Icons.tag, label: 'UHID: ${_uid()}'),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if(_due() > 0)
                    _moneyPill(
                      icon: Icons.account_balance_wallet,
                      label: 'Due',
                      value: _inr(_due()),
                      emphasize: _due() > 0,
                    ),
                ],
              ),
            ),
          ],
        ),
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
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
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

  Widget _moneyPill({
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
}

class _FilterBar extends StatelessWidget {
  final String status;
  // final String type;
  final String date;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onDateChanged;

  const _FilterBar({
    required this.status,
    // required this.type,
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
          child: Text(label,
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.black87)),
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
            fontWeight:selected? FontWeight.w700: FontWeight.w600,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        Icon(Icons.event_busy_outlined, size: 64, color: Colors.blueGrey.withOpacity(0.4)),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87)),
        const SizedBox(height: 8),
        Text(subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54.withOpacity(0.8), height: 1.3)),
      ],
    );
  }
}

// ---------- Small UI bits ----------
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
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.w800, color: Colors.black87)),
          ],
        ),
      ],
    );
  }
}

// ---------- Simple INR formatter ----------
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


class _ExpandableFilterCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final Widget searchField;
  final Widget filters;

  const _ExpandableFilterCard({
    required this.expanded,
    required this.onToggle,
    required this.searchField,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row (tap anywhere to toggle)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded, size: 20, color: Colors.indigo),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Search & Filters',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // chevron animates
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: expanded ? 0.5 : 0.0, // 0 -> down, 0.5 -> up
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 22, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // Search always visible
          searchField,

          // Animated expand area
          AnimatedCrossFade(
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeOut,
            sizeCurve: Curves.easeOut,
            duration: const Duration(milliseconds: 220),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
