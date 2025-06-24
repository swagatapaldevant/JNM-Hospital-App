import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height:AppDimensions.screenHeight ,
          child: Stack(
            children: [
              // Top section
              Container(
                height: AppDimensions.screenHeight*0.45,
                width:AppDimensions.screenWidth,
                decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                     AppColors.arrowBackground,
                     AppColors.arrowBackground.withOpacity(0.8),
                     AppColors.profileGradient,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: AppDimensions.contentGap2,),
                      SizedBox(height: AppDimensions.contentGap2,),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                       SizedBox(height: AppDimensions.contentGap2),
                       SizedBox(height: AppDimensions.contentGap2),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:  [
                            _HealthStat(
                              icon: Icons.favorite,
                              label: "Heart rate",
                              value: "215bpm",
                            ),
                            Container(
                              height: ScreenUtils().screenHeight(context)*0.07,
                              width: 1,
                              color: AppColors.white,
                            ),
                            _HealthStat(
                              icon: Icons.local_fire_department,
                              label: "Calories",
                              value: "756cal",
                            ),
                            Container(
                              height: ScreenUtils().screenHeight(context)*0.07,
                              width: 1,
                              color: AppColors.white,
                            ),
                            _HealthStat(
                              icon: Icons.fitness_center,
                              label: "Weight",
                              value: "103lbs",
                            ),
                          ],
                        ),
                      ),
                       SizedBox(height: AppDimensions.contentGap3),
                    ],
                  ),
                ),
              ),

              // Overlapping Container
              Positioned(
                top: AppDimensions.screenHeight*0.42, // make sure it overlaps just enough
                left: 0,
                right: 0,
                child: Container(
                  height: AppDimensions.screenHeight*0.66,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    children:  [
                      SizedBox(height: AppDimensions.contentGap2),
                      _ProfileOption(
                        icon: Icons.favorite_border,
                        title: 'My Saved',
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                        child: Divider(color: AppColors.starBackgroundColor,),
                      ),
                      _ProfileOption(
                        onTap: (){
                          Navigator.pushNamed(context, "/BookingHistoryScreen");
                        },
                        icon: Icons.calendar_today,
                        title: 'Appointment',
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                        child: Divider(color: AppColors.starBackgroundColor,),
                      ),
                      _ProfileOption(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Payment Method',
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                        child: Divider(color: AppColors.starBackgroundColor,),
                      ),
                      _ProfileOption(
                        icon: Icons.help_outline,
                        title: 'FAQs',
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: AppDimensions.screenPadding),
                        child: Divider(color: AppColors.starBackgroundColor,),
                      ),
                      _ProfileOption(
                        icon: Icons.logout_outlined,
                        title: 'Logout',
                        isLogout: true,
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
  }
}

class _HealthStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HealthStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white,size: 30,),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ],
    );
  }
}

// Profile Option Row
class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  Function()? onTap;

   _ProfileOption({
    required this.icon,
    required this.title,
    this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLogout ? Colors.red : AppColors.colorBlack;
    final iconBg = isLogout ? Colors.red.shade50 : AppColors.starColor.withOpacity(0.2);
    final iconColor = isLogout ? Colors.red : AppColors.starColor;

    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: iconBg,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: iconColor, size: 20,),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 20),
      onTap: onTap
    );
  }
}
