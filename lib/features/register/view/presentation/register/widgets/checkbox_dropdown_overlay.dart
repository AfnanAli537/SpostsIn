import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';
class CheckboxDropdownOverlay extends StatefulWidget {
  final String labelText;
  final List<String> value;
  final List<String> options;
  final ValueChanged<List<String>> onChanged;
  final String? Function(List<String>?)? validator;
  final Color? borderColor;


  const CheckboxDropdownOverlay({
    super.key,
    required this.labelText,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.borderColor,
  });

  @override
  State<CheckboxDropdownOverlay> createState() =>
      _CheckboxDropdownOverlayState();
}

class _CheckboxDropdownOverlayState extends State<CheckboxDropdownOverlay> {
  final GlobalKey<FormFieldState<List<String>>> _fieldKey = GlobalKey<FormFieldState<List<String>>>();

  @override
  void didUpdateWidget(CheckboxDropdownOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update FormField value when widget value changes
    if (oldWidget.value != widget.value) {
      // Defer the update until after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fieldKey.currentState?.didChange(widget.value);
        }
      });
    }
  }

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    OverlayEntry? entry;
    List<String> selectedValues = List<String>.from(widget.value);

    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          GestureDetector(
            onTap: () => entry?.remove(),
            child: Container(color: ColorManager.black.withOpacity(0.5)),
          ),
          Center(
            child: Material(
              borderRadius: BorderRadius.circular(16.r),
              color: Theme.of(context).colorScheme.onPrimary,
              elevation: 8,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.80.w,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6.h,
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
                              children: widget.options.map((opt) {
                                final isSelected = selectedValues.contains(opt);
                                return InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedValues.remove(opt);
                                      } else {
                                        selectedValues.add(opt);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 6.h,
                                    ),
                                    margin: EdgeInsets.symmetric(vertical: 4.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            opt,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                ),
                                          ),
                                        ),
                                        Checkbox(
                                          value: isSelected,
                                          activeColor: Theme.of(context)
                                              .colorScheme
                                              .onTertiaryFixed,
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
                            text: S.of(context).done,
                            onPressed: () {
                              widget.onChanged(
                                List<String>.from(selectedValues),
                              );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<List<String>>(
      key: _fieldKey,
      initialValue: widget.value,
      validator: widget.validator,
      builder: (FormFieldState<List<String>> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _showOverlay(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: field.hasError
                        ? ColorManager.error
                        : (widget.borderColor ??
                                    ColorManager.darkAccent1),
                  ),
                  errorMaxLines: 3,
                  
                  // Enabled border
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: (widget.borderColor ??
                                    ColorManager.darkAccent1),
                      width: 1.2.w,
                    ),
                  ),
                  
                  // Focused border
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: (widget.borderColor ??
                                    ColorManager.darkAccent1),
                      width: 1.8.w,
                    ),
                  ),
                  
                  // Error border
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: ColorManager.error,
                      width: 1.5.w,
                    ),
                  ),
                  
                  // Focused error border
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: ColorManager.error,
                      width: 1.8.w,
                    ),
                  ),
                  
                  errorText: field.errorText,
                ),
                child: widget.value.isEmpty
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              S.of(context).select,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: ColorManager.grey,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                        ],
                      )
                    : Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        children: widget.value
                            .map(
                              (val) => Chip(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                label: Text(
                                  val,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onInverseSurface,
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                deleteIcon: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                ),
                                onDeleted: () {
                                  final current =
                                      List<String>.from(widget.value);
                                  current.remove(val);
                                  widget.onChanged(current);
                                },
                              ),
                            )
                            .toList(),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}