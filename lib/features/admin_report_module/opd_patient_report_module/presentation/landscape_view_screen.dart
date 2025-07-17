// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
// import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
// import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
//
// class DepartmentWiseOpdReportLandscapeScreen extends StatefulWidget {
//   final List<FlSpot> newCount;
//   final List<FlSpot> oldCount;
//   final List<String> departmentName;
//   const DepartmentWiseOpdReportLandscapeScreen({super.key, required this.newCount, required this.oldCount, required this.departmentName});
//
//   @override
//   State<DepartmentWiseOpdReportLandscapeScreen> createState() =>
//       _DepartmentWiseOpdReportLandscapeScreenState();
// }
//
// class _DepartmentWiseOpdReportLandscapeScreenState
//     extends State<DepartmentWiseOpdReportLandscapeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Force landscape
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }
//
//   @override
//   void dispose() {
//     // Restore to portrait
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     AppDimensions.init(context);
//     return Scaffold(
//
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: ScreenUtils().screenHeight(context) * 0.06),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 spacing: 20,
//                 children: [
//                   Bounceable(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(Icons.close, size: 30),
//                   ),
//                   Text("Department Wise Patient Count comparison graph", style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.colorBlack,
//                     fontSize: 14
//                   ),)
//                 ],
//               ),
//               Row(
//                 spacing: ScreenUtils().screenWidth(context)*0.05,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Row(
//                     spacing: 5,
//                     children: [
//                       CircleAvatar(backgroundColor: AppColors.redColor,radius: 5,),
//                       Text("old", style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.redColor,
//                           fontWeight: FontWeight.w500
//                       ),),
//                     ],
//                   ),
//
//                   Row(
//                     spacing: 5,
//                     children: [
//                       CircleAvatar(backgroundColor: AppColors.arrowBackground,radius: 5,),
//                       Text("New", style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.arrowBackground,
//                           fontWeight: FontWeight.w500
//                       ),),
//                     ],
//                   )
//                 ],
//               ),
//
//               SizedBox(height: ScreenUtils().screenHeight(context)*0.05,),
//
//               Center(
//                 child: AspectRatio(
//                   aspectRatio: 3.5,
//                   child: LineChart(_buildLineChartData()),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//
//   }
//
//   LineChartData _buildLineChartData() {
//     return LineChartData(
//       minY: 0,
//       gridData: FlGridData(show: false), // Remove grid lines
//       titlesData: FlTitlesData(
//         leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: (value, _) {
//               int index = value.toInt();
//               if (index >= 0 && index < widget.departmentName.length) {
//                 return Transform.rotate(
//                   angle: 45 * 3.1415926535 / 180,
//                   child: Text(
//                     widget.departmentName[index],
//                     style: const TextStyle(fontSize: 10),
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             },
//             interval: 1,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: const Border(
//           bottom: BorderSide(color: Colors.black12), // Only bottom line
//         ),
//       ),
//       lineBarsData: [
//         LineChartBarData(
//           isCurved: true,
//           spots: widget.newCount,
//           isStrokeCapRound: true,
//           barWidth: 2,
//           color: AppColors.arrowBackground,
//           dotData: FlDotData(show: true),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.arrowBackground.withOpacity(0.3),
//                 AppColors.arrowBackground.withOpacity(0.05),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//         LineChartBarData(
//           isCurved: true,
//           spots: widget.oldCount,
//           isStrokeCapRound: true,
//           barWidth: 2,
//           color: Colors.red,
//           dotData: FlDotData(show: true),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [
//                 Colors.red.withOpacity(0.3),
//                 Colors.red.withOpacity(0.05),
//               ],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//       ],
//       lineTouchData: LineTouchData(
//         handleBuiltInTouches: true,
//         touchTooltipData: LineTouchTooltipData(
//           tooltipRoundedRadius: 3,
//           getTooltipItems: (touchedSpots) {
//             return touchedSpots.map((spot) {
//               int yearIndex = spot.x.toInt();
//               String year = (yearIndex >= 0 && yearIndex < widget.departmentName.length)
//                   ? widget.departmentName[yearIndex]
//                   : "";
//               return LineTooltipItem(
//                 '$year\n${spot.y.toStringAsFixed(1)}',
//                 const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               );
//             }).toList();
//           },
//         ),
//       ),
//     );
//   }
// }
//
//

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class DepartmentWiseOpdReportLandscapeScreen extends StatefulWidget {
  final List<FlSpot> newCount;
  final List<FlSpot> oldCount;
  final List<String> departmentName;

  const DepartmentWiseOpdReportLandscapeScreen({
    super.key,
    required this.newCount,
    required this.oldCount,
    required this.departmentName,
  });

  @override
  State<DepartmentWiseOpdReportLandscapeScreen> createState() =>
      _DepartmentWiseOpdReportLandscapeScreenState();
}

class _DepartmentWiseOpdReportLandscapeScreenState
    extends State<DepartmentWiseOpdReportLandscapeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _zoomFactor = 1.0;

  @override
  void initState() {
    super.initState();

    // Force landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        100,
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      if (_zoomFactor < 1.0) {
        _zoomFactor += 0.2;
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_zoomFactor > 0.6) {
        _zoomFactor -= 0.2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);

    // Increase per department width
    double chartWidth = widget.departmentName.length * 150 * _zoomFactor;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.screenHeight * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Bounceable(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close, size: 30),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Text(
                      "Department Wise Patient Count Comparison Graph",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorBlack,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              //const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                          backgroundColor: AppColors.redColor, radius: 5),
                      const SizedBox(width: 5),
                      const Text(
                        "Old",
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.redColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      const CircleAvatar(
                          backgroundColor: AppColors.arrowBackground,
                          radius: 5),
                      const SizedBox(width: 5),
                      const Text(
                        "New",
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.arrowBackground,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: const Icon(Icons.remove, size: 26),
                    onPressed: _zoomOut,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 26),
                    onPressed: _zoomIn,
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: false,
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: SizedBox(
                      width: chartWidth,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: AppDimensions.screenHeight * 0.07,
                            right: AppDimensions.screenHeight * 0.07,
                          ),
                          child: LineChart(_buildLineChartData()),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    double maxDataY = 0;
    for (var spot in [...widget.newCount, ...widget.oldCount]) {
      if (spot.y > maxDataY) {
        maxDataY = spot.y;
      }
    }
    double adjustedMaxY = maxDataY + (maxDataY * 0.2);
    double minY = -5;

    return LineChartData(
      minY: minY,
      maxY: adjustedMaxY,
      gridData: FlGridData(show: true, drawVerticalLine: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              int index = value.toInt();
              if (index >= 0 && index < widget.departmentName.length) {
                return Transform.rotate(
                  angle: 10 * 3.1415926535 / 180,
                  child: Text(
                    widget.departmentName[index],
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
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
        border: const Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: widget.newCount,
          isStrokeCapRound: true,
          barWidth: 2,
          color: AppColors.arrowBackground,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
        LineChartBarData(
          isCurved: true,
          spots: widget.oldCount,
          isStrokeCapRound: true,
          barWidth: 2,
          color: Colors.red,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 3,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              int index = spot.x.toInt();
              String dep = (index >= 0 && index < widget.departmentName.length)
                  ? widget.departmentName[index]
                  : "";
              return LineTooltipItem(
                '$dep\n${spot.y.toStringAsFixed(1)}',
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
