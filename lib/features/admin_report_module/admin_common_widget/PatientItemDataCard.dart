import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/locator.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/resource.dart';
import 'package:jnm_hospital_app/core/network/apiHelper/status.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/common_utils.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/data/admin_report_usecase.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_details_model.dart';
import 'package:jnm_hospital_app/features/admin_report_module/model/billing_report/billing_report_model.dart';

class PatientItemData extends StatefulWidget {
  final int? index;
  final String? patientName;
  final String? uhid;
  final String? department;
  final String? doctor;
  final String? id;

  final String? visitType;

  final String? opdId;
  final String? gender;
  final String? age;
  final String? mobile;
  final String? appointmentDate;
  final String? appointmentTime;

  final String? deptId;

  final List<Map<String, String>> info;

  final VoidCallback? onTap;

  final bool initiallyExpanded;

  const PatientItemData({
    super.key,
    this.index,
    this.patientName,
    this.department,
    this.uhid,
    this.opdId,
    this.gender,
    this.age,
    this.mobile,
    this.visitType,
    this.appointmentDate,
    this.appointmentTime,
    this.doctor,
    this.onTap,
    this.initiallyExpanded = false,
    required this.id,
    required this.info,
    required this.deptId,
  });

  @override
  State<PatientItemData> createState() => _PatientItemDataState();
}

class _PatientItemDataState extends State<PatientItemData>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  bool isLoading = false;
  BillingDetailsModel? billingDetails;

  final AdminReportUsecase _adminReportUsecase = getIt<AdminReportUsecase>();
  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  Future<void> getBillingDetails(String deptId, int billId) async {
    setState(() {
      isLoading = true;
    });

    Resource resource = await _adminReportUsecase.getBillingDetails(
        deptId: deptId, billId: billId);

    if (resource.status == STATUS.SUCCESS) {
      // Handle successful response
      print(resource.data);
      setState(() {
        isLoading = false;
        billingDetails = BillingDetailsModel.fromJson(resource.data);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      CommonUtils().flutterSnackBar(
          context: context, mes: resource.message ?? "", messageType: 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final w = ScreenUtils().screenWidth(context);
    final visitAccent = _visitColor(widget.visitType);

    return Container(
      width: w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // background wash
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    visitAccent.withOpacity(.12),
                    AppColors.arrowBackground.withOpacity(.08),
                    Colors.white.withOpacity(.90),
                  ],
                ),
              ),
            ),

            // border
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey, width: 0.5),
              ),
            ),

            // left spine
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [visitAccent, visitAccent.withOpacity(.7)],
                  ),
                ),
              ),
            ),

            // content
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── HEADER: always visible
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${_val(widget.patientName?.toUpperCase())} (${_val(widget.uhid)})",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                          letterSpacing: .2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (_has(widget.visitType))
                                      _Chip(
                                        label: _val(widget.visitType)
                                            .toUpperCase(),
                                        color: _visitColor(widget.visitType),
                                        bgColor:
                                            _visitColorBg(widget.visitType),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                _DotRow(
                                  items: [
                                    _has(widget.doctor)
                                        ? "DR. ${_val(widget.doctor?.toUpperCase())}"
                                        : "Doctor —",
                                    _has(widget.department)
                                        ? _val(widget.department?.toUpperCase())
                                        : "Department —",
                                  ],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Chevron
                          const SizedBox(width: 8),
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 200),
                            turns: _expanded ? 0.5 : 0.0, // rotate 180°
                            child:
                                const Icon(Icons.keyboard_arrow_down_rounded),
                          ),
                        ],
                      ),

                      // Divider between header and body
                      const SizedBox(height: 10),
                      _Divider(),

                      // ── BODY: collapsible
                      AnimatedCrossFade(
                        crossFadeState: _expanded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 220),
                        firstCurve: Curves.easeOutCubic,
                        secondCurve: Curves.easeInCubic,
                        sizeCurve: Curves.easeInOutCubic,
                        firstChild: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // chips row
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [_buildList(widget.info)],
                                ),
                              ),
                              const SizedBox(height: 8),
                              CommonButton(
                                  buttonName: "View Details",
                                  onTap: () {
                                    widget.onTap?.call();
                                  })
                            ],
                          ),
                        ),
                        // collapsed placeholder: keeps header tight
                        secondChild: const SizedBox(height: 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── helpers (same as your originals) ──────────────────────────────
  static String _val(String? s) =>
      (s == null || s.trim().isEmpty) ? '—' : s.trim();
  static bool _has(String? s) => s != null && s.trim().isNotEmpty;

  static Color _genderColor(String? g) {
    final v = (g ?? '').toLowerCase();
    if (v.startsWith('m')) return const Color(0xFF1976D2);
    if (v.startsWith('f')) return const Color(0xFFD81B60);
    return Colors.blueGrey;
  }

  static Color _visitColor(String? v) {
    final s = (v ?? '').toLowerCase();
    if (s.contains('new')) return Colors.white;
    if (s.contains('old')) return const Color.fromARGB(255, 253, 248, 246);
    return AppColors.arrowBackground;
  }

  static Color _visitColorBg(String? v) {
    final s = (v ?? '').toLowerCase();
    if (s.contains('new')) return const Color.fromARGB(255, 3, 97, 3);
    if (s.contains('old')) return Colors.red;
    return AppColors.arrowBackground;
  }

  formatDate(String string) {
    final DateTime date = DateTime.parse(string);
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')}";
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final IconData? icon;
  const _Badge({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF6A8EFA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8FF), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: .2,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _TagChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.blueGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withOpacity(.5)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: c),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: c, height: 1.0),
        ),
      ]),
    );
  }
}

const Map<String, IconData> kIconMap = {
  "name": Icons.person,
  "phone": Icons.phone,
  "email": Icons.email,
};

const Map<String, Color> kColorMap = {
  "name": Colors.blue,
  "phone": Colors.green,
  "email": Colors.red,
};

Widget _buildList(List<Map<String, String>> info) {
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: info.expand((map) {
      return map.entries.map((entry) {
        final key = entry.key; // e.g., "phone"
        final label = entry.value; // e.g., "9876543210"

        return _TagChip(
          icon: kIconMap[key] ?? Icons.label, // fallback icon
          label: label,
          color: kColorMap[key] ?? Colors.grey,
        );
      });
    }).toList(),
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color color;
  const _Chip(
      {required this.label, required this.bgColor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
        //   border: Border.all(color: color.withOpacity(.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          letterSpacing: .4,
          color: color,
          height: 1.0,
        ),
      ),
    );
  }
}

class _DotRow extends StatelessWidget {
  final List<String> items;
  final TextStyle? style;
  const _DotRow({required this.items, this.style});

  @override
  Widget build(BuildContext context) {
    final visible = items.where((e) => e.trim().isNotEmpty).toList();
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < visible.length; i++) ...[
          Text(visible[i], style: style),
          if (i != visible.length - 1)
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(bottom: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black38,
              ),
            ),
        ],
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(.06),
            Colors.black.withOpacity(.02),
            Colors.transparent
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
