import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class StatisticalGraph extends StatefulWidget {
  final List<String> categories; // E.g., ["OPD", "Emergency", "IPD", ...]
  final List<int> newData;
  final List<int> oldData;
  final String text;

  const StatisticalGraph({
    super.key,
    required this.categories,
    required this.newData,
    required this.oldData,
    required this.text,
  });

  @override
  State<StatisticalGraph> createState() => _StatisticalGraphState();
}

class _StatisticalGraphState extends State<StatisticalGraph> {
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
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: AppColors.colorBlack,
              ),
            ),
            SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),
            BarChartDetails(
              categories: widget.categories,
              newData: widget.newData,
              oldData: widget.oldData,
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartDetails extends StatefulWidget {
  final List<String> categories;
  final List<int> newData;
  final List<int> oldData;

  const BarChartDetails({
    super.key,
    required this.categories,
    required this.newData,
    required this.oldData,
  });

  @override
  State<BarChartDetails> createState() => _BarChartDetailsState();
}

class _BarChartDetailsState extends State<BarChartDetails> {
  List<int> currentNew = [];
  List<int> currentOld = [];

  @override
  void initState() {
    super.initState();
    if (widget.newData.isNotEmpty && widget.oldData.isNotEmpty) {
      currentNew = List.filled(widget.newData.length, 0);
      currentOld = List.filled(widget.oldData.length, 0);
      animateBars();
    }
  }

  void animateBars() async {
    for (int i = 0; i < widget.newData.length; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return; // safety
      setState(() {
        currentNew[i] = widget.newData[i];
        currentOld[i] = widget.oldData[i];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Fallback if no data
    if (widget.categories.isEmpty ||
        widget.newData.isEmpty ||
        widget.oldData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "No data available",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 2.8,
      child: BarChart(
        BarChartData(
          maxY: getMaxY(
            [...widget.newData, ...widget.oldData]
                .map((e) => e.toDouble())
                .toList(),
          ),
          barGroups: List.generate(widget.categories.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: currentNew[index].toDouble(),
                  width: 10,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  color: Colors.blueAccent,
                ),
                BarChartRodData(
                  toY: currentOld[index].toDouble(),
                  width: 10,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  color: Colors.orangeAccent,
                ),
              ],
              barsSpace: 2,
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final idx = value.toInt();
                  if (idx >= 0 && idx < widget.categories.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Transform.rotate(
                        angle: 20 * 3.1415926535 / 180,
                        child: Text(
                          widget.categories[idx],
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label = rodIndex == 0 ? "New" : "Old";
                return BarTooltipItem(
                  '$label: ${rod.toY.toStringAsFixed(0)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                );
              },
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.black12),
            ),
          ),
        ),
      ),
    );
  }

  double getMaxY(List<double> values) {
    if (values.isEmpty) return 10;
    double maxVal = values.reduce((a, b) => a > b ? a : b);
    return (maxVal * 1.2).ceilToDouble();
  }
}
