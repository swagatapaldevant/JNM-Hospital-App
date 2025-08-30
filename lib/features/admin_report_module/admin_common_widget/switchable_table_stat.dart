import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/features/admin_report_module/admin_common_widget/dynamic_row_col_table.dart';
import 'package:jnm_hospital_app/features/admin_report_module/dashboard_module/widgets/dashboard_tabular_data.dart';

class TableStatsSwitcher<T> extends StatefulWidget {

  final List<String> rows;
  final List<String> cols;
  final List<List<T>> data;
  final String headingText;
  final Widget graphWidget;

  const TableStatsSwitcher({
    super.key,
    required this.rows,
    required this.cols,
    required this.headingText,
    required this.graphWidget,
    required this.data
  });

  @override
  State<TableStatsSwitcher> createState() => _TableStatsSwitcherState();
}

class _TableStatsSwitcherState extends State<TableStatsSwitcher> {
  bool showGraph = true; 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Table"),
            Switch(
              value: showGraph,
              onChanged: (val) {
                setState(() {
                  showGraph = val;
                });
              },
            ),
            const Text("Graph"),
          ],
        ),

        const SizedBox(height: 8),

        if (showGraph)
          widget.graphWidget
        else
          DynamicRowColTable(
            rows: widget.rows,
            columns: widget.cols,
            data: widget.data,
            headingText: widget.headingText,
          ),
      ],
    );
  }
}

