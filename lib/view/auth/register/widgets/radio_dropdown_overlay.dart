import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownOverlay extends StatelessWidget {
  final String labelText;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const AppDropdownOverlay({
    super.key,
    required this.labelText,
    this.value,
    required this.options,
    required this.onChanged,
  });

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          GestureDetector(
            onTap: () => entry?.remove(),
            child: Container(color: ColorManager.black.withOpacity(0.5)),
          ),
          Center(
            child: Material(
              elevation: 8,
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8.w,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6.h,
                ),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((opt) {
                      final isSelected = value == opt;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          onChanged(opt);
                          entry?.remove();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            color: isSelected ? ColorManager.darkAccent : null,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListTile(
                            title: Text(
                              opt,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            trailing: Radio<String>(
                              value: opt,
                              groupValue: value,
                              activeColor: ColorManager.lightPrimary,
                              onChanged: (val) {
                                onChanged(val!);
                                entry?.remove();
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showOverlay(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: ColorManager.darkAccent1,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ColorManager.darkAccent1,
              width: 1.2.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: ColorManager.darkAccent,
              width: 1.8.w,
            ),
          ),
          filled: true,
          fillColor: ColorManager.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? 'Select',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: value == null ? ColorManager.grey : ColorManager.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: ColorManager.lightPrimary,
            ),
          ],
        ),
      ),
    );
  }
}