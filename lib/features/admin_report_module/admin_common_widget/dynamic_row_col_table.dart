import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class DynamicRowColTable<T> extends StatelessWidget {
  final List<String> rows; // Row labels (e.g. ["New", "Old"])
  final List<String> columns; // Column headers (e.g. ["OPD", "Emergency"])
  final List<List<T>> data; // 2D data matrix
  final String headingText;

  const DynamicRowColTable({
    super.key,
    required this.rows,
    required this.columns,
    required this.data,
    required this.headingText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtils().screenWidth(context),
      color: Colors.white,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(2),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.03),
              child: Text(
                headingText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  color: AppColors.colorBlack,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowMinHeight: 32,
                  dataRowMaxHeight: 40,
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(Colors.white),
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  // 🔹 Columns
                  columns: [
                    const DataColumn(
                      label: Text(
                        "Type",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ...columns.map(
                      (col) => DataColumn(
                        label: Text(
                          col,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        numeric: true,
                      ),
                    ),
                  ],
                  // 🔹 Rows
                  rows: List.generate(rows.length, (rowIndex) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          rows[rowIndex],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        )),
                        ...List.generate(columns.length, (colIndex) {
                          final value = (rowIndex < data.length &&
                                  colIndex < data[rowIndex].length)
                              ? data[rowIndex][colIndex]
                              : 0;
                          return DataCell(Text(
                            "$value",
                            style: const TextStyle(fontSize: 11),
                          ));
                        }),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
