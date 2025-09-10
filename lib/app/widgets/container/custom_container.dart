import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_icons.dart';

class CustomContainer extends StatelessWidget {
  final AppIcons icon;
  final String text;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomContainer({
    super.key,
    required this.icon,
    required this.text,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = (constraints.maxWidth * 0.2).clamp(130, 150);

        return Container(
          width: containerWidth,
          margin: margin ?? const EdgeInsets.all(8.0),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.textColor.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon.assetPath,
                width: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
