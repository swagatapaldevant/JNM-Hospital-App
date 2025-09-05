import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double radius;

  const CustomShimmer({
    super.key,
    required this.height,
    required this.width,
    this.radius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class LineGraphShimmer extends StatelessWidget {
  const LineGraphShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(8, (index) {
          final dotHeight = (index.isEven ? 80 : 140);
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomShimmer(height: dotHeight.toDouble(), width: 10, radius: 4),
              const SizedBox(height: 4),
              const CustomShimmer(height: 6, width: 20, radius: 3), // x-label
            ],
          );
        }),
      ),
    );
  }
}

class PieGraphShimmer extends StatelessWidget {
  const PieGraphShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomShimmer(
        height: 180,
        width: 180,
        radius: 90,
      ),
    );
  }
}


class CardListShimmer extends StatelessWidget {
  final int count;
  const CardListShimmer({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: const CustomShimmer(
            height: 80,
            width: double.infinity,
            radius: 12,
          ),
        ),
      ),
    );
  }
}


