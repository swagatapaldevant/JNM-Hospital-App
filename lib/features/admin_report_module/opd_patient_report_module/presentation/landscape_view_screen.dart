import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class DepartmentWiseOpdReportLandscapeScreen extends StatefulWidget {
  const DepartmentWiseOpdReportLandscapeScreen({super.key});

  @override
  State<DepartmentWiseOpdReportLandscapeScreen> createState() =>
      _DepartmentWiseOpdReportLandscapeScreenState();
}

class _DepartmentWiseOpdReportLandscapeScreenState
    extends State<DepartmentWiseOpdReportLandscapeScreen> {
  @override
  void initState() {
    super.initState();
    // Force landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  final List<FlSpot> spotsType1 = [
    FlSpot(0, 3),
    FlSpot(1, 5),
    FlSpot(2, 2),
    FlSpot(3, 7),
    FlSpot(4, 6),
    FlSpot(5, 4),
    FlSpot(6, 8),
    FlSpot(7, 7),
    FlSpot(8, 6),
    FlSpot(9, 4),
    FlSpot(10, 8),
  ];

  final List<FlSpot> spotsType2 = [
    FlSpot(0, 8),
    FlSpot(1, 1),
    FlSpot(2, 9),
    FlSpot(3, 3),
    FlSpot(4, 8),
    FlSpot(5, 4),
    FlSpot(6, 8),
    FlSpot(7, 6),
    FlSpot(8, 6),
    FlSpot(9, 5),
    FlSpot(10, 8),
  ];

  final List<String> departmentName = [
    "Gen Med",
    "Ortho",
    "Gynae",
    "Pedia",
    "ENT",
    "Derma",
    "Cardio",
    "Pedia2",
    "ENT2",
    "Derma2",
    "Cardio2",
  ];

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtils().screenHeight(context) * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 20,
                children: [
                  Bounceable(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, size: 30),
                  ),
                  Text("Department Wise Patient Count comparison graph", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.colorBlack,
                    fontSize: 14
                  ),)
                ],
              ),
              Row(
                spacing: ScreenUtils().screenWidth(context)*0.05,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    spacing: 5,
                    children: [
                      CircleAvatar(backgroundColor: AppColors.redColor,radius: 5,),
                      Text("old", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.redColor,
                          fontWeight: FontWeight.w500
                      ),),
                    ],
                  ),

                  Row(
                    spacing: 5,
                    children: [
                      CircleAvatar(backgroundColor: AppColors.arrowBackground,radius: 5,),
                      Text("New", style: TextStyle(
                          fontSize: 12,
                          color: AppColors.arrowBackground,
                          fontWeight: FontWeight.w500
                      ),),
                    ],
                  )
                ],
              ),

              SizedBox(height: ScreenUtils().screenHeight(context)*0.05,),

              Center(
                child: AspectRatio(
                  aspectRatio: 3.5,
                  child: LineChart(_buildLineChartData()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    return LineChartData(
      minY: 0,
      gridData: FlGridData(show: false), // Remove grid lines
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              int index = value.toInt();
              if (index >= 0 && index < departmentName.length) {
                return Transform.rotate(
                  angle: 45 * 3.1415926535 / 180,
                  child: Text(
                    departmentName[index],
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
        border: const Border(
          bottom: BorderSide(color: Colors.black12), // Only bottom line
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: spotsType1,
          isStrokeCapRound: true,
          barWidth: 2,
          color: AppColors.arrowBackground,
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
          barWidth: 2,
          color: Colors.red,
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
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
// import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
// import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
//
// class DepartmentWiseOpdReportLandscapeScreen extends StatelessWidget {
//   DepartmentWiseOpdReportLandscapeScreen({super.key});
//
//   final List<FlSpot> spotsType1 = [
//     FlSpot(0, 3),
//     FlSpot(1, 5),
//     FlSpot(2, 2),
//     FlSpot(3, 7),
//     FlSpot(4, 6),
//     FlSpot(5, 4),
//     FlSpot(6, 8),
//     FlSpot(7, 7),
//     FlSpot(8, 6),
//     FlSpot(9, 4),
//     FlSpot(10, 8),
//   ];
//
//   final List<FlSpot> spotsType2 = [
//     FlSpot(0, 8),
//     FlSpot(1, 1),
//     FlSpot(2, 9),
//     FlSpot(3, 3),
//     FlSpot(4, 8),
//     FlSpot(5, 4),
//     FlSpot(6, 8),
//     FlSpot(7, 6),
//     FlSpot(8, 6),
//     FlSpot(9, 5),
//     FlSpot(10, 8),
//   ];
//
//   final List<String> departmentName = [
//     "Gen Med",
//     "Ortho",
//     "Gynae",
//     "Pedia",
//     "ENT",
//     "Derma",
//     "Cardio",
//     "Pedia2",
//     "ENT2",
//     "Derma2",
//     "Cardio2",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     AppDimensions.init(context);
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: ScreenUtils().screenHeight(context) * 0.03),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Bounceable(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(Icons.close, size: 30),
//                   ),
//                   SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       "Department Wise Patient Count Comparison Graph",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.colorBlack,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(backgroundColor: AppColors.redColor, radius: 5),
//                       SizedBox(width: 5),
//                       Text(
//                         "Old",
//                         style: TextStyle(fontSize: 12, color: AppColors.redColor, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: 20),
//                   Row(
//                     children: [
//                       CircleAvatar(backgroundColor: AppColors.arrowBackground, radius: 5),
//                       SizedBox(width: 5),
//                       Text(
//                         "New",
//                         style: TextStyle(fontSize: 12, color: AppColors.arrowBackground, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               // Pseudo landscape: Wide horizontal scrollable chart container
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 2.5, // Increase to simulate wide view
//                     child: LineChart(_buildLineChartData()),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   LineChartData _buildLineChartData() {
//     return LineChartData(
//       minY: 0,
//       gridData: FlGridData(show: false),
//       titlesData: FlTitlesData(
//         leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: (value, _) {
//               int index = value.toInt();
//               if (index >= 0 && index < departmentName.length) {
//                 return Transform.rotate(
//                   angle: 45 * 3.1415926535 / 180,
//                   child: Text(
//                     departmentName[index],
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
//         border: const Border(bottom: BorderSide(color: Colors.black12)),
//       ),
//       lineBarsData: [
//         LineChartBarData(
//           isCurved: true,
//           spots: spotsType1,
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
//           spots: spotsType2,
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
//     );
//   }
// }
