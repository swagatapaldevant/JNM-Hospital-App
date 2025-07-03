
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class CustomDatePickerField extends StatefulWidget {
  final String placeholderText;
  final ValueChanged<String> onDateChanged;  // Callback to return the selected date

  const CustomDatePickerField({super.key, required this.onDateChanged, required this.placeholderText});

  @override
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        _dateController.text = formattedDate;

        // Call the callback to return the selected date
        widget.onDateChanged(formattedDate);  // Passing the selected date string back
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtils().screenWidth(context)*0.44,
      padding: EdgeInsets.symmetric(horizontal: ScreenUtils().screenWidth(context) * 0.05),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5FA), // Light background similar to the image
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Soft shadow
            blurRadius: 0,
            spreadRadius: 1,
            offset: Offset(0, 2), // Slight bottom shadow
          ),
        ],
      ),
      child: TextField(
        controller: _dateController,
        readOnly: true,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
            color: AppColors.colorBlack,
            fontSize: ScreenUtils().screenWidth(context)*0.03,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w500
        ),
        decoration: InputDecoration(
          hintText: widget.placeholderText,
          hintStyle: TextStyle(
            color: AppColors.colorPrimaryText,
            fontFamily: "Poppins",
            fontSize:  ScreenUtils().screenWidth(context)*0.035,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none, // Removes default underline
          suffixIcon: GestureDetector(
            onTap: () => _selectDate(context),
            child: Icon(Icons.calendar_today, color: AppColors.colorPrimaryText), // Calendar icon
          ),
        ),
      ),
    );
  }
}
