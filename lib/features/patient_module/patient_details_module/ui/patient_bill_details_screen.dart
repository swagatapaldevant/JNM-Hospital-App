import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class PatientBillsListScreen extends StatefulWidget {
  final List<BillDetail> bills;
  const PatientBillsListScreen({super.key, required this.bills});

  @override
  State<PatientBillsListScreen> createState() => _PatientBillsListScreenState();
}

class _PatientBillsListScreenState extends State<PatientBillsListScreen> {
  final TextEditingController _search = TextEditingController();
  String _statusFilter = 'All'; // All | Done | Pending
  late List<BillDetail> _sorted;

  @override
  void initState() {
    super.initState();
    _sorted = [...widget.bills]..sort((a, b) {
      final ad = _safeDate(a.billDate);
      final bd = _safeDate(b.billDate);
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
    final filtered = _applyFilters(_sorted, _search.text, _statusFilter);
    final summary = _summaryStats(filtered);

    return PatientDetailsScreenLayout(
     
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                _roundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Bill List",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
        delegate: SliverChildListDelegate.fixed([
          const SizedBox(height: 16),

          // ---- Summary Bar ----
          _GlassCard(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                _summaryTile(
                  icon: Icons.receipt_long,
                  label: 'Bills',
                  value: '${filtered.length}',
                  color: Colors.indigo,
                ),
                const SizedBox(width: 12),
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

          // ---- Search & Filters ----
          _GlassCard(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              children: [
                _SearchField(
                  controller: _search,
                  hint: 'Search by ID, section or doctor…',
                  onChanged: (s) => setState(() {}),
                ),
                const SizedBox(height: 10),
                _FilterRow(
                  value: _statusFilter,
                  onChanged: (v) => setState(() => _statusFilter = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ---- Empty state ----
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: _EmptyState(
                title: 'No bills found',
                subtitle:
                'Try clearing filters or searching with a different term.',
              ),
            ),

          // ---- Bills list ----
          ...filtered.map((b) => Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _BillTile(
              bill: b,
              onTap: () {
                // HapticFeedback.selectionClick();
                // Navigator.pushNamed(
                //   context,
                //   RouteGenerator.kPatientBillDetailsScreen,
                //   arguments: b,
                // );
              },
            ),
          )),
          const SizedBox(height: 32),
        ]),
      ),]
    );
  
  }

  // ---------------- Helpers ----------------
    Widget _roundIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkResponse(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      radius: 28,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 16,
                offset: const Offset(0, 6)),
            BoxShadow(
                color: Colors.white.withOpacity(0.85),
                blurRadius: 4,
                offset: const Offset(-2, -2)),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

}
  DateTime _safeDate(dynamic iso) {
    if (iso == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final d = DateTime.tryParse(iso.toString());
    return d ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _inr(num? v) {
    final n = (v ?? 0).toDouble();
    // simple comma formatting for thousands + 2 decimals
    final s = n.toStringAsFixed(2);
    final parts = s.split('.');
    final whole = parts[0];
    final dec = parts[1];
    final buf = StringBuffer();
    for (int i = 0; i < whole.length; i++) {
      final idx = whole.length - i;
      buf.write(whole[i]);
      final left = whole.length - i - 1;
      if (left > 0 && left % 3 == 0) buf.write(',');
      // (standard 3-grouping; replace with Indian system if needed)
    }
    return '₹${buf.toString()}.$dec';
  }

  List<BillDetail> _applyFilters(
      List<BillDetail> bills, String q, String status) {
    Iterable<BillDetail> res = bills;
    final query = q.trim().toLowerCase();

    if (query.isNotEmpty) {
      res = res.where((b) {
        final id = b.id?.toString().toLowerCase() ?? '';
        final sec = b.section?.toLowerCase() ?? '';
        final did = b.doctorId?.toString().toLowerCase() ?? '';
        return id.contains(query) || sec.contains(query) || did.contains(query);
      });
    }

    if (status != 'All') {
      res = res.where((b) {
        final s = (b.status ?? '').toLowerCase();
        if (status == 'Done') return s == 'done' || s == 'paid';
        return !(s == 'done' || s == 'paid'); // Pending
      });
    }

    return res.toList();
  }

  _Summary _summaryStats(List<BillDetail> list) {
    double totalDue = 0;
    for (final b in list) {
      totalDue += (b.dueAmount ?? 0).toDouble();
    }
    return _Summary(totalDue: totalDue);
  }


class _Summary {
  final double totalDue;
  _Summary({required this.totalDue});
}

// ===================== Widgets =====================

class _BillTile extends StatelessWidget {
  final BillDetail bill;
  final VoidCallback onTap;
  const _BillTile({required this.bill, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final id = bill.id?.toString() ?? '—';
    final section = bill.section?.toString().trim().isNotEmpty == true
        ? bill.section!
        : 'Unknown';
    final date = _formatDate(bill.billDate);
    final total = (bill.grandTotal ?? bill.total ?? 0).toDouble();
    final due = (bill.dueAmount ?? 0).toDouble();
    final status = (bill.status ?? 'Unknown').trim();
    final paid = _isPaid(status);
    final statusColor = paid ? Colors.green : Colors.orange;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white, // solid white
            border: Border.all(color: Colors.grey.shade200, width: 1), // subtle
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
            child: Row(
              children: [
                // Gradient leading
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00C2FF), // sky blue
                        Color(0xFF7F5AF0), // violet
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _circleText(id),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Section + Status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              section,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                  color: statusColor.withOpacity(0.45)),
                            ),
                            child: Text(
                              paid ? 'Paid' : (status.isEmpty ? 'Pending' : status),
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Middle row: Date
                      Row(
                        children: [
                          const Icon(Icons.date_range, size: 16, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Bottom row: Totals
                      _moneyPill(
                        icon: Icons.summarize,
                        label: 'Total',
                        value: _inr(total),
                      ),
                      const SizedBox(height: 8),
                      _moneyPill(
                        icon: Icons.account_balance_wallet,
                        label: 'Due',
                        value: _inr(due),
                        emphasize: due > 0,
                      )
                    ],
                  ),
                ),

              ],
            ),

        ),
      ),
    );
  }

  static bool _isPaid(String status) {
    final s = status.toLowerCase();
    return s == 'done' || s == 'paid' || s == 'complete' || s == 'completed';
  }

  static String _circleText(String id) {
    // Show last 3 digits or 'BILL'
    final onlyDigits = RegExp(r'\d+').allMatches(id).map((m) => m.group(0)!).join();
    if (onlyDigits.isEmpty) return 'BILL';
    return onlyDigits.length <= 3
        ? onlyDigits
        : onlyDigits.substring(onlyDigits.length - 3);
  }

  static String _formatDate(dynamic iso) {
    if (iso == null) return '—';
    final d = DateTime.tryParse(iso.toString());
    if (d == null) return iso.toString();
    // dd MMM yyyy
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final dd = d.day.toString().padLeft(2, '0');
    final mm = months[d.month - 1];
    final yyyy = d.year.toString();
    return '$dd $mm $yyyy';
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

class _FilterRow extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _FilterRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = ['All', 'Done', 'Pending'];
    return Row(
      children: [
        for (final it in items) ...[
          _segChip(
            label: it,
            selected: value == it,
            onTap: () => onChanged(it),
          ),
          const SizedBox(width: 8),
        ],
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
      child: Ink(
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
            fontWeight: selected?FontWeight.w800:FontWeight.w600,
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
      ),
    );
  }
}

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
    final content = Row(
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
    return content;
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _GlassCard({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            blurRadius: 5,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: Colors.white.withOpacity(0.82),
              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.92),
                  Colors.white.withOpacity(0.72),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// --------------- Small UI bits ---------------
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


class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.receipt_long_outlined,
            size: 64, color: Colors.blueGrey.withOpacity(0.4)),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54.withOpacity(0.8),
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
