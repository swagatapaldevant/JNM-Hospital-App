import 'dart:math' as math;
import 'package:flutter/material.dart';

class CollectionExpandableCard extends StatefulWidget {
  final String date;
  final double totalCollection;
  final Map<String, Map<String, double>> departmentData;
  final String refund;
  final bool refundShow;
  final void Function(String dept, Map<String, double> totals)? onDepartmentTap;

  const CollectionExpandableCard(
      {super.key,
      required this.date,
      required this.totalCollection,
      required this.departmentData,
      required this.refund,
        this.onDepartmentTap,
      required this.refundShow});

  @override
  State<CollectionExpandableCard> createState() =>
      _CollectionExpandableCardState();
}

class _CollectionExpandableCardState extends State<CollectionExpandableCard> {
  bool _expanded = false;

  // A pleasant palette for slices (will cycle if departments > palette length)
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Row (always visible)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.date.toString().length>20?
                  widget.date.toUpperCase().substring(0, 20):widget.date.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "₹${widget.totalCollection.toStringAsFixed(2)}",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.green[700],
                            fontSize: 15,
                          ),
                        ),
                        widget.refundShow == true
                            ?
                        widget.refund.toString()=="0.0"?SizedBox.shrink():
                        Text(
                                "(Refund ₹${widget.refund})",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                  fontSize: 11,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.keyboard_arrow_down_rounded),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --------- PIE CHART (departments by Total) ----------
                  _buildPieSection(context),
                  const SizedBox(height: 12),

                  // --------- DEPARTMENT CARDS ----------
                  ...widget.departmentData.entries.map((dept) {
                    final name = dept.key;
                    final details = dept.value;

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => widget.onDepartmentTap?.call(name, details),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStat("Cash", details["cash"] ?? 0),
                                _buildStat("Bank", details["bank"] ?? 0),
                                _buildStat("Total", details["total"] ?? 0,
                                    isHighlight: true),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          )
        ],
      ),
    );
  }

  /// PIE SECTION: always chart (left) + legend (right) in a Row
  Widget _buildPieSection(BuildContext context) {
    // Build slices from department totals
    final entries = widget.departmentData.entries
        .map((e) => MapEntry(e.key, (e.value["total"] ?? 0).toDouble()))
        .where((kv) => kv.value > 0)
        .toList();

    final total = entries.fold<double>(0, (a, b) => a + b.value);

    if (total <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text("No departmental totals to chart"),
        ),
      );
    }

    // Assign colors (cycle palette)
    final slices = <_PieSlice>[];
    for (int i = 0; i < entries.length; i++) {
      slices.add(_PieSlice(
        label: entries[i].key,
        value: entries[i].value,
        color: _palette[i % _palette.length],
      ));
    }

    const chartSize = 120.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: chartSize,
            height: chartSize,
            child: CustomPaint(painter: _PiePainter(slices: slices)),
          ),
          const SizedBox(width: 16),
          // legend to the right, stretches to take the rest of the width
          Expanded(child: _buildLegend(slices, total)),
        ],
      ),
    );
  }

  /// Legend on the RIGHT as a vertical list for tidy alignment
  Widget _buildLegend(List<_PieSlice> slices, double sum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...slices.map((s) {
          final pct = sum <= 0 ? 0 : (s.value * 100 / sum);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: s.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                // name
                Expanded(
                  child: Text(
                    s.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // amount
                Text(
                  "₹${s.value.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 8, color: Colors.black54),
                ),
                const SizedBox(width: 6),
                Text(
                  "(${pct.toStringAsFixed(0)}%)",
                  style: const TextStyle(fontSize: 8, color: Colors.black45),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStat(String label, double value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            )),
        const SizedBox(height: 4),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 12,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            color: isHighlight ? Colors.green[800] : Colors.black87,
          ),
        ),
      ],
    );
  }
}

/// ---------- Pie chart internals (no dependency) ----------
class _PieSlice {
  final String label;
  final double value;
  final Color color;

  _PieSlice({required this.label, required this.value, required this.color});
}

class _PiePainter extends CustomPainter {
  final List<_PieSlice> slices;
  final double shrink; // 1.0 = full radius, <1.0 = smaller

  _PiePainter({
    required this.slices,
    this.shrink = 0.75, // tweak 0.60–0.90 to taste
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<double>(0, (a, b) => a + b.value);
    if (total <= 0) return;

    // keep your slight top-left offset, but shrink the radius
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) / 2;
    final radius = baseRadius * shrink;

    final rect = Rect.fromCircle(center: center, radius: radius);
    var startAngle = -math.pi / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    for (final s in slices) {
      final sweep = (s.value / total) * 2 * math.pi;
      paint.color = s.color.withOpacity(0.95);
      canvas.drawArc(rect, startAngle, sweep, true, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter old) {
    if (old.slices.length != slices.length) return true;
    if (old.shrink != shrink) return true;
    for (int i = 0; i < slices.length; i++) {
      if (old.slices[i].value != slices[i].value ||
          old.slices[i].color != slices[i].color ||
          old.slices[i].label != slices[i].label) {
        return true;
      }
    }
    return false;
  }
}
