// import 'package:flutter/material.dart';
// import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/dynamic_row_col_table.dart';
// import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/dashboard_tabular_data.dart';
//
// class TableStatsSwitcher<T> extends StatefulWidget {
//
//   final List<String> rows;
//   final List<String> cols;
//   final List<List<T>> data;
//   final String headingText;
//   final Widget graphWidget;
//
//   const TableStatsSwitcher({
//     super.key,
//     required this.rows,
//     required this.cols,
//     required this.headingText,
//     required this.graphWidget,
//     required this.data
//   });
//
//   @override
//   State<TableStatsSwitcher> createState() => _TableStatsSwitcherState();
// }
//
// class _TableStatsSwitcherState extends State<TableStatsSwitcher> {
//   bool showGraph = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             const Text("Table"),
//             Switch(
//               value: showGraph,
//               onChanged: (val) {
//                 setState(() {
//                   showGraph = val;
//                 });
//               },
//             ),
//             const Text("Graph"),
//           ],
//         ),
//
//         const SizedBox(height: 8),
//
//         if (showGraph)
//           widget.graphWidget
//         else
//           DynamicRowColTable(
//             rows: widget.rows,
//             columns: widget.cols,
//             data: widget.data,
//             headingText: widget.headingText,
//           ),
//       ],
//     );
//   }
// }
//

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableStatsSwitcher<T> extends StatefulWidget {
  final List<String> rows; // row labels (e.g., departments)
  final List<String> cols; // metric labels (e.g., Today, MTD, YTD)
  List<List<T>> data; // matrix [row][col]
  final String headingText;
  final Widget graphWidget;
  final String? subTitle; // optional: small helper/caption
  final bool isTransposeData;

  TableStatsSwitcher({
    super.key,
    required this.rows,
    required this.cols,
    required this.headingText,
    required this.graphWidget,
    required this.data,
    this.subTitle,
    required this.isTransposeData,
  });

  @override
  State<TableStatsSwitcher<T>> createState() => _TableStatsSwitcherState<T>();
}

class _TableStatsSwitcherState<T> extends State<TableStatsSwitcher<T>> {
  // 0 = Cards, 1 = Graph
  int _segment = 1;
  void initState() {
    super.initState();
    if (widget.isTransposeData) {
      widget.data = transpose(widget.data);
    }
  }

  List<List<T>> transpose<T>(List<List<T>> input) {
    if (input.isEmpty || input.first.isEmpty) return [];

    int rowCount = input.length;
    int colCount = input.first.length;

    return List.generate(
      colCount,
      (i) => List.generate(rowCount, (j) => input[j][i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _TitleBlock(
                  title: widget.headingText,
                  subTitle: widget.subTitle,
                ),
              ),
              CupertinoSlidingSegmentedControl<int>(
                groupValue: _segment,
                padding: const EdgeInsets.all(2),
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text('Cards'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text('Graph'),
                  ),
                },
                onValueChanged: (v) => setState(() => _segment = v ?? 0),
              ),
            ],
          ),
        ),

        // Content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 240),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _segment == 1
              ? _GraphBlock(widget.graphWidget, key: const ValueKey('graph'))
              : CollapsibleInsightCardsBlock<T>(
                  key: const ValueKey('cards'),
                  headerLabel: 'Insights',
                  rows: widget.rows,
                  cols: widget.cols,
                  data: widget.data,
                  // start collapsed or expanded as you like:
                  initiallyExpanded: false,
                ),
        ),
      ],
    );
  }
}

/// Simple title + optional subtitle
class _TitleBlock extends StatelessWidget {
  final String title;
  final String? subTitle;
  const _TitleBlock({required this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            letterSpacing: 0.1,
          ),
        ),
        if (subTitle != null && subTitle!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              subTitle!,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ),
      ],
    );
  }
}

/// Graph wrapper – respects parent constraints, no scroll here
class _GraphBlock extends StatelessWidget {
  final Widget graph;
  const _GraphBlock(this.graph, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: graph);
  }
}

/// ===================== NEW: Collapsible wrapper =====================
class CollapsibleInsightCardsBlock<T> extends StatefulWidget {
  final String headerLabel;
  final List<String> rows;
  final List<String> cols;
  final List<List<T>> data;
  final bool initiallyExpanded;

  const CollapsibleInsightCardsBlock({
    super.key,
    required this.headerLabel,
    required this.rows,
    required this.cols,
    required this.data,
    this.initiallyExpanded = false,
  });

  @override
  State<CollapsibleInsightCardsBlock<T>> createState() =>
      _CollapsibleInsightCardsBlockState<T>();
}

class _CollapsibleInsightCardsBlockState<T>
    extends State<CollapsibleInsightCardsBlock<T>>
    with SingleTickerProviderStateMixin {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // header bar
    final header = InkWell(
      onTap: _toggle,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.headerLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // small counts (rows × metrics)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${widget.rows.length} × ${widget.cols.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: _expanded ? 0.5 : 0.0, // 0 → down, 0.5 → up
              child: const Icon(Icons.expand_more),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        // content reveal
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _expanded
              ? InsightCardsBlock(
                  rows: widget.rows,
                  cols: widget.cols,
                  data: widget.data,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// =================== END: Collapsible wrapper =======================

/// INSIGHT CARDS (non-scrollable)
///
class InsightCardsBlock<T> extends StatefulWidget {
  final List<String> rows;
  final List<String> cols;
  final List<List<T>> data;
  const InsightCardsBlock({
    super.key,
    required this.rows,
    required this.cols,
    required this.data,
  });
  createState() => _InsightCardsBlockState<T>();
}

class _InsightCardsBlockState<T> extends State<InsightCardsBlock<T>> {
  bool _isNum(dynamic v) => v is num;
   String? selectedRow; // null = all rows

  @override
  Widget build(BuildContext context) {
    final rows = widget.rows;
    final cols = widget.cols;
    final data = widget.data;

    final int rowCount = rows.length;
    final int colCount = cols.length;

    final List<double?> rowMin = List.filled(rowCount, null);
    final List<double?> rowMax = List.filled(rowCount, null);
    final List<double> rowSum = List.filled(rowCount, 0.0);
    final List<int> rowNumCount = List.filled(rowCount, 0);
   

    for (var r = 0; r < rowCount; r++) {
      for (var c = 0; c < colCount; c++) {
        final val = data[r][c];
        if (_isNum(val)) {
          final v = (val as num).toDouble();
          rowMin[r] =
              (rowMin[r] == null) ? v : (v < rowMin[r]! ? v : rowMin[r]!);
          rowMax[r] =
              (rowMax[r] == null) ? v : (v > rowMax[r]! ? v : rowMax[r]!);
          rowSum[r] += v;
          rowNumCount[r] += 1;
        }
      }
    }

    // Summary chips
    final summary = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => selectedRow = null); // Show all
          },
          child: _SummaryChip(
            label: "All",
            value: _formatNumber(rowSum.fold(0, (a, b) => a + b)),
            subtitle: "Grand Total",
            color: selectedRow == null ? Colors.blue : Colors.grey,
          ),
        ),
        ...List.generate(rowCount, (r) {
          final isNumeric = rowNumCount[r] > 0;
          final title = rows[r];
          final value = isNumeric ? _formatNumber(rowSum[r]) : '—';
          final subtitle = isNumeric ? 'Total' : '—';
          return GestureDetector(
            onTap: () {
              setState(() => selectedRow = title);
            },
            child: _SummaryChip(
              label: title,
              value: value,
              subtitle: subtitle,
              color: selectedRow == title ? _metricColor(r) : Colors.grey,
            ),
          );
        }),
      ],
    );

    // Filtered rows
    final filteredIndexes = selectedRow == null
        ? List.generate(rowCount, (i) => i) // all rows
        : [
            rows.indexOf(selectedRow!) // only the selected row
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cols.isNotEmpty) ...[
          summary,
          const SizedBox(height: 12),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            int crossAxisCount = 1;
            if (width >= 1100) {
              crossAxisCount = 4;
            } else if (width >= 900) {
              crossAxisCount = 3;
            } else if (width >= 600) {
              crossAxisCount = 2;
            }

            return Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredIndexes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.18,
                ),
                itemBuilder: (context, idx) {
                  final r = filteredIndexes[idx];
                  return _InsightCard<T>(
                    title: rows[r],
                    cols: cols,
                    values: data[r],
                    colMin: rowMin,
                    colMax: rowMax,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatNumber(double n) {
    if (n.abs() >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n.abs() >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    final s = n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
    return s;
  }

  Color _metricColor(int index) {
    const palette = [
      Color(0xFF8EA6FF), // indigo
      Color(0xFF6FD6FF), // sky
      Color(0xFF8FE388), // green
      Color(0xFFFFC48B), // orange
      Color(0xFFF6A6D7), // pink
      Color(0xFFE5D1FF), // violet
    ];
    return palette[index % palette.length];
  }
}

/// One row’s card with its metrics visualized (your version with internal collapse)

class _InsightCard<T> extends StatelessWidget {
  final String title;
  final List<String> cols;
  final List<T> values;
  final List<double?> colMin;
  final List<double?> colMax;

  // kept for backward compatibility; ignored now
  final bool initialExpanded;
  final int collapsedItemCount;

  const _InsightCard({
    required this.title,
    required this.cols,
    required this.values,
    required this.colMin,
    required this.colMax,
    this.initialExpanded = false, // ignored
    this.collapsedItemCount = 3, // ignored
    super.key,
  });

  bool _isNum(dynamic v) => v is num;

  @override
  Widget build(BuildContext context) {
    final total = cols.length;

    return Card(
      color: Colors.white,
      elevation: 0.7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple, non-interactive header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "100",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Always render all items
            _MetricsList(
              count: total,
              itemBuilder: (context, c) {
                final label = cols[c];
                final val = values[c];
                final isNumeric = _isNum(val);
                final display =
                    isNumeric ? _prettyNum(val as num) : val.toString();

                double? pct;
                if (isNumeric &&
                    colMin[c] != null &&
                    colMax[c] != null &&
                    colMax[c] != colMin[c]) {
                  final v = (val as num).toDouble();
                  pct = ((v - colMin[c]!) / (colMax[c]! - colMin[c]!))
                      .clamp(0.0, 1.0);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _MetricTile(
                    color: _metricColor(c),
                    label: label,
                    value: display,
                    progress: pct,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _prettyNum(num n) {
    if (n.abs() >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n.abs() >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    final isInt = n == n.roundToDouble();
    return n.toStringAsFixed(isInt ? 0 : 1);
  }

  Color _metricColor(int index) {
    const palette = [
      Color(0xFF8EA6FF),
      Color(0xFF6FD6FF),
      Color(0xFF8FE388),
      Color(0xFFFFC48B),
      Color(0xFFF6A6D7),
      Color(0xFFE5D1FF),
    ];
    return palette[index % palette.length];
  }
}

/// fixed-count, non-scroll list so the Card size animates naturally
class _MetricsList extends StatelessWidget {
  final int count;
  final Widget Function(BuildContext, int) itemBuilder;

  const _MetricsList({
    required this.count,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: itemBuilder,
    );
  }
}

/// Metric line with colored chip + optional progress bar
class _MetricTile extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final double? progress;

  const _MetricTile({
    required this.color,
    required this.label,
    required this.value,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final bar = progress == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 6,
                child: LinearProgressIndicator(
                  value: progress!.clamp(0.0, 1.0),
                  backgroundColor: color.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ),
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color.withOpacity(0.18),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.45)),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFeatures: [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              bar,
            ],
          ),
        ),
      ],
    );
  }
}

/// Summary chip at top (per metric)
class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
