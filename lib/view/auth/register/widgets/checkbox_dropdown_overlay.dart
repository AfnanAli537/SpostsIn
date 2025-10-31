import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';

class CheckboxDropdownOverlay extends FormField<List<String>> {
  CheckboxDropdownOverlay({
    super.key,
    required String labelText,
    List<String>? initialValue,
    required List<String> options,
    required ValueChanged<List<String>> onChanged,
    super.validator,
  }) : super(
          initialValue: initialValue ?? [],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (fieldState) {
            final theme = Theme.of(fieldState.context);
            final selectedValues = List<String>.from(fieldState.value ?? []);

            void showOverlay(BuildContext context) {
              final overlay = Overlay.of(context);
              OverlayEntry? entry;

              entry = OverlayEntry(
                builder: (_) => Stack(
                  children: [
                    GestureDetector(
                      onTap: () => entry?.remove(),
                      child: Container(
                        color: ColorManager.black.withOpacity(0.5),
                      ),
                    ),
                    Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Theme.of(context).colorScheme.onPrimary,
                        elevation: 8,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.80.w,
                          constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.6.h,
                          ),
                          padding: EdgeInsets.all(16),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: options.map((opt) {
                                          final isSelected =
                                              selectedValues.contains(opt);
                                          return InkWell(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedValues.remove(opt);
                                                } else {
                                                  selectedValues.add(opt);
                                                }
                                                fieldState.didChange(
                                                    List<String>.from(
                                                        selectedValues));
                                                fieldState.validate(); // ✅
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 6.h),
                                              margin: EdgeInsets.symmetric(vertical: 4.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                color: isSelected
                                                    ? ColorManager.lightAccent
                                                    : null,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      opt,
                                                      style: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        fontWeight: isSelected
                                                            ? FontWeight.w600
                                                            : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  Checkbox(
                                                    value: isSelected,
                                                    activeColor:
                                                        ColorManager.lightPrimary,
                                                    onChanged: (checked) {
                                                      setState(() {
                                                        if (checked == true) {
                                                          if (!selectedValues
                                                              .contains(opt)) {
                                                            selectedValues.add(opt);
                                                          }
                                                        } else {
                                                          selectedValues.remove(opt);
                                                        }
                                                        fieldState.didChange(
                                                            List<String>.from(
                                                                selectedValues));
                                                        fieldState.validate(); // ✅
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CustomElevatedButton(
                                      text: 'Done',
                                      onPressed: () {
                                        fieldState.didChange(
                                            List<String>.from(selectedValues));
                                        fieldState.validate(); // ✅
                                        onChanged(List<String>.from(selectedValues));
                                        entry?.remove();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
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
                    child: (fieldState.value == null ||
                            fieldState.value!.isEmpty)
                        ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Select options',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: ColorManager.grey,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: ColorManager.lightPrimary,
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 4.h,
                                children: fieldState.value!
                                    .map((val) => Chip(
                                          label: Text(
                                            val,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          backgroundColor:
                                              ColorManager.lightPrimary
                                                  .withOpacity(0.9),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          onDeleted: () {
                                            final current =
                                                List<String>.from(fieldState.value!);
                                            current.remove(val);
                                            fieldState.didChange(current);
                                            fieldState.validate(); // ✅
                                            onChanged(current);
                                          },
                                        ))
                                    .toList(),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: ColorManager.lightPrimary,
                                ),
                              ),
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
