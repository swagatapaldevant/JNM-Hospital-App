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

// class _LineGraphShimmerPainter extends CustomPainter {
//   final List<Offset> points;

//   _LineGraphShimmerPainter(this.points);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint linePaint = Paint()
//       ..color = Colors.grey.shade300
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke;

//     final Paint dotPaint = Paint()
//       ..color = Colors.grey.shade400
//       ..style = PaintingStyle.fill;

//     // Draw smooth curved line using quadratic Bezier curves
//     final Path path = Path();
//     if (points.isNotEmpty) {
//       path.moveTo(points.first.dx, size.height - points.first.dy);

//       for (int i = 0; i < points.length - 1; i++) {
//         final current = Offset(points[i].dx, size.height - points[i].dy);
//         final next = Offset(points[i + 1].dx, size.height - points[i + 1].dy);
        
//         // Calculate control point for smooth curve
//         final controlPointX = current.dx + (next.dx - current.dx) * 0.5;
//         final controlPointY = current.dy; // Keep control point at current height for natural curve
        
//         path.quadraticBezierTo(controlPointX, controlPointY, next.dx, next.dy);
//       }
//     }

//     canvas.drawPath(path, linePaint);

//     // Draw shimmer dots
//     for (var point in points) {
//       canvas.drawCircle(
//         Offset(point.dx, size.height - point.dy),
//         6,
//         dotPaint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

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
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
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
              // Header row with title + chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomShimmer(
                    height: 16,
                    width: 140,
                    radius: 6,
                  ),
                  const CustomShimmer(
                    height: 20,
                    width: 20,
                    radius: 20, // pill-shaped chip
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sub headers
              const CustomShimmer(
                height: 14,
                width: 200,
                radius: 6,
              ),
              const SizedBox(height: 8),
              const CustomShimmer(
                height: 14,
                width: 160,
                radius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


