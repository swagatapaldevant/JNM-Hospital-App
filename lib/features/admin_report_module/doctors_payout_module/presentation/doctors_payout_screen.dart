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

class _DoctorsPayoutScreenState extends State<DoctorsPayoutScreen> {

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  final SharedPref _pref = getIt<SharedPref>();
  bool isLoading = false;
  bool isVisible = false;
  String selectedFromDate = "";
  String selectedToDate = "";
  final ScrollController _scrollController = ScrollController();
  List<DoctorCollectionData> _doctors = [];


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
                      const SizedBox(height: 6),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _doctors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
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

    final resource =
    await _adminReportUsecase.getDoctorPayoutDetails(requestData: requestData);

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
                      value:
                      _inr(data.total - data.docPaid - data.rainbow)),
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

// ---------- Small UI pieces ----------

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

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD6E4FF)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1D4ED8),
          fontWeight: FontWeight.w700,
          fontSize: 11,
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
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle),
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

// ---------- Segmented bar (custom painter) ----------

class _Segment {
  final double fraction; // 0..1
  final Color color;
  _Segment(this.fraction, this.color);
}

class _SegmentBar extends StatelessWidget {
  final List<_Segment> segments;
  final double height;
  final double radius;

  const _SegmentBar({
    required this.segments,
    this.height = 14,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _SegmentBarPainter(segments: segments, radius: radius),
      ),
    );
  }
}

class _SegmentBarPainter extends CustomPainter {
  final List<_Segment> segments;
  final double radius;
  _SegmentBarPainter({required this.segments, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final totalW = size.width;
    double x = 0;

    // Track
    final bgPaint = Paint()..color = const Color(0xFFF1F5F9);
    final track = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    canvas.drawRRect(track, bgPaint);

    // Segments
    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final w = (seg.fraction * totalW).clamp(0.0, totalW - x);
      if (w <= 0) continue;

      final isFirst = i == 0;
      final isLast = i == segments.length - 1;
      final r = isFirst || isLast ? radius : math.max(0, radius - 2);

      final rrect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, 0, w, size.height),
        topLeft: isFirst ? Radius.circular(r.toDouble()) : Radius.zero,
        bottomLeft: isFirst ? Radius.circular(r.toDouble()) : Radius.zero,
        topRight: isLast ? Radius.circular(r.toDouble()) : Radius.zero,
        bottomRight: isLast ? Radius.circular(r.toDouble()) : Radius.zero,
      );

      final paint = Paint()..color = seg.color;
      canvas.drawRRect(rrect, paint);
      x += w;
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentBarPainter old) {
    if (old.segments.length != segments.length) return true;
    for (int i = 0; i < segments.length; i++) {
      if (old.segments[i].fraction != segments[i].fraction ||
          old.segments[i].color != segments[i].color) {
        return true;
      }
    }
    return false;
  }
}


