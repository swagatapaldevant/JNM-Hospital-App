import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/doctors_payout_module/model/payout_details_model.dart';

class DoctorPayoutDetailsScreen extends StatefulWidget {
  final String id;
  final String selectedDate;

  const DoctorPayoutDetailsScreen({
    super.key,
    required this.id,
    required this.selectedDate,
  });

  @override
  State<DoctorPayoutDetailsScreen> createState() =>
      _DoctorPayoutDetailsScreenState();
}

class _DoctorPayoutDetailsScreenState extends State<DoctorPayoutDetailsScreen> {
  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();

  bool isLoading = false;
  bool isVisible = false;
  final ScrollController _scrollController = ScrollController();

  // Data
  List<PayoutDetailRow> _rows = [];

  // Summary
  String _doctorName = "";
  int _patientCount = 0; // unique patients
  List<String> _sections = [];

  @override
  void initState() {
    super.initState();
    getDoctorsPayoutDetailsData();
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Column(
        children: [
          CommonHeaderForReportModule(
            headingName: 'PATIENT LIST',
            onSearchTap: () => setState(() => isVisible = true),
            isVisibleFilter: false,
            isVisibleSearch: false,
            filterTap: () {},
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () => getDoctorsPayoutDetailsData(showLoader: false),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      // ===== Summary Card =====
                      if (isLoading) const SizedBox.shrink() else
                        SummaryCard(
                          doctorName: _doctorName.isEmpty ? "—" : _doctorName,
                          patients: _patientCount,
                          sections: _sections,
                          dateLabel: _prettyDate(widget.selectedDate),
                        ),

                      const SizedBox(height: 12),

                      // ===== Table =====
                      if (isLoading) ...[
                        const SizedBox(height: 40),
                        const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: 40),
                      ] else if (_rows.isEmpty) ...[
                        const SizedBox(height: 24),
                        const _EmptyState(
                          title: "No records found",
                          subtitle:
                          "There are no bills for this doctor on the selected date.",
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        _BillsTable(rows: _rows),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDoctorsPayoutDetailsData({bool showLoader = true}) async {
    if (showLoader) setState(() => isLoading = true);

    final Map<String, dynamic> requestData = {
      // include any other filters your API expects
    };

    final resource = await _adminReportUsecase.getDoctorPayoutDetailsData(
      requestData: requestData,
      id: widget.id,
      date: widget.selectedDate,
    );

    if (resource.status == STATUS.SUCCESS) {
      try {
        dynamic body = resource.data;
        if (body is String) body = jsonDecode(body);

        List<dynamic> list;
        if (body is List) {
          list = body;
        } else if (body is Map && body['data'] is List) {
          list = body['data'] as List;
        } else if (body is Map && body['result'] is List) {
          list = body['result'] as List;
        } else {
          list = const [];
        }

        final rows = list
            .map((e) => PayoutDetailRow.fromMap(
          (e as Map).map((k, v) => MapEntry(k.toString(), v)),
        ))
            .toList();

        final doctorName = rows.isNotEmpty ? rows.first.doctorName : "";
        final uniquePatients = rows.map((e) => e.patientId).toSet().length;
        final sections = rows.map((e) => e.section).toSet().toList()..sort();

        setState(() {
          _rows = rows;
          _doctorName = doctorName;
          _patientCount = uniquePatients;
          _sections = sections;
          if (showLoader) isLoading = false;
        });
      } catch (e) {
        if (showLoader) setState(() => isLoading = false);
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "Failed to parse response: $e",
          messageType: 4,
        );
      }
    } else {
      if (showLoader) setState(() => isLoading = false);
      CommonUtils().flutterSnackBar(
        context: context,
        mes: resource.message ?? "",
        messageType: 4,
      );
    }
  }

  String _prettyDate(String ymd) {
    // Expects "yyyy-MM-dd"
    try {
      final dt = DateTime.parse(ymd);
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}";
    } catch (_) {
      return ymd;
    }
  }
}
/// =======================
/// SUMMARY CARD
/// =======================
class SummaryCard extends StatelessWidget {
  final String doctorName;
  final int patients;
  final List<String> sections;
  final String dateLabel;

  const SummaryCard({
    super.key,
    required this.doctorName,
    required this.patients,
    required this.sections,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(doctorName);

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
                // Doctor name
                Text(
                  doctorName,
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
                    _pill(Icons.calendar_today_rounded, dateLabel),
                    _pill(Icons.groups_rounded, "$patients Patients"),
                    if (sections.isEmpty)
                      _pill(Icons.category_rounded, "No Section")
                    else
                      ...sections
                          .map((s) => _pill(Icons.category_rounded, s))
                          .toList(),

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

/// =======================
/// TABLE CARD
/// =======================
class _BillsTable extends StatelessWidget {
  final List<PayoutDetailRow> rows;

  const _BillsTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    // Column flexes: [BillID, Section, Patient, DocPaid]
    const flexes = [2, 2, 4, 2];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: const Color(0xFFEFF3FA)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5FF),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE6ECFB)),
              ),
            ),
            child: Row(
              children: [
                _headCell("Bill ID", flex: flexes[0]),
                _headCell("Section", flex: flexes[1]),
                _headCell("Patient Name", flex: flexes[2]),
                _headCell("Doctor Paid", flex: flexes[3], alignEnd: true),
              ],
            ),
          ),

          // Rows
          ...List.generate(rows.length, (i) {
            final r = rows[i];
            final stripe = i.isOdd
                ? Colors.grey.withOpacity(0.035)
                : Colors.transparent;
            return Container(
              color: stripe,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  _cell("#${r.billingId}", flex: flexes[0]),
                  _chipCell(r.section.isEmpty ? "-" : r.section, flex: flexes[1]),
                  _cell("${r.name.isEmpty ? "-" : r.name}\n(${r.patientId.toString()})",
                      flex: flexes[2], overflow: TextOverflow.ellipsis),
                  _cell(_inr(r.commissionAmount),
                      flex: flexes[3], alignEnd: true, isStrong: true),
                ],
              ),
            );
          }),

          // Footer (optional total)
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
                  "Total: ${_inr(rows.fold<double>(0, (s, r) => s + r.commissionAmount))}",
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

  static Widget _headCell(String text, {required int flex, bool alignEnd = false}) {
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
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  static Widget _cell(
      String text, {
        required int flex,
        bool alignEnd = false,
        bool isStrong = false,
        TextOverflow? overflow,
      }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: overflow,
          style: TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontWeight: isStrong ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static Widget _chipCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE3E9FA),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFE8ECF5)),
          ),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  static String _inr(num v) => "₹${v.toStringAsFixed(2)}";
}

/// =======================
/// EMPTY STATE
/// =======================
class _EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _EmptyState({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_rounded, color: Color(0xFF9CA3AF), size: 34),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
