import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/approval_system_module/approval_dashboard/ui/glasscard.dart';
import 'package:jnm_hospital_app/features/approval_system_module/common/widgets/simmers.dart';

class GlassCardShimmer extends StatelessWidget {
  const GlassCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomShimmer(height: 18, width: 180, radius: 6),
          const SizedBox(height: 6),
          const CustomShimmer(height: 14, width: 240, radius: 6),
          const SizedBox(height: 4),
          const CustomShimmer(height: 14, width: 180, radius: 6),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomShimmer(height: 120, width: 120, radius: 60),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: const [
                          CustomShimmer(height: 14, width: 14, radius: 4),
                          SizedBox(width: 8),
                          CustomShimmer(height: 14, width: 80, radius: 6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
