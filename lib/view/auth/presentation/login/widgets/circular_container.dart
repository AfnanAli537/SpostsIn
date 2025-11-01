import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sports_in/core/constants/color_manager.dart';

class SocialIconButton extends StatelessWidget {
  final String svgPath; 
  final VoidCallback? onTap;
  final Color borderColor;
  final Color backgroundColor;
  final double size;

  const SocialIconButton({
    super.key,
    required this.svgPath,
    this.onTap,
    this.borderColor = ColorManager.borderCircular, 
    this.backgroundColor = Colors.white,
    this.size = 60, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 1.w,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: (size * 0.6).w,
            height: (size * 0.6).w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
