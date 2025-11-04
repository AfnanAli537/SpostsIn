import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterTwoFieldsRow extends StatelessWidget {
  final Widget leftField;
  final Widget? rightField;
  
  const RegisterTwoFieldsRow({
    super.key,
    required this.leftField,
    this.rightField,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: leftField),
        SizedBox(width: 10.w),
        Expanded(
          child: rightField ?? const SizedBox.shrink(), 
        ),
      ],
    );
  }
}
