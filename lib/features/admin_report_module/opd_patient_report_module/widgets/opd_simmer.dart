import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/simmers.dart';

class OpdScreenSimmer extends StatelessWidget {
  const OpdScreenSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [

            Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomShimmer(height: 16, width: 120, radius: 6),
                const CustomShimmer(height: 16, width: 80, radius: 6),
              ],
            ),
            
            const Spacer(),
            Container(
                height: 30,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  spacing: 2,
                  children: [
                    const CustomShimmer(height: 30, width: 55, radius: 10),
                    const SizedBox(width: 6),
                    const CustomShimmer(height: 30, width: 55, radius: 6),
                  ],
                ))
          ],
        ),
        SizedBox(height: 12),
        // Graph Card
        Container(
          //margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomShimmer(height: 16, width: 120, radius: 6),
              const SizedBox(height: 16),
              const LineGraphShimmer(),
            ],
          ),
        ),

        // Card list shimmer
        const SizedBox(height: 12),
        const CardListShimmer(),
      ],
    );
  }
}
