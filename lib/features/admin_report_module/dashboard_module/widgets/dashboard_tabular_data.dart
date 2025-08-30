import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class PatientTable extends StatelessWidget {
  final List<int> newData;
  final List<int> oldData;
  final List<String> departments;
  final String headingText;

  const PatientTable({
    super.key,
    required this.newData,
    required this.oldData,
    required this.departments,
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
                padding:  EdgeInsets.all(ScreenUtils().screenWidth(context) * 0.03),
                child: Text(
                  headingText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                    color: AppColors.colorBlack,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowMinHeight: 32,
                  dataRowMaxHeight: 40,
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
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
                    ...departments.map(
                      (dept) => DataColumn(
                        label: Text(
                          dept,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        numeric: true,
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          "New",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.green,
                          ),
                        )),
                        ...List.generate(departments.length, (index) {
                          final newPatient =
                              index < newData.length ? newData[index] : 0;
                          return DataCell(Text(
                            "$newPatient",
                            style: const TextStyle(
                                color: Colors.green, fontSize: 11),
                          ));
                        }),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text(
                          "Old",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                            color: Colors.blue,
                          ),
                        )),
                        ...List.generate(departments.length, (index) {
                          final oldPatient =
                              index < oldData.length ? oldData[index] : 0;
                          return DataCell(Text(
                            "$oldPatient",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 11),
                          ));
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
