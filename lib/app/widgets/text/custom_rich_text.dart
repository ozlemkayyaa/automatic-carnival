import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomRichText extends StatelessWidget {
  final String value;
  final String unit;

  const CustomRichText({
    super.key,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$value ",
            style: const TextStyle(
              fontSize: 32,
              color: AppColors.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: unit,
            style: TextStyle(
              fontSize: 32,
              color: AppColors.textColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
