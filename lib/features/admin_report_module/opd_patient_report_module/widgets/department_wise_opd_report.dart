import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class DepartmentWiseOpdReport extends StatelessWidget {
  final List<FlSpot> spotsType1;
  final List<FlSpot> spotsType2;
  final List<String> yearLabels;
  Function()? onTapFullScreen;
  Function()? onTapPieChart;
  final String? graphTitle;

   DepartmentWiseOpdReport({
    super.key,
    required this.spotsType1,
    required this.spotsType2,
    required this.yearLabels,
     this.onTapPieChart,
    this.onTapFullScreen, this.graphTitle
  });

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Container(
      width: ScreenUtils().screenWidth(context),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray8,
            blurRadius: 4,
            offset: const Offset(0, 4),
            spreadRadius: 0,
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
                SizedBox(
                  width: ScreenUtils().screenWidth(context)*0.6,
                  child: Text(
                    graphTitle??"Department-wise OPD Report",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorBlack,
                    ),
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Bounceable(
                        onTap: onTapPieChart,
                        child: Icon(Icons.bar_chart, size: 25, color: AppColors.reportDashboardHeaderGrad2,)),
                    Bounceable(
                        onTap:onTapFullScreen,
                        child: Icon(Icons.fullscreen, color: AppColors.colorBlack, size: 25)),
                  ],
                ),
              ],
            ),
            SizedBox(height: ScreenUtils().screenHeight(context)*0.01,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: ScreenUtils().screenWidth(context)*0.05,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    CircleAvatar(backgroundColor: AppColors.redColor,radius: 4,),
                    Text("old", style: TextStyle(
                        fontSize: 12,
                        color: AppColors.redColor,
                        fontWeight: FontWeight.w400
                    ),),
                  ],
                ),

                Row(
                  spacing: 5,
                  children: [
                    CircleAvatar(backgroundColor: AppColors.arrowBackground,radius: 4,),
                    Text("New", style: TextStyle(
                        fontSize: 12,
                        color: AppColors.arrowBackground,
                        fontWeight: FontWeight.w400
                    ),),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: AppDimensions.screenPadding),
              child: AspectRatio(
                aspectRatio: 2,
                child: LineChart(
                  _buildLineChartData(),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      minY: 0,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              int index = value.toInt();
              if (index >= 0 && index < yearLabels.length) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Transform.rotate(
                    angle: 45 * 3.1415926535 / 180,
                    child: Text(
                      yearLabels[index].length>14? yearLabels[index].substring(0, 10)
                          : yearLabels[index],
                      style: const TextStyle(
                        fontSize: 8,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
          spots: spotsType1,
          isStrokeCapRound: true,
          barWidth: 1,
          color: AppColors.arrowBackground, // First line color
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.arrowBackground.withOpacity(0.3),
                AppColors.arrowBackground.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        LineChartBarData(
          isCurved: true,
          spots: spotsType2,
          isStrokeCapRound: true,
          barWidth: 1,
          color: Colors.red, // Second line color
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.red.withOpacity(0.3),
                Colors.red.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 3,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              int yearIndex = spot.x.toInt();
              String year = (yearIndex >= 0 && yearIndex < yearLabels.length)
                  ? yearLabels[yearIndex]
                  : "";
              return LineTooltipItem(
                '$year\n${spot.y.toStringAsFixed(1)}',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
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
