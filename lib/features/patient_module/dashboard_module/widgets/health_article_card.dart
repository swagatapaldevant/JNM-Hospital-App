import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class HealthArticleCard extends StatelessWidget {
  const HealthArticleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
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
        padding: EdgeInsets.all(AppDimensions.screenWidth * 0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://media.istockphoto.com/id/485205108/photo/tablet-computer-on-a-desk-health-and-medical.jpg?s=612x612&w=0&k=20&c=aVpnGq6c5dUZgXfEJC09UJE-Btwn5aDqEDCEg9Zh15g=",
                height: AppDimensions.screenHeight * 0.08,
                width: AppDimensions.screenHeight * 0.1,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(width: AppDimensions.screenWidth * 0.03),

            // Right: Text and icon
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and bookmark
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          "The 25 Healthiest Fruits You Can Eat, According to a Nutritionist",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.colorBlack,
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.contentGap3),
                      // Bookmark icon
                      Icon(
                        Icons.bookmark,
                        size: 20,
                        color: AppColors.arrowBackground,
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Date and read time
                  Row(
                    children: [
                      Text(
                        "Jun 10, 2023",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.gray8,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "5 min read",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.gray8,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
