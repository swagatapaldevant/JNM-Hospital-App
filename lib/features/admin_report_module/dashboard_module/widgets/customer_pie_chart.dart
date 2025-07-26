import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class CustomPatientPieChart extends StatefulWidget {
  final double opdPatients;
  final double emergencyPatients;
  final double ipdPatients;
  final double daycarePatients;
  final double investigationPatients;
  final double dialysisPatients;
  final double? containerHeight;
  final double? pieChartHeight;
  final double? pieChartWidth;
  final bool? isSuffeled;

  const CustomPatientPieChart({
    super.key,
    required this.opdPatients,
    required this.emergencyPatients,
    required this.ipdPatients,
    required this.daycarePatients,
    required this.investigationPatients,
    required this.dialysisPatients,
    this.containerHeight,
    this.pieChartHeight,
    this.pieChartWidth,
    this.isSuffeled = true
  });

  @override
  State<CustomPatientPieChart> createState() => _CustomPatientPieChartState();
}

class _CustomPatientPieChartState extends State<CustomPatientPieChart> {
  late double totalPatients;

  @override
  void initState() {
    super.initState();
    totalPatients = widget.opdPatients +
        widget.emergencyPatients +
        widget.ipdPatients +
        widget.daycarePatients +
        widget.investigationPatients +
        widget.dialysisPatients;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray7.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.isSuffeled == true?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: widget.pieChartWidth ?? ScreenUtils().screenWidth(context) * 0.2,
                  height: widget.pieChartHeight ?? ScreenUtils().screenHeight(context) * 0.1,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0.6,
                      centerSpaceRadius: 0,
                      sections: _getPieSections(),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        _buildLegend("OPD", widget.opdPatients, Colors.blue),
                        _buildLegend("Emergency", widget.emergencyPatients, Colors.red),
                        _buildLegend("IPD", widget.ipdPatients, Colors.orange),
                        _buildLegend("Daycare", widget.daycarePatients, Colors.purple),
                        _buildLegend("Investigation", widget.investigationPatients, Colors.green),
                        _buildLegend("Dialysis", widget.dialysisPatients, Colors.teal),
                  ],
                )
              ],
            ):Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegend("OPD", widget.opdPatients, Colors.blue),
                    _buildLegend("Emergency", widget.emergencyPatients, Colors.red),
                    _buildLegend("IPD", widget.ipdPatients, Colors.orange),
                    _buildLegend("Daycare", widget.daycarePatients, Colors.purple),
                    _buildLegend("Investigation", widget.investigationPatients, Colors.green),
                    _buildLegend("Dialysis", widget.dialysisPatients, Colors.teal),
                  ],
                ),
                SizedBox(
                  width: widget.pieChartWidth ?? ScreenUtils().screenWidth(context) * 0.2,
                  height: widget.pieChartHeight ?? ScreenUtils().screenHeight(context) * 0.1,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0.6,
                      centerSpaceRadius: 0,
                      sections: _getPieSections(),
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),

              ],
            ),
            // SizedBox(height: 10,),
            // Text(
            //   "NB: % based on total patients",
            //   style: TextStyle(
            //     fontSize: 12,
            //     fontWeight: FontWeight.w500,
            //     color: AppColors.colorTomato,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieSections() {
    final radius = ScreenUtils().screenWidth(context) * 0.13;
    return [
      PieChartSectionData(color: Colors.blue, value: widget.opdPatients, radius: radius, showTitle: false),
      PieChartSectionData(color: Colors.red, value: widget.emergencyPatients, radius: radius, showTitle: false),
      PieChartSectionData(color: Colors.orange, value: widget.ipdPatients, radius: radius, showTitle: false),
      PieChartSectionData(color: Colors.purple, value: widget.daycarePatients, radius: radius, showTitle: false),
      PieChartSectionData(color: Colors.green, value: widget.investigationPatients, radius: radius, showTitle: false),
      PieChartSectionData(color: Colors.teal, value: widget.dialysisPatients, radius: radius, showTitle: false),
    ];
  }

  Widget _buildLegend(String label, double count, Color color) {
    final percentage = totalPatients > 0 ? (count / totalPatients) * 100 : 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ScreenUtils().screenWidth(context) * 0.02,
          height: ScreenUtils().screenWidth(context) * 0.02,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: ScreenUtils().screenWidth(context) * 0.01),
        Text(
          "$label(${percentage.toStringAsFixed(2)}%): $count",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }
}
