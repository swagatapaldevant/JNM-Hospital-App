import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/animated_searchbar.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/dashboard_heading.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/health_article_card.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/health_status_widget.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/home_category_widget.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/home_dashboard_card.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/home_dashboard_doctor_widget.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Initialize screen dimensions
    AppDimensions.init(context);

    return Scaffold(
      body: Column(
        children: [
          // Top header
          const HomeHeader(),

          // Expanded scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.screenHeight * 0.01),

                    // Search Bar
                    AnimatedSearchBar(
                      onSearch: (value) {
                        print("Search: $value");
                      },
                    ),

                    // Dashboard card
                    const HomeDashboardCard(),

                    SizedBox(height: AppDimensions.contentGap2),

                    // Categories Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HomeCategoryWidget(
                          imageList: 'assets/images/home/d.png',
                          name: 'Doctor',
                          onTap: (){
                            Navigator.pushNamed(context, "/FindDoctorScreen");
                          },
                        ),
                        HomeCategoryWidget(
                          imageList: 'assets/images/home/Pharmacy.png',
                          name: 'Pharmacy',
                        ),
                        HomeCategoryWidget(
                          imageList: 'assets/images/home/Hospital.png',
                          name: 'Hospital',
                        ),
                        HomeCategoryWidget(
                          imageList: 'assets/images/home/Ambulance.png',
                          name: 'Ambulance',
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.contentGap2),

                    // Section Heading
                    DashboardHeading(headingName: 'Top Doctor',
                        onTap: (){
                      Navigator.pushNamed(context, "/TopDoctorScreen");
                        }
                    ),

                    SizedBox(height: AppDimensions.contentGap2),

                    SizedBox(
                      height: AppDimensions.screenHeight * 0.2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) =>
                            HomeDashboardDoctorWidget(
                              onTap: (){
                                Navigator.pushNamed(context, "/DoctorDetailsScreen");
                              },
                            ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.contentGap3),

                    // Section Heading
                    DashboardHeading(headingName: 'Health article'),
                    SizedBox(height: AppDimensions.screenHeight*0.01),

                    HealthArticleCard(),
                    SizedBox(height: AppDimensions.contentGap2),
                    DashboardHeading(headingName: 'Health status Summary', isSeeAllVisible: false,),
                    SizedBox(height: AppDimensions.screenHeight*0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        HealthStatusWidget(
                          image: 'assets/images/home/heartRate.png',
                          text: 'Heart Rate',
                          value: '215bpm',),
                        verticalDivider(),
                        HealthStatusWidget(
                          image: 'assets/images/home/calories.png',
                          text: 'Calories',
                          value: '756cal',),
                        verticalDivider(),
                        HealthStatusWidget(
                          image: 'assets/images/home/weight.png',
                          text: 'Weight',
                          value: '103lbs',),


                      ],
                    ),

                    SizedBox(height: AppDimensions.contentGap2),


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget verticalDivider(){
    return Container(
      height: ScreenUtils().screenHeight(context)*0.12,
      width: 2,
      color: AppColors.arrowBackground.withOpacity(0.13),
    );
  }
}
