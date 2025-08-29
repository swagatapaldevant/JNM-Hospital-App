// import 'package:flutter/material.dart';
// import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
// import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
// import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

// class DeathReportItem extends StatelessWidget {
//   final int? index;
//   final String? patientId;
//   final String? patientName;
//   final String? gender;
//   final String? doctorName;
//   final String? admDate;
//   final String? disChargeDate;


//   const DeathReportItem({
//     super.key, this.index, this.patientId, this.patientName, this.gender, this.doctorName, this.admDate, this.disChargeDate,

//   });

//   @override
//   Widget build(BuildContext context) {
//     AppDimensions.init(context);
//     return Container(
//       width: ScreenUtils().screenWidth(context),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           border: Border(
//             right: BorderSide(
//                 color: AppColors.arrowBackground,
//                 width: index! % 2 == 0 ? 10 : 2),
//             left: BorderSide(
//                 color: AppColors.arrowBackground,
//                 width: index! % 2 != 0 ? 10 : 2),
//             top: BorderSide(color: AppColors.arrowBackground, width: 2),
//             bottom: BorderSide(color: AppColors.arrowBackground, width: 2),
//           )),
//       child: Stack(
//         children: [
//           Center(
//               child: Image.asset(
//             "assets/images/admin_report/stetho1.png",
//             height: ScreenUtils().screenHeight(context) * 0.22,
//             width: ScreenUtils().screenWidth(context) * 0.5,
//           )),
//           Padding(
//             padding: EdgeInsets.all(AppDimensions.screenPadding),
//             child: Column(
//               spacing: 8,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     text: 'Patient Id : ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.colorBlack,
//                         fontSize: 14),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: patientId,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.colorBlack,
//                               fontSize: 14)),
//                     ],
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Patient Name : ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.colorBlack,
//                         fontSize: 14),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: patientName,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.colorBlack,
//                               fontSize: 14)),
//                     ],
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Gender : ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.colorBlack,
//                         fontSize: 14),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: gender,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.colorBlack,
//                               fontSize: 14)),
//                     ],
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Doctor name : ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.colorBlack,
//                         fontSize: 14),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: doctorName,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.colorBlack,
//                               fontSize: 14)),
//                     ],
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Admission Date : ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.colorBlack,
//                         fontSize: 14),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: admDate,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.colorBlack,
//                               fontSize: 14)),
//                     ],
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Discharge Date : ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.colorBlack,
//                         fontSize: 14),
//                     children: <TextSpan>[
//                       TextSpan(
//                           text: disChargeDate,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: AppColors.colorBlack,
//                               fontSize: 14)),
//                     ],
//                   ),
//                 )

//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class DeathReportItem extends StatefulWidget {
  final int? index;
  final String? patientId;
  final String? patientName;
  final String? gender;
  final String? doctorName;
  final String? admDate;
  final String? disChargeDate;

  final bool initiallyExpanded;      // NEW (optional)
  const DeathReportItem({
    super.key,
    this.index,
    this.patientName,
    this.patientId,
    this.gender,
    this.doctorName,
    this.admDate,
    this.disChargeDate,
    this.initiallyExpanded = false,
  });

  @override
  State<DeathReportItem> createState() => _DeathReportItemState();
}

class _DeathReportItemState extends State<DeathReportItem>
    with SingleTickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    final w = ScreenUtils().screenWidth(context);
    final i = widget.index ?? 0;

    
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
                    colors: [
                      AppColors.arrowBackground,
                      Colors.white.withOpacity(.0),
                    ],
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
                                // Name (UHID)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        /**NOTE: patient_id being used in place of uhid */
                                        "${_val(widget.patientName?.toUpperCase())} (${_val(widget.patientId)})",
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
                                    
                                  ],
                                ),
                                const SizedBox(height: 6),
                                _DotRow(
                                  items: [
                                    _has(widget.doctorName)
                                        ? "DR. ${_val(widget.doctorName?.toUpperCase())}"
                                        : "Doctor —",
                                    
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
                            child: const Icon(Icons.keyboard_arrow_down_rounded),
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
                                  children: [
                                    if (_has(widget.gender))
                                      _TagChip(
                                        icon: Icons.person_rounded,
                                        label: _val(widget.gender),
                                        color: _genderColor(widget.gender),
                                      ),
                                    _TagChip(
                                      icon: Icons.local_hospital_outlined,
                                      label: 'Admission: ${widget.admDate.toString()}',
                                    ),
                                     _TagChip(
                                      icon: Icons.new_releases,
                                      label: 'Discharge: ${widget.disChargeDate.toString()}',
                                    ),

                                  ],
                                ),
                              ),

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
    if (s.contains('old')) return const Color(0xFFEF6C00);
    return AppColors.arrowBackground;
  }
  static Color _visitColorBg(String? v) {
    final s = (v ?? '').toLowerCase();
    if (s.contains('new')) return const Color.fromARGB(255, 3, 97, 3);
    if (s.contains('old')) return const Color.fromARGB(82, 239, 108, 0);
    return AppColors.arrowBackground;
  }

  static String _buildApptLabel(String? time) {
    if (time?.isNotEmpty ?? false) return time!;
    return 'No appointment time';
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
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c, height: 1.0),
        ),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color color;
  const _Chip({required this.label, required this.bgColor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: .6,
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
