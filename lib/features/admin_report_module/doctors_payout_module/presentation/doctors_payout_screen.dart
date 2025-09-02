import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/services/localStorage/shared_pref.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/collection_report_module/widget/custom_date_picker_for_collection_module.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/common_header.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/doctors_payout_module/model/doctor_payout_model.dart';

class DoctorsPayoutScreen extends StatefulWidget {
  const DoctorsPayoutScreen({super.key});

  @override
  State<DoctorsPayoutScreen> createState() => _DoctorsPayoutScreenState();
}

enum _ChartMode { docPaid, patients }

class _DoctorsPayoutScreenState extends State<DoctorsPayoutScreen> {
  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  bool isLoading = false;
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  final ScrollController _scrollController = ScrollController();
  List<DoctorCollectionData> _doctors = [];

  // Chart mode
  _ChartMode _mode = _ChartMode.docPaid;

  @override
  void initState() {
    super.initState();

    // 1) Pre-fill both pickers with today's date (yyyy-MM-dd)
    final today = _todayYMD();
    selectedFromDate = today;
    selectedToDate = today;

    // 2) Fire the initial search after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDoctorsPayoutWiseData();
    });
  }

  /// Helper: today's date as yyyy-MM-dd
  String _todayYMD() {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: Column(
        children: [
          CommonHeaderForReportModule(
            headingName: 'DOCTOR\'S PAYOUT',
            onSearchTap: () {
              setState(() {
                isVisible = true;
              });
            },
            isVisibleFilter: false,
            isVisibleSearch: false,
            filterTap: () {},
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPadding),
                child: Column(
                  children: [
                    SizedBox(height: AppDimensions.contentGap3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomDatePickerFieldForCollectionModule(
                            selectedDate: selectedFromDate,
                            disallowFutureDates: true,
                            onDateChanged: (String value) {
                              setState(() {
                                selectedFromDate = value;
                              });
                            },
                            placeholderText: 'From date',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomDatePickerFieldForCollectionModule(
                            selectedDate: selectedToDate,
                            disallowFutureDates: true,
                            onDateChanged: (String value) {
                              setState(() {
                                selectedToDate = value;
                              });
                            },
                            placeholderText: 'To date',
                          ),
                        ),
                        SizedBox(width: 10),
                        Bounceable(
                          onTap: () {
                            getDoctorsPayoutWiseData();
                          },
                          child: Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: AppColors.arrowBackground,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 0,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: AppDimensions.contentGap3),
                    // === Switchable Chart ===
                    if (!isLoading && _doctors.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.only(left:12, top: 12, right: 12, bottom: 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F7FB),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Toggle
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _ChartToggle(
                                mode: _mode,
                                onChanged: (m) => setState(() => _mode = m),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Subtitle (range)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "$selectedFromDate → $selectedToDate",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Chart
                            if (_mode == _ChartMode.docPaid)
                              DocPaidBarChart(doctors: _doctors)
                            else
                              OldNewPatientsBarChart(doctors: _doctors),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (isLoading) ...[
                      const SizedBox(height: 40),
                      const Center(child: CircularProgressIndicator()),
                      const SizedBox(height: 40),
                    ] else if (_doctors.isEmpty) ...[
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          "No payout records for the selected date(s).",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      //const SizedBox(height: 6),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _doctors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 0),
                        itemBuilder: (context, i) {
                          final d = _doctors[i];
                          return DoctorCollectionCard(
                            data: d,
                            onTap: () {
                              // TODO: navigate to doctor detail if needed
                              // Navigator.push(...);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDoctorsPayoutWiseData() async {
    if (selectedFromDate.isEmpty || selectedToDate.isEmpty) {
      CommonUtils().flutterSnackBar(
        context: context,
        mes: "Please select both From and To dates",
        messageType: 4,
      );
      return;
    }

    setState(() => isLoading = true);

    final requestData = {
      "from_date": selectedFromDate,
      "to_date": selectedToDate,
    };

    final resource = await _adminReportUsecase.getDoctorPayoutDetails(
        requestData: requestData);

    if (resource.status == STATUS.SUCCESS) {
      try {
        dynamic body = resource.data;
        if (body is String) body = jsonDecode(body);

        // Accept either a raw list or {data: [...]}/{result: [...]}
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

        final parsed = list
            .map((e) => DoctorCollectionData.fromMap(
                  (e as Map).map((k, v) => MapEntry(k.toString(), v)),
                ))
            .toList();

        setState(() {
          _doctors = parsed;
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);
        CommonUtils().flutterSnackBar(
          context: context,
          mes: "Failed to parse response: $e",
          messageType: 4,
        );
      }
    } else {
      setState(() => isLoading = false);
      CommonUtils().flutterSnackBar(
        context: context,
        mes: resource.message ?? "",
        messageType: 4,
      );
    }
  }
}

/// =====================
/// Chart Toggle
/// =====================
class _ChartToggle extends StatelessWidget {
  final _ChartMode mode;
  final ValueChanged<_ChartMode> onChanged;

  const _ChartToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDocPaid = mode == _ChartMode.docPaid;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn(
            label: "Doc Paid",
            active: isDocPaid,
            onTap: () => onChanged(_ChartMode.docPaid),
          ),
          _toggleBtn(
            label: "Patients (Old vs New)",
            active: !isDocPaid,
            onTap: () => onChanged(_ChartMode.patients),
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(
      {required String label,
      required bool active,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: active ? const Color(0xFF1D4ED8) : Colors.black87,
          ),
        ),
      ),
    );
  }
}

/// =====================
/// Chart 1: Doc Paid (one bar per doctor)
/// =====================
class DocPaidBarChart extends StatelessWidget {
  final List<DoctorCollectionData> doctors;
  const DocPaidBarChart({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    final entries = doctors
        .map((d) => MapEntry(d.docName, (d.docPaid).toDouble()))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // if everyone is zero, show a friendly empty state
    final maxV = entries.fold<double>(0, (m, e) => math.max(m, e.value));
    if (entries.isEmpty || maxV <= 0) {
      return const _ChartEmpty(text: "No Doc Paid values to chart");
    }

    const barH = 22.0;
    const gap = 12.0;
    final chartHeight = entries.length * (barH + gap) + 24;

    return SizedBox(
      width: double.infinity,
      height: chartHeight,
      child: CustomPaint(
        painter: _SingleSeriesHBarPainter(
          entries: entries,
          barColor: const Color(0xFF10B981), // emerald
          valuePrefix: "₹",
        ),
      ),
    );
  }
}

/// =====================
/// Chart 2: Patients (two bars per doctor: Old vs New)
/// =====================
class OldNewPatientsBarChart extends StatelessWidget {
  final List<DoctorCollectionData> doctors;
  // Tunables
  final double barH;
  final double rowGap;
  final double innerGap;
  final double maxChartBodyHeight; // cap so it stays inside the box

  const OldNewPatientsBarChart({
    super.key,
    required this.doctors,
    this.barH = 20.0,
    this.rowGap = 10.0,
    this.innerGap = 4.0,
    this.maxChartBodyHeight = 320.0,
  });

  @override
  Widget build(BuildContext context) {
    final entries = doctors
        .map((d) => _GroupEntry(
      label: d.docName,
      oldVal: math.max(0, d.patients - d.newlyRegistered).toDouble(),
      newVal: d.newlyRegistered.toDouble(),
    ))
        .toList()
      ..sort((a, b) => (b.oldVal + b.newVal).compareTo(a.oldVal + a.newVal));

    // if both series are all zeros, show empty
    double maxV = 0;
    for (final e in entries) {
      maxV = math.max(maxV, math.max(e.oldVal, e.newVal));
    }
    if (entries.isEmpty || maxV <= 0) {
      return const _ChartEmpty(text: "No Patients data to chart");
    }

    // total painter height needed
    final double painterHeight = entries.length * (barH + rowGap) + 24; // + top pad allowance inside painter

    // Build the painter once
    final painter = _GroupedHBarPainter(
      entries: entries,
      oldColor: const Color(0xFF3B82F6), // blue
      newColor: const Color(0xFFF59E0B), // amber
      barH: barH,
      rowGap: rowGap,
      innerGap: innerGap,
      // styles can be tuned here if you like
      labelStyle: const TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87),
      valueStyle: const TextStyle(
          fontSize: 8, fontWeight: FontWeight.w600, color: Colors.black54),
    );

    // If the painter needs more than maxChartBodyHeight, make just the chart body scroll
    final chartBody = SizedBox(
      width: double.infinity,
      height: painterHeight,
      child: CustomPaint(painter: painter),
    );

    final needsScroll = painterHeight > maxChartBodyHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: const [
            _LegendDotForChart(color: Color(0xFF3B82F6), label: "Old"),
            _LegendDotForChart(color: Color(0xFFF59E0B), label: "New"),
          ],
        ),
        const SizedBox(height: 8),

        if (needsScroll)
          SizedBox(
            height: maxChartBodyHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(
                child: chartBody,
              ),
            ),
          )
        else
          chartBody,
      ],
    );
  }
}

/// =====================
/// Painters & small helpers
/// =====================

class _ChartEmpty extends StatelessWidget {
  final String text;

  const _ChartEmpty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LegendDotForChart extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDotForChart({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8ECF5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              )),
        ],
      ),
    );
  }
}

class _SingleSeriesHBarPainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;
  final Color barColor;
  final String valuePrefix;

  _SingleSeriesHBarPainter({
    required this.entries,
    required this.barColor,
    this.valuePrefix = "",
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    const barH = 22.0;
    const gap = 12.0;
    const rightPad = 16.0;
    const topPad = 12.0;
    const minLeftPad = 80.0;

    final labelStyle = const TextStyle(
        fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87);
    final valueStyle = const TextStyle(
        fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black54);

    // compute left pad to fit labels
    double maxLabelW = 0;
    for (final e in entries) {
      final tp = TextPainter(
        text: TextSpan(text: e.key, style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: size.width * 0.6);
      maxLabelW = math.max(maxLabelW, tp.width);
    }
    final leftPad =
        math.min(size.width * 0.45, math.max(minLeftPad, maxLabelW + 16));
    final chartW = math.max(0, size.width - leftPad - rightPad);

    // scale
    final maxV = entries.map((e) => e.value).fold<double>(0, math.max);
    if (maxV <= 0 || chartW <= 0) return;

    // faint baseline
    final axisPaint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(leftPad, topPad - 6),
        Offset(size.width - rightPad, topPad - 6), axisPaint);

    final barPaint = Paint()..isAntiAlias = true;

    for (int i = 0; i < entries.length; i++) {
      final dep = entries[i].key;
      final val = entries[i].value;

      final y = topPad + i * (barH + gap);
      final w = (val / maxV) * chartW;

      // label
      final labelTP = TextPainter(
        text: TextSpan(text: dep, style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: leftPad - 12);
      labelTP.paint(canvas, Offset(8, y + (barH - labelTP.height) / 2));

      // bar
      barPaint.color = barColor.withOpacity(0.95);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(leftPad, y, w, barH),
        const Radius.circular(8),
      );
      canvas.drawRRect(rrect, barPaint);

      // value
      final valueTP = TextPainter(
        text: TextSpan(
            text: "$valuePrefix${val.toStringAsFixed(0)}", style: valueStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width);
      double textX = leftPad + w + 6;
      if (textX + valueTP.width > size.width - 4) {
        textX = leftPad + w - valueTP.width - 6;
        valueTP.text = TextSpan(
          text: "$valuePrefix${val.toStringAsFixed(0)}",
          style: valueStyle.copyWith(color: Colors.white),
        );
        valueTP.layout();
      }
      valueTP.paint(canvas, Offset(textX, y + (barH - valueTP.height) / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _SingleSeriesHBarPainter old) {
    if (old.entries.length != entries.length) return true;
    if (old.barColor != barColor) return true;
    return false;
  }
}

class _GroupEntry {
  final String label;
  final double oldVal;
  final double newVal;

  _GroupEntry(
      {required this.label, required this.oldVal, required this.newVal});
}

class _GroupedHBarPainter extends CustomPainter {
  final List<_GroupEntry> entries;
  final Color oldColor;
  final Color newColor;

  // unified sizing
  final double barH;        // total row height
  final double rowGap;      // gap between rows
  final double innerGap;    // gap between old/new bars inside a row
  final double rightPad;
  final double topPad;
  final double minLeftPad;

  // text styles
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  _GroupedHBarPainter({
    required this.entries,
    required this.oldColor,
    required this.newColor,
    this.barH = 20.0,
    this.rowGap = 10.0,
    this.innerGap = 4.0,
    this.rightPad = 16.0,
    this.topPad = 12.0,
    this.minLeftPad = 80.0,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    // compute left pad to fit labels
    double maxLabelW = 0;
    for (final e in entries) {
      final tp = TextPainter(
        text: TextSpan(text: e.label, style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: size.width * 0.6);
      maxLabelW = math.max(maxLabelW, tp.width);
    }
    final leftPad =
    math.min(size.width * 0.45, math.max(minLeftPad, maxLabelW + 16));
    final chartW = math.max(0, size.width - leftPad - rightPad);

    // scale by max of series
    double maxV = 0;
    for (final e in entries) {
      maxV = math.max(maxV, math.max(e.oldVal, e.newVal));
    }
    if (maxV <= 0 || chartW <= 0) return;

    // baseline
    final axisPaint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(leftPad, topPad - 6),
      Offset(size.width - rightPad, topPad - 6),
      axisPaint,
    );

    final barPaint = Paint()..isAntiAlias = true;

    for (int i = 0; i < entries.length; i++) {
      final e = entries[i];
      final rowTop = topPad + i * (barH + rowGap);

      // label
      final labelTP = TextPainter(
        text: TextSpan(text: e.label, style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: leftPad - 12);
      labelTP.paint(canvas, Offset(8, rowTop + (barH - labelTP.height) / 2));

      // each row has two bars stacked
      final barHeight = (barH - innerGap) / 2;

      // Old
      final wOld = (e.oldVal / maxV) * chartW;
      barPaint.color = oldColor.withOpacity(0.95);
      final rrectOld = RRect.fromRectAndRadius(
        Rect.fromLTWH(leftPad, rowTop, wOld, barHeight),
        const Radius.circular(7),
      );
      canvas.drawRRect(rrectOld, barPaint);

      // New
      final wNew = (e.newVal / maxV) * chartW;
      barPaint.color = newColor.withOpacity(0.95);
      final rrectNew = RRect.fromRectAndRadius(
        Rect.fromLTWH(leftPad, rowTop + barHeight + innerGap, wNew, barHeight),
        const Radius.circular(7),
      );
      canvas.drawRRect(rrectNew, barPaint);

      // values
      TextPainter valueTP = TextPainter(
        text: TextSpan(text: e.oldVal.toStringAsFixed(0), style: valueStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width);
      double xOld = leftPad + wOld + 6;
      if (xOld + valueTP.width > size.width - 4) {
        xOld = leftPad + wOld - valueTP.width - 6;
        valueTP.text = TextSpan(
          text: e.oldVal.toStringAsFixed(0),
          style: valueStyle.copyWith(color: Colors.white),
        );
        valueTP.layout();
      }
      valueTP.paint(canvas, Offset(xOld, rowTop + (barHeight - valueTP.height) / 2));

      valueTP = TextPainter(
        text: TextSpan(text: e.newVal.toStringAsFixed(0), style: valueStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width);
      double xNew = leftPad + wNew + 6;
      if (xNew + valueTP.width > size.width - 4) {
        xNew = leftPad + wNew - valueTP.width - 6;
        valueTP.text = TextSpan(
          text: e.newVal.toStringAsFixed(0),
          style: valueStyle.copyWith(color: Colors.white),
        );
        valueTP.layout();
      }
      valueTP.paint(canvas, Offset(xNew, rowTop + barHeight + innerGap + (barHeight - valueTP.height) / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _GroupedHBarPainter old) {
    return old.entries.length != entries.length ||
        old.oldColor != oldColor ||
        old.newColor != newColor ||
        old.barH != barH ||
        old.rowGap != rowGap ||
        old.innerGap != innerGap;
  }
}

class DoctorCollectionCard extends StatelessWidget {
  final DoctorCollectionData data;
  final VoidCallback? onTap;

  const DoctorCollectionCard({
    super.key,
    required this.data,
    this.onTap,
  });

  String _inr(num v) => "₹${v.toStringAsFixed(2)}";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalBase = data.total <= 0 ? 1.0 : data.total;
    final docPaidPct = (data.docPaid / totalBase).clamp(0.0, 1.0);
    final rainbowPct = (data.rainbow / totalBase).clamp(0.0, 1.0);
    final remainderPct = (1 - docPaidPct - rainbowPct).clamp(0.0, 1.0);

    // Palette
    const docPaidColor = Color(0xFF10B981); // emerald
    const rainbowColor = Color(0xFF8B5CF6); // violet
    const remainderColor = Color(0xFFE5E7EB); // neutral

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFF), Color(0xFFFFFFFF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: const Color(0xFFEFF3FA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: avatar + name + charge id + counters
            Row(
              children: [
                _Avatar(initials: _initials(data.docName)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.docName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          )),
                      const SizedBox(height: 2),
                      Wrap(
                        children: [
                          _ChipStat(
                              icon: Icons.groups_rounded,
                              label: "${data.patients} Patients"),
                          const SizedBox(width: 6),
                          _ChipStat(
                              icon: Icons.fiber_new_rounded,
                              label: "${data.newlyRegistered} New"),
                        ],
                      ),
                    ],
                  ),
                ),
                // Total amount on the right
              ],
            ),

            const SizedBox(height: 10),

            // Legend
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                _LegendDot(
                    color: docPaidColor,
                    label: "Total Paid",
                    value: _inr(data.total)),
                _LegendDot(
                    color: docPaidColor,
                    label: "Doc Paid",
                    value: _inr(data.docPaid)),
                _LegendDot(
                    color: rainbowColor,
                    label: "Rainbow",
                    value: _inr(data.rainbow)),
                if (remainderPct > 0)
                  _LegendDot(
                      color: remainderColor,
                      label: "Other",
                      value: _inr(data.total - data.docPaid - data.rainbow)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r"\s+"));
    if (parts.isEmpty) return "?";
    final first = parts.first.isNotEmpty ? parts.first[0] : "";
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : "";
    return (first + last).toUpperCase();
  }
}

class _Avatar extends StatelessWidget {
  final String initials;

  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
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
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _ChipStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ChipStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8ECF5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendDot(
      {required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8ECF5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
