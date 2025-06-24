import 'package:flutter/material.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/screen_utils.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.suffixIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.isPassword;
  }

  bool _isValidEmailOrPhone(String input) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    final phoneRegex = RegExp(r"^\d{10}$");
    return emailRegex.hasMatch(input) || phoneRegex.hasMatch(input);
  }

  void _validateInput(String value) {
    if (widget.hintText.toLowerCase().contains("email") || widget.hintText.toLowerCase().contains("mobile")) {
      if (value.isEmpty) {
        setState(() => _errorText = "This field is required.");
      } else if (!_isValidEmailOrPhone(value)) {
        setState(() => _errorText = "Enter a valid email or phone number.");
      } else {
        setState(() => _errorText = null);
      }
    } else {
      setState(() => _errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtils().screenWidth(context) * 0.02),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _isObscure : false,
            keyboardType: (widget.hintText.toLowerCase().contains("email") || widget.hintText.toLowerCase().contains("mobile"))
                ? TextInputType.emailAddress
                : TextInputType.text,
            cursorColor: AppColors.colorPrimaryText,
            cursorWidth: 2,
            onChanged: _validateInput,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.colorBlack,
              fontFamily: "comic_neue",
              fontSize: 14,
            ),
            decoration: InputDecoration(
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.colorPrimaryText,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
                  : (widget.suffixIcon != null
                  ? Icon(widget.suffixIcon, color: AppColors.colorPrimaryText)
                  : null),
              prefixIcon: Icon(widget.prefixIcon, color: AppColors.colorPrimaryText),
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.colorPrimaryText,
                fontFamily: "comic_neue",
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ScreenUtils().screenWidth(context) * 0.02),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.white,
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 12),
            child: Text(
              _errorText!,
              style:  TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: "comic_neue",
                shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: AppColors.white.withOpacity(0.5),
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
