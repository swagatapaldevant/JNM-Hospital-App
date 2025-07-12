import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/death_report_module/widgets/death_report_modal_for_death_gender_distribution.dart';

class DoctorDeathCountLineChart extends StatelessWidget {
  final List<String> doctorNames;
  final List<int> deathCounts;
  final Color? lineColor;
  final Color? grad1;
  final Color? grad2;
  final String? title;
  final String? maleCount;
  final String? femaleCount;

  const DoctorDeathCountLineChart({
    super.key,
    required this.doctorNames,
    this.maleCount,
    this.femaleCount,
    required this.deathCounts, this.lineColor, this.grad1,this.grad2, this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title??"Doctor-wise Death Counts",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlack,
                  ),
                ),
                Bounceable(
                    onTap: (){
                      showCommonModalForDeathGenderDistribution(context, double.parse(maleCount!), double.parse(femaleCount!));
                    },
                    child: Icon(Icons.pie_chart, size: 30,color: AppColors.arrowBackground,))
              ],
            ),
            SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
            AspectRatio(
              aspectRatio: 2,
              child: LineChart(_buildLineChartData()),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      minY: 0,
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              int index = value.toInt();
              if (index >= 0 && index < doctorNames.length) {
                return Transform.rotate(
                  angle: 45 * 3.1415926535 / 180,
                  child: Text(
                    doctorNames[index],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(bottom: BorderSide(color: Colors.black12)),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: List.generate(doctorNames.length,
                  (index) => FlSpot(index.toDouble(), deathCounts[index].toDouble())),
          isStrokeCapRound: true,
          barWidth: 2,
          color: lineColor??Colors.red,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                grad1??Colors.red.withOpacity(0.3),
                grad2??Colors.red.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              int index = spot.x.toInt();
              String doctor = (index >= 0 && index < doctorNames.length)
                  ? doctorNames[index]
                  : "";
              return LineTooltipItem(
                '$doctor\n: ${spot.y.toStringAsFixed(0)}',
                const TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
