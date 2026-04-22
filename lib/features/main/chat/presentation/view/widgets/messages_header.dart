import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';

class MessagesHeader extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MessagesHeader({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.messages,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color:Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 46.h,
            decoration: BoxDecoration(
              color:Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: s.searchChats ,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
