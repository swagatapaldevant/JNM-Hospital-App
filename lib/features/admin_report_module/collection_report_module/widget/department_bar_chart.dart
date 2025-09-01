import 'package:flutter/material.dart';
import 'dart:math' as math;

class DepartmentBarChart extends StatelessWidget {
  final Map<String, double> totals;
  final String? subtitle;

  const DepartmentBarChart({
    super.key,
    required this.totals,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final entries = totals.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // largest first

    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text("No department totals in selected range"),
      );
    }

    // height per bar
    const barH = 22.0;
    const gap = 12.0;
    final chartHeight = entries.length * (barH + gap) + 24;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                "Department-wise total",
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black,
                ),
              ),
              const Spacer(),
              if (subtitle != null)
                Text(
                  "(${subtitle!})",
                  style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black54,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: chartHeight,
            child: CustomPaint(
              painter: _DeptBarPainter(entries: entries),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeptBarPainter extends CustomPainter {
  final List<MapEntry<String, double>> entries;

  _DeptBarPainter({required this.entries});

  static const List<Color> _palette = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF10B981), // Green
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF8B5CF6), // Violet
    Color(0xFF06B6D4), // Cyan
    Color(0xFFEC4899), // Pink
    Color(0xFF22C55E), // Emerald
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    // Styles
    const barH = 22.0;
    const gap = 12.0;
    const rightPad = 16.0;
    const topPad = 12.0;
    const minLeftPad = 72.0; // minimum space for labels

    final labelStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
    final valueStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );

    // Compute max label width
    double maxLabelW = 0;
    for (final e in entries) {
      final tp = TextPainter(
        text: TextSpan(text: e.key, style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: size.width * 0.6);
      maxLabelW = math.max(maxLabelW, tp.width);
    }

    final leftPad = math.min(size.width * 0.45, math.max(minLeftPad, maxLabelW + 16));
    final chartW = math.max(0, size.width - leftPad - rightPad);

    // Max value for scaling
    final maxV = entries.map((e) => e.value).fold<double>(0, math.max);
    if (maxV <= 0 || chartW <= 0) return;

    // Optional faint baseline
    final axisPaint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(leftPad, topPad - 6),
        Offset(size.width - rightPad, topPad - 6), axisPaint);

    // Draw each bar
    final barPaint = Paint()..isAntiAlias = true;

    for (int i = 0; i < entries.length; i++) {
      final dep = entries[i].key;
      final val = entries[i].value;

      final y = topPad + i * (barH + gap);
      final w = (val / maxV) * chartW;

      // Label (left)
      final labelTP = TextPainter(
        text: TextSpan(text: dep, style: labelStyle),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: leftPad - 12);
      labelTP.paint(canvas, Offset(8, y + (barH - labelTP.height) / 2));

      // Bar
      barPaint.color = _palette[i % _palette.length].withOpacity(0.95);
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(leftPad, y, w, barH),
        const Radius.circular(8),
      );
      canvas.drawRRect(rrect, barPaint);

      // Value (try to place just after bar; clamp to canvas width)
      final valueTP = TextPainter(
        text: TextSpan(text: "₹${val.toStringAsFixed(2)}", style: valueStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width);
      double textX = leftPad + w + 6;
      if (textX + valueTP.width > size.width - 4) {
        textX = leftPad + w - valueTP.width - 6; // place inside bar if overflow
        final insideStyle = valueStyle.copyWith(color: Colors.white);
        valueTP.text = TextSpan(text: "₹${val.toStringAsFixed(2)}", style: insideStyle);
        valueTP.layout();
      }
      valueTP.paint(canvas, Offset(textX, y + (barH - valueTP.height) / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DeptBarPainter old) {
    if (old.entries.length != entries.length) return true;
    for (int i = 0; i < entries.length; i++) {
      if (old.entries[i].key != entries[i].key ||
          old.entries[i].value != entries[i].value) return true;
    }
    return false;
  }
}
