import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jnm_hospital_app/core/services/routeGenerator/route_generator.dart';
import 'package:jnm_hospital_app/features/patient_module/model/patient_details/patient_details_model.dart';
import 'package:jnm_hospital_app/features/patient_module/patient_details_module/ui/common_layout.dart';

class PatientReceiptsListScreen extends StatefulWidget {
  final List<ReceiptDetail> receipts;
  const PatientReceiptsListScreen({super.key, required this.receipts});

  @override
  State<PatientReceiptsListScreen> createState() => _PatientReceiptsListScreenState();
}

class _PatientReceiptsListScreenState extends State<PatientReceiptsListScreen> {
  final TextEditingController _search = TextEditingController();
  String _modeFilter = 'All'; // All | Cash | Card | UPI | Cheque | Other
  late List<ReceiptDetail> _sorted;

  @override
  void initState() {
    super.initState();
    _sorted = [...widget.receipts]..sort((a, b) {
      final ad = _safeDate(a.paymentDate);
      final bd = _safeDate(b.paymentDate);
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
    final filtered = _applyFilters(_sorted, _search.text, _modeFilter);
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
                    "Receipts",
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
                  label: 'Receipts',
                  value: '${filtered.length}',
                  color: Colors.indigo,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryTile(
                    icon: Icons.attach_money,
                    label: 'Total Received',
                    value: _inr(summary.totalReceived),
                    color: Colors.green,
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
                  hint: 'Search by Receipt ID, Billing ID, Section, Received by…',
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                _ModeFilterRow(
                  value: _modeFilter,
                  onChanged: (v) => setState(() => _modeFilter = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ---- Empty state ----
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: const _EmptyState(
                title: 'No receipts found',
                subtitle: 'Try clearing filters or searching with a different term.',
              ),
            ),

          // ---- Receipts list ----
          ...filtered.map((r) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _ReceiptTile(
              receipt: r,
              onTap: () {
                HapticFeedback.selectionClick();
                // Navigator.pushNamed(
                //   context,
                //   RouteGenerator.kPatientReceiptDetailsScreen,
                //   arguments: r,
                // );
              },
            ),
          )),
          const SizedBox(height: 32),
        ]),
      )],
    );
  }

  // ---------------- Helpers ----------------

  DateTime _safeDate(dynamic iso) {
    if (iso == null) return DateTime.fromMillisecondsSinceEpoch(0);
    final d = DateTime.tryParse(iso.toString());
    return d ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  List<ReceiptDetail> _applyFilters(
      List<ReceiptDetail> receipts, String q, String mode) {
    Iterable<ReceiptDetail> res = receipts;
    final query = q.trim().toLowerCase();

    if (query.isNotEmpty) {
      res = res.where((r) {
        final rid = r.id?.toString().toLowerCase() ?? '';
        final bid = r.billingId?.toString().toLowerCase() ?? '';
        final sec = r.section?.toLowerCase() ?? '';
        final by = r.paymentRecivedByName?.toLowerCase() ?? '';
        return rid.contains(query) ||
            bid.contains(query) ||
            sec.contains(query) ||
            by.contains(query);
      });
    }

    if (mode != 'All') {
      res = res.where((r) {
        final m = (r.paymentMode ?? '').toLowerCase();
        switch (mode) {
          case 'Cash':
            return m == 'cash';
          case 'Card':
            return m == 'card';
          case 'UPI':
            return m == 'upi';
          case 'Cheque':
            return m == 'cheque';
          default:
            return m.isEmpty ||
                !(m == 'cash' || m == 'card' || m == 'upi' || m == 'cheque');
        }
      });
    }

    return res.toList();
  }

  _ReceiptSummary _summaryStats(List<ReceiptDetail> list) {
    double totalReceived = 0;
    for (final r in list) {
      totalReceived += (r.paymentAmount ?? 0).toDouble();
    }
    return _ReceiptSummary(totalReceived: totalReceived);
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

class _ReceiptSummary {
  final double totalReceived;
  _ReceiptSummary({required this.totalReceived});
}

// ===================== Widgets =====================

class _ReceiptTile extends StatelessWidget {
  final ReceiptDetail receipt;
  final VoidCallback onTap;
  const _ReceiptTile({required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final id = receipt.id?.toString() ?? '—';
    final section = receipt.section?.trim().isNotEmpty == true
        ? receipt.section!
        : 'Unknown';
    final date = _formatDate(receipt.paymentDate);
    final amount = (receipt.paymentAmount ?? 0).toDouble();
    final mode = (receipt.paymentMode ?? '—').trim();
    final modeStyle = _modeStyle(mode);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white, // 👈 pure white background
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
              // Leading circle with gradient
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      modeStyle.color,
                      modeStyle.color.withOpacity(0.65),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: modeStyle.color.withOpacity(0.25),
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
                    // Section + Mode
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
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: modeStyle.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: modeStyle.color.withOpacity(0.45)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(modeStyle.icon,
                                  size: 14, color: modeStyle.color),
                              const SizedBox(width: 6),
                              Text(
                                modeStyle.label,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: modeStyle.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Date + Received By
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.date_range,
                                size: 16, color: Colors.blueGrey),
                            const SizedBox(width: 6),
                            Text(
                              date,
                              style: const TextStyle(
                                  fontSize: 12.5, color: Colors.black54),
                            ),
                          ],
                        ),
                        if ((receipt.paymentRecivedByName ?? '')
                            .trim()
                            .isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person,
                                  size: 16, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text(
                                receipt.paymentRecivedByName!,
                                style: const TextStyle(
                                    fontSize: 12.5, color: Colors.black54),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Amount
                    _amountPill(
                      icon: Icons.attach_money,
                      label: 'Amount',
                      value: _inr(amount),
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  static String _circleText(String id) {
    // Show last 3 digits or 'RCT'
    final onlyDigits = RegExp(r'\d+').allMatches(id).map((m) => m.group(0)!).join();
    if (onlyDigits.isEmpty) return 'RCT';
    return onlyDigits.length <= 3
        ? onlyDigits
        : onlyDigits.substring(onlyDigits.length - 3);
  }

  static String _formatDate(dynamic iso) {
    if (iso == null) return '—';
    final d = DateTime.tryParse(iso.toString());
    if (d == null) return iso.toString();
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
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

  Widget _amountPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
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
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  _ModeStyle _modeStyle(String mode) {
    switch (mode.toLowerCase()) {
      case 'cash':
        return _ModeStyle(label: 'Cash', color: Colors.green, icon: Icons.attach_money);
      case 'card':
        return _ModeStyle(label: 'Card', color: Colors.blue, icon: Icons.credit_card);
      case 'upi':
        return _ModeStyle(label: 'UPI', color: Colors.purple, icon: Icons.qr_code);
      case 'cheque':
        return _ModeStyle(label: 'Cheque', color: Colors.orange, icon: Icons.receipt_long);
      default:
        return _ModeStyle(label: mode.isEmpty ? 'Other' : mode, color: Colors.blueGrey, icon: Icons.payment);
    }
  }
}

class _ModeStyle {
  final String label;
  final Color color;
  final IconData icon;
  _ModeStyle({required this.label, required this.color, required this.icon});
}

class _ModeFilterRow extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  const _ModeFilterRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = ['All', 'Cash', 'Card', 'UPI', 'Cheque', 'Other'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
      ),
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide(color: Colors.indigo),
        ),
      ),
    );
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

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.receipt_long_outlined, size: 64, color: Colors.blueGrey.withOpacity(0.4)),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black54.withOpacity(0.8), height: 1.3),
        ),
      ],
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

// ---------- Simple INR formatter for summary ----------
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
