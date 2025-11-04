import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TypeOptionTile extends StatelessWidget {
  final String label;
  final String icon; 
  final bool isSelected;
  final VoidCallback onTap;

  const TypeOptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.darkAccent : ColorManager.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? ColorManager.lightPrimary : ColorManager.grey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 25.w,
              height: 25.h,
              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSecondary, BlendMode.srcIn),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: ColorManager.black,
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ColorManager.lightPrimary : ColorManager.grey,
                  width: 2.w,
                ),
                color: isSelected ? ColorManager.lightPrimary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.circle,
                      size: 12.sp,
                      color: ColorManager.darkAccent,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}