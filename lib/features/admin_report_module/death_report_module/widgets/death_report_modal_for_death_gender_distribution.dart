import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_button.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/custom_button.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/admin_report_module/common_widgets/searchable_dropdown.dart';

Future<String?> showCommonModalForDeathGenderDistribution(BuildContext context) {

  return showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      SizedBox(
                        width: ScreenUtils().screenWidth(context) * 0.6,
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Bounceable(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.close, size: 30,color: AppColors.redColor,))),
                              SizedBox(height: ScreenUtils().screenHeight(context)*0.02,),
                              Center(
                                child: Text(
                                  "Gender Distribution",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                    sections: [
                                      PieChartSectionData(
                                        value: 90,
                                        color: Colors.blue,
                                        //title: "${malePercentage.toStringAsFixed(1)}%\nMale",
                                        radius: 70,
                                        titleStyle: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        value: 80,
                                        color: Colors.pink,
                                        //title: "${femalePercentage.toStringAsFixed(1)}%\nFemale",
                                        radius: 70,
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

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
