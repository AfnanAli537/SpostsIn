import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownOverlay extends FormField<String> {
  AppDropdownOverlay({
    super.key,
    required String labelText,
    String? value,
    required List<String> options,
    required ValueChanged<String> onChanged,
    super.validator,
  }) : super(
          initialValue: value,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (fieldState) {
            final theme = Theme.of(fieldState.context);

            void showOverlay(BuildContext context) {
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
                                final isSelected = fieldState.value == opt;
                                return InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: () {
                                    fieldState.didChange(opt);
                                    fieldState.validate(); // ✅ re-validate
                                    onChanged(opt);
                                    entry?.remove();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                    margin: EdgeInsets.symmetric(vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? ColorManager.darkAccent
                                          : null,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        opt,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      trailing: Radio<String>(
                                        value: opt,
                                        groupValue: fieldState.value,
                                        activeColor: ColorManager.lightPrimary,
                                        onChanged: (val) {
                                          fieldState.didChange(val);
                                          fieldState.validate(); // ✅ re-validate
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => showOverlay(fieldState.context),
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
                            fieldState.value ?? 'Select',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: fieldState.value == null
                                  ? ColorManager.grey
                                  : ColorManager.black,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down_rounded,
                            color: ColorManager.lightPrimary),
                      ],
                    ),
                  ),
                ),
                if (fieldState.hasError)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, left: 4.w),
                    child: Text(
                      fieldState.errorText!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: ColorManager.error),
                    ),
                  ),
              ],
            );
          },
        );
}
