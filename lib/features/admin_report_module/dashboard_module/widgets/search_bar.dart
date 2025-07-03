import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:jnm_hospital_app/core/utils/constants/app_colors.dart';
import 'package:jnm_hospital_app/core/utils/helper/app_dimensions.dart';

class CommonSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  Function() onTap;

   CommonSearchBar({
    super.key,
    this.hintText = "Search...",
    required this.onChanged,
    this.controller,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    AppDimensions.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: AppDimensions.screenWidth*0.8,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray8.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
               Icon(Icons.search, color: AppColors.gray8),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  cursorColor: AppColors.colorBlack,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.colorBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (controller != null && controller!.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    controller!.clear();
                    onChanged('');
                  },
                  child: const Icon(Icons.clear, color:  AppColors.gray8),
                ),
            ],
          ),
        ),
        Bounceable(
            onTap: onTap,
            child: Icon(Icons.clear, color: AppColors.colorBlack,))
      ],
    );
  }
}
