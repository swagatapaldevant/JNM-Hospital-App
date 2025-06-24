import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/animated_searchbar.dart';
import 'package:jnm_hospital_app/core/utils/commonWidgets/common_header.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';
import 'package:jnm_hospital_app/features/patient_module/dashboard_module/widgets/dashboard_heading.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({super.key});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: AppDimensions.screenPadding,
                right: AppDimensions.screenPadding,
                top: AppDimensions.screenPadding),
            child: Column(
              children: [
                CommonHeader(
                  screenName: 'Find Doctors',
                ),
                SizedBox(
                  height: AppDimensions.screenHeight * 0.01,
                ),
                AnimatedSearchBar(
                  onSearch: (value) {
                    print("Search: $value");
                  },
                ),
                DashboardHeading(
                    headingName: 'Category',
                    isSeeAllVisible: false,
                    onTap: () {}),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                Wrap(
                    spacing: 8, // horizontal spacing
                    runSpacing: 8,
                    children: [
                      _buildDoctorsCategory(
                          name: 'General',
                          icon: 'assets/images/find_doctors/general.png',
                          onTap: () {}),
                      _buildDoctorsCategory(
                          name: 'Lungs specialist',
                          icon: 'assets/images/find_doctors/Lungs.png',
                          onTap: () {}),
                      _buildDoctorsCategory(
                          name: 'Dentist',
                          icon: 'assets/images/find_doctors/Dentist.png',
                          onTap: () {}),
                      _buildDoctorsCategory(
                          name: 'Psychiatrist',
                          icon: 'assets/images/find_doctors/Psychiatrist.png',
                          onTap: () {}),
                      _buildDoctorsCategory(
                          name: 'Covid-19',
                          icon: 'assets/images/find_doctors/Covid.png',
                          onTap: () {}),
                      _buildDoctorsCategory(
                          name: 'Surgeon',
                          icon: 'assets/images/find_doctors/Syringe.png',
                          onTap: () {}),
                      _buildDoctorsCategory(
                          name: 'Cardiologist',
                          icon: 'assets/images/find_doctors/Cardiologist.png',
                          onTap: () {}),
                    ]),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                DashboardHeading(
                    headingName: 'Recommended Doctor',
                    isSeeAllVisible: false,
                    onTap: () {}),

                ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding:  EdgeInsets.only(top: AppDimensions.screenWidth*0.03),
                        child: _buildRecommendedDoctorsWidget(
                          onTap: (){
                            Navigator.pushNamed(context, "/DoctorDetailsScreen");
                          }
                        ),
                      );
                    }),

                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                DashboardHeading(
                    headingName: 'Your Recent Doctor',
                    isSeeAllVisible: false,
                    onTap: () {}),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    recentDoctor(onTap: () {
                      Navigator.pushNamed(context, "/DoctorDetailsScreen");

                    }),
                    recentDoctor(onTap: () {
                      Navigator.pushNamed(context, "/DoctorDetailsScreen");

                    }),
                    recentDoctor(onTap: () {
                      Navigator.pushNamed(context, "/DoctorDetailsScreen");

                    }),
                    recentDoctor(onTap: () {
                      Navigator.pushNamed(context, "/DoctorDetailsScreen");

                    }),
                  ],
                ),
                SizedBox(
                  height: AppDimensions.contentGap3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsCategory({
    required String name,
    required String icon,
    required void Function() onTap,
  }) {
    return Column(
      spacing: 10,
      children: [
        Bounceable(
          onTap: onTap,
          child: Container(
            height: AppDimensions.screenHeight * 0.06,
            width: AppDimensions.screenWidth * 0.15,
            decoration: BoxDecoration(
              color: AppColors.arrowBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gray7.withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                icon,
              ),
            ),
          ),
        ),
        Text(
          name,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.dashboardCategoryTextColor),
        ),
      ],
    );
  }

  Widget _buildRecommendedDoctorsWidget({required void Function() onTap}) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray7),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray7.withOpacity(0.5),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.04),
          child: Row(
            spacing: ScreenUtils().screenWidth(context)*0.05,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://img.freepik.com/free-photo/portrait-experienced-professional-therapist-with-stethoscope-looking-camera_1098-19305.jpg?semt=ais_hybrid&w=740"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dr. Marcus Horizon",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.colorBlack),
                  ),
                  SizedBox(
                    height: AppDimensions.screenHeight * 0.005,
                  ),
                  Text(
                    "Chardiologist",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray8),
                  ),
                  SizedBox(
                    height: AppDimensions.screenHeight * 0.01,
                  ),
                  Container(
                    height: 3,
                    width: AppDimensions.screenWidth * 0.5,
                    color: AppColors.arrowBackground.withOpacity(0.13),
                  ),
                  SizedBox(
                    height: AppDimensions.screenHeight * 0.01,
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      rating(),
                      distance(),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget rating() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColors.starBackgroundColor),
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Row(
          spacing: 4,
          children: [
            Icon(
              Icons.star,
              color: AppColors.starColor,
              size: 14,
            ),
            Text(
              "4.7",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.starColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget distance() {
    return Row(
      spacing: 2,
      children: [
        Icon(
          Icons.location_on,
          color: AppColors.gray8,
          size: 15,
        ),
        Text(
          "800m away",
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray8),
        ),
      ],
    );
  }

  Widget recentDoctor({required void Function() onTap}) {
    return Column(
      spacing: 8,
      children: [
        Bounceable(
          onTap: onTap,
          child: CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(
              "https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827774.jpg?semt=ais_hybrid&w=740"
            )
          ),
        ),
        Text(
          "Dr Marcus",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.colorBlack,
              fontSize: 12),
        )
      ],
    );
  }
}
