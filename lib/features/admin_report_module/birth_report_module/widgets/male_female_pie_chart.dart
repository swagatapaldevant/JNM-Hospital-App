import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart'; // Update paths if needed
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class GenderPieChart extends StatefulWidget {
  final int maleCount;
  final int femaleCount;
  final List<String> labels; // For example: ["Jan", "Feb", "Mar"]
  final List<int> lucsCounts;

  const GenderPieChart({
    super.key,
    required this.maleCount,
    required this.femaleCount,
    required this.labels,
    required this.lucsCounts,
  });

  @override
  State<GenderPieChart> createState() => _GenderPieChartState();
}

class _GenderPieChartState extends State<GenderPieChart> {
  @override
  Widget build(BuildContext context) {
    int total = widget.maleCount + widget.femaleCount;

    double malePercentage = (widget.maleCount / total) * 100;
    double femalePercentage = (widget.femaleCount / total) * 100;

    return Container(
      width: ScreenUtils().screenWidth(context),
      height: ScreenUtils().screenHeight(context)*0.3,
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
      child: Row(
        children: [
          SizedBox(
            width: ScreenUtils().screenWidth(context) * 0.4,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gender Distribution",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      color: AppColors.colorBlack,
                    ),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
                  AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: widget.maleCount.toDouble(),
                            color: Colors.blue,
                            //title: "${malePercentage.toStringAsFixed(1)}%\nMale",
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: widget.femaleCount.toDouble(),
                            color: Colors.pink,
                            //title: "${femalePercentage.toStringAsFixed(1)}%\nFemale",
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 10,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.blue, radius: 5),
                          const SizedBox(width: 5),
                          const Text("Male", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.pink, radius: 5),
                          const SizedBox(width: 5),
                          const Text("Female", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: ScreenUtils().screenWidth(context)*0.5,
            child: Padding(
              padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Type Counts",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorBlack,
                    ),
                  ),
                  SizedBox(height: ScreenUtils().screenHeight(context) * 0.02),
                  AspectRatio(
                    aspectRatio: 1,
                    child: BarChart(
                      BarChartData(
                        barGroups: _buildBarGroups(),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                int index = value.toInt();
                                if (index >= 0 && index < widget.labels.length) {
                                  return Transform.rotate(
                                    angle: 45 * 3.1415926535 / 180,
                                    child: Text(
                                      widget.labels[index],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                              bottom: BorderSide(color: Colors.black12)),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                rod.toY.toStringAsFixed(0),
                                const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < widget.labels.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barsSpace: 2,
          barRods: [
            BarChartRodData(
              toY: widget.lucsCounts[i].toDouble(),
              width: 10,
              borderRadius: BorderRadius.only(topRight: Radius.circular(4), topLeft: Radius.circular(4)),
              color: Colors.blue,
            ),

          ],
        ),
      );
    }

    return groups;
  }
}
