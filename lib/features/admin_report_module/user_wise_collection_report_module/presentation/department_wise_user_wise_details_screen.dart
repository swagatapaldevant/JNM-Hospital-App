import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
// Re-use the Payment model you already have:
import 'package:jnm_hospital_app/features/admin_report_module/user_wise_collection_report_module/presentation/user_wise_collection_report_screen.dart';

class DepartmentWiseUserWiseDetailsScreen extends StatefulWidget {
  final String userName;
  final int userId;
  final String department;
  final String fromDate;
  final String toDate;
  final List<Payment> payments;

  const DepartmentWiseUserWiseDetailsScreen({
    super.key,
    required this.userName,
    required this.userId,
    required this.department,
    required this.fromDate,
    required this.toDate,
    required this.payments,
  });

  @override
  State<DepartmentWiseUserWiseDetailsScreen> createState() =>
      _DepartmentWiseUserWiseDetailsScreenState();
}

class _DepartmentWiseUserWiseDetailsScreenState
    extends State<DepartmentWiseUserWiseDetailsScreen> {
  late double _cash;
  late double _bank;
  late double _total;

  @override
  void initState() {
    super.initState();
    _summarize();
  }

  void _summarize() {
    double c = 0, b = 0, t = 0;
    for (final p in widget.payments) {
      if (p.mode.toLowerCase() == 'cash') {
        c += p.amount;
      } else {
        b += p.amount;
      }
      t += p.amount;
    }
    _cash = c;
    _bank = b;
    _total = t;
  }

  Future<void> _onRefresh() async {
    // No API call here since data is passed in; just a light UX refresh.
    setState(() {
      _summarize();
    });
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  String _inr(num v) => "₹${v.toStringAsFixed(2)}";

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Column(
        children: [
          CommonHeaderForReportModule(
            headingName: 'PATIENT DETAILS',
            onSearchTap: () {},
            isVisibleFilter: false,
            isVisibleSearch: false,
            filterTap: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    // ===== Summary Card (matches DoctorPayoutDetails style) =====
                    _SummaryCardDept(
                      userName: widget.userName.toUpperCase(),
                      department: widget.department,
                      dateRange: "${widget.fromDate} - ${widget.toDate}",
                      txnCount: widget.payments.length,
                    ),

                    const SizedBox(height: 12),

                    // ===== Small Stats (Cash / Bank / Total) =====
                    Row(
                      children: [
                        _summaryTile("Cash", _inr(_cash)),
                        const SizedBox(width: 8),
                        _summaryTile("Bank", _inr(_bank)),
                        const SizedBox(width: 8),
                        _summaryTile("Total", _inr(_total), highlight: true),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ===== Table (BillsTable look) =====
                    _PaymentsTableStyled(payments: widget.payments),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8ECF5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}

/// ======= Summary card (avatar + chips) =======
class _SummaryCardDept extends StatelessWidget {
  final String userName;
  final String department;
  final String dateRange;
  final int txnCount;

  const _SummaryCardDept({
    required this.userName,
    required this.department,
    required this.dateRange,
    required this.txnCount,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(userName);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFEEF2FF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF06B6D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _pill(Icons.category_rounded, department),
                    _pill(Icons.calendar_today_rounded, dateRange),
                    _pill(Icons.receipt_long_rounded, "$txnCount Transactions"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return "?";
    final first = parts.first.isNotEmpty ? parts.first[0] : "";
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : "";
    return (first + last).toUpperCase();
  }

  static Widget _pill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// ======= Table with BillsTable look =======
class _PaymentsTableStyled extends StatelessWidget {
  final List<Payment> payments;
  const _PaymentsTableStyled({required this.payments});

  @override
  Widget build(BuildContext context) {
    final rows = [...payments]..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    const flexes = [3, 5, 3, 3]; // Time | Patient | Mode | Amount

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF3FA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF2F5FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE6ECFB)),
              ),
            ),
            child: Row(
              children: [
                _head("Time", flex: flexes[0]),
                _head("Patient", flex: flexes[1]),
                _head("Mode", flex: flexes[2]),
                _head("Amount", alignEnd: true, flex: flexes[3]),
              ],
            ),
          ),

          // Rows
          if (rows.isEmpty)
            Container(
              height: 120,
              alignment: Alignment.center,
              child: const Text(
                "No transactions",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
            )
          else
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rows.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF3F5FB),
              ),
              itemBuilder: (_, i) {
                final r = rows[i];
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      _cell("${_fmtDate(r.dateTime)}\n ${_fmtTime(r.dateTime)}", flex: flexes[0]),
                      _cell(r.patientName.isEmpty ? "-" : r.patientName.toUpperCase(),
                          flex: flexes[1], overflow: TextOverflow.ellipsis),
                      _cell(r.mode, flex: flexes[2]),
                      _cell("₹${r.amount.toStringAsFixed(2)}",
                          flex: flexes[3], alignEnd: true, bold: true),
                    ],
                  ),
                );
              },
            ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE6ECFB))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${rows.length} record${rows.length == 1 ? "" : "s"}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  "Total: ₹${rows.fold<double>(0, (s, r) => s + r.amount).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _head(String text, {required int flex, bool alignEnd = false}) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1D4ED8),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  static Widget _cell(
      String text, {
        required int flex,
        bool alignEnd = false,
        bool bold = false,
        TextOverflow? overflow,
      }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 2,
          overflow: overflow,
          style: TextStyle(
            fontSize: 9,
            color: Colors.black87,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static String _fmtDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}";
    // e.g., 03 Sep 2025
  }

  static String _fmtTime(DateTime dt) {
    if (dt.millisecondsSinceEpoch == 0) return "-";
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return "$h:$m $ampm";
  }
}
