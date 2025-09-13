import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/simmers.dart' show CustomShimmer;

// class BillCardShimmer extends StatelessWidget {
//   const BillCardShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//         height: 200,
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header section with gradient background shimmer
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: AppColors.gray3,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   // Bill type chip shimmer
//                   CustomShimmer(height: 24, width: 80, radius: 12),
                  
//                   // Bill ID shimmer  
//                   CustomShimmer(height: 18, width: 90, radius: 6),
                  
//                   // Status/date shimmer
//                   CustomShimmer(height: 20, width: 70, radius: 6),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 16),
            
//             // Patient info section
//             Row(
//               children: const [
//                 // Avatar placeholder
//                 CustomShimmer(height: 40, width: 40, radius: 20),
//                 SizedBox(width: 12),
                
//                 // Patient details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Patient name
//                       CustomShimmer(height: 16, width: 140, radius: 6),
//                       SizedBox(height: 6),
//                       // Patient ID or additional info
//                       CustomShimmer(height: 14, width: 100, radius: 6),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
            
//             const SizedBox(height: 16),
            
//             // Amount and action section
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 // Amount shimmer
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomShimmer(height: 12, width: 60, radius: 6),
//                     SizedBox(height: 4),
//                     CustomShimmer(height: 20, width: 90, radius: 6),
//                   ],
//                 ),
                
//                 // Action button shimmer
//                 CustomShimmer(height: 32, width: 80, radius: 16),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BillCardShimmer extends StatelessWidget {
  const BillCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.gray3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomShimmer(height: 24, width: 80, radius: 12),
                  CustomShimmer(height: 18, width: 90, radius: 6),
                  CustomShimmer(height: 20, width: 70, radius: 6),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Patient info
            Row(
              children: const [
                CustomShimmer(height: 40, width: 40, radius: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer(height: 16, width: 140, radius: 6),
                      SizedBox(height: 6),
                      CustomShimmer(height: 14, width: 100, radius: 6),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Amount + action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(height: 12, width: 60, radius: 6),
                    SizedBox(height: 4),
                    CustomShimmer(height: 20, width: 90, radius: 6),
                  ],
                ),
                CustomShimmer(height: 32, width: 80, radius: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
