import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class BarChartDetails extends StatefulWidget {
  final List<String> type;
  final List<double> total;
  final List<double> grandTotal;
  final List<double> discount;
  final List<double> paid;
  final List<double> due;

  const BarChartDetails({
    super.key,
    required this.type,
    required this.total,
    required this.grandTotal,
    required this.discount,
    required this.paid,
    required this.due,
  });

  @override
  _BarChartDetailsState createState() => _BarChartDetailsState();
}

class _BarChartDetailsState extends State<BarChartDetails> {
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
        padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Billing Chart",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: AppColors.colorBlack,
              ),
            ),
            SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                graphData(Colors.blue, "Total"),
                graphData(Colors.green, "Discount"),
                graphData(Colors.orange, "Grand Total"),
                graphData(Colors.purple, "Paid"),
                graphData(Colors.red, "Due"),
              ],
            ),

            SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),
            BarChartDetailsForBilling(
              type: widget.type,
              total: widget.total,
              grandTotal: widget.grandTotal,
              discount: widget.discount,
              paid: widget.paid,
              due: widget.due,
            ),
            SizedBox(height: ScreenUtils().screenHeight(context) * 0.01),
          ],
        ),
      ),
    );
  }

  Widget graphData(Color color, String name){
    return Row(
      spacing: 3,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: color,
        ),
        Text(name, style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.colorBlack
        ),)
      ],
    );
  }

}

class BarChartDetailsForBilling extends StatelessWidget {
  final List<String> type;
  final List<double> total;
  final List<double> grandTotal;
  final List<double> discount;
  final List<double> paid;
  final List<double> due;

  const BarChartDetailsForBilling({
    super.key,
    required this.type,
    required this.total,
    required this.grandTotal,
    required this.discount,
    required this.paid,
    required this.due,
  });

  @override
  Widget build(BuildContext context) {
    double maxY = getMaxY([...total, ...grandTotal, ...discount, ...paid, ...due]);
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: List.generate(type.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: total[index],
                  width: 10,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)
                  ),
                  color: Colors.blue,
                ),
                BarChartRodData(
                  toY: grandTotal[index],
                  width: 10,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)
                  ),
                  color: Colors.green,
                ),
                BarChartRodData(
                  toY: discount[index],
                  width: 10,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)
                  ),
                  color: Colors.orange,
                ),
                BarChartRodData(
                  toY: paid[index],
                  width: 10,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)
                  ),
                  color: Colors.purple,
                ),
                BarChartRodData(
                  toY: due[index],
                  width: 10,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4)
                  ),
                  color: Colors.red,
                ),
              ],
              barsSpace: 0,
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index >= 0 && index < type.length) {
                    return Padding(
                      padding:  EdgeInsets.only(top: 10.0),
                      child: Text(
                        type[index],
                        style: const TextStyle(
                          fontSize: 10,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.black12),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String label;
                switch (rodIndex) {
                  case 0: label = "Total"; break;
                  case 1: label = "Grand Total"; break;
                  case 2: label = "Discount"; break;
                  case 3: label = "Paid"; break;
                  case 4: label = "Due"; break;
                  default: label = "";
                }
                return BarTooltipItem(
                  '$label\n${rod.toY.toStringAsFixed(1)}',
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
    );
  }

  double getMaxY(List<double> allValues) {
    if (allValues.isEmpty) return 10;
    double maxVal = allValues.reduce((a, b) => a > b ? a : b);
    return (maxVal * 1.2).ceilToDouble(); // add 20% padding
  }
}
