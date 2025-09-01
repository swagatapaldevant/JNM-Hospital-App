import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class CommonHeaderForReportModule extends StatelessWidget {
  final String headingName;
  Function()? onSearchTap;
  Function()? filterTap;
  final bool? isVisibleFilter;
  final bool? isVisibleSearch;
  CommonHeaderForReportModule({super.key,this.isVisibleFilter,this.isVisibleSearch, required this.headingName, this.onSearchTap, this.filterTap});

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Container(
      width: AppDimensions.screenWidth,
      decoration: BoxDecoration(
        color: AppColors.overviewCardBgColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 7.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.25),
            offset: const Offset(
              1.0,
              3.0,
            ),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.79),
            offset: const Offset(
              -2.0,
              0.0,
            ),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: AppColors.white.withOpacity(0.40),
            offset: const Offset(
              2.0,
              0.0,
            ),
            blurRadius: 6.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all( AppDimensions.screenPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bounceable(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: AppColors.white,)),
              Text(headingName, style: TextStyle(
                fontSize: 16,
                color: AppColors.white,
                fontWeight: FontWeight.w600
              ),),

              Row(
                spacing: 10,
                children: [
                  Visibility(
                    visible: isVisibleSearch??true,
                    child: Bounceable(
                        onTap: onSearchTap,
                        child: Icon(Icons.search, color: AppColors.white,size: 30,)),
                  ),
                  Visibility(
                    visible: isVisibleFilter?? true,
                    child: Bounceable(
                        onTap: filterTap,
                        child: Icon(Icons.filter_list_alt, color: AppColors.white,size: 30,)),
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
