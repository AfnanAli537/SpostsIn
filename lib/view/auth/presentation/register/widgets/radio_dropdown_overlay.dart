// import 'package:flutter/material.dart';
// import 'package:sports_in/core/constants/color_manager.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sports_in/generated/l10n.dart';

// class AppDropdownOverlay extends StatelessWidget {
//   final String labelText;
//   final String? value;
//   final List<String> options;
//   final ValueChanged<String> onChanged;
//   final String? Function(String?)? validator;
//   final bool showError; // ✅ Controls red border
//   final bool enabled; // ✅ Controls if dropdown is clickable

//   const AppDropdownOverlay({
//     super.key,
//     required this.labelText,
//     this.value,
//     required this.options,
//     required this.onChanged,
//     this.validator,
//     this.showError = false,
//     this.enabled = true, // ✅ Default enabled
//   });

//   void _showOverlay(BuildContext context) {
//     if (!enabled) return; // ✅ Don't open if disabled

//     final overlay = Overlay.of(context);
//     OverlayEntry? entry;

//     entry = OverlayEntry(
//       builder: (_) => Stack(
//         children: [
//           GestureDetector(
//             onTap: () => entry?.remove(),
//             child: Container(color: ColorManager.black.withOpacity(0.5)),
//           ),
//           Center(
//             child: Material(
//               elevation: 8,
//               color: Theme.of(context).colorScheme.onPrimary,
//               borderRadius: BorderRadius.circular(16.r),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8.w,
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.6.h,
//                 ),
//                 padding: EdgeInsets.all(16),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: options.map((opt) {
//                       final isSelected = value == opt;
//                       return InkWell(
//                         borderRadius: BorderRadius.circular(12.r),
//                         onTap: () {
//                           onChanged(opt);
//                           entry?.remove();
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 8.w,
//                             vertical: 8.h,
//                           ),
//                           margin: EdgeInsets.symmetric(vertical: 4.h),
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? Theme.of(context).colorScheme.onSurfaceVariant
//                                 : null,
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           child: ListTile(
//                             title: Text(
//                               opt,
//                               style: Theme.of(context).textTheme.bodyMedium
//                                   ?.copyWith(
//                                     fontWeight: isSelected
//                                         ? FontWeight.w600
//                                         : FontWeight.normal,
//                                   ),
//                             ),
//                             trailing: Radio<String>(
//                               value: opt,
//                               groupValue: value,
//                               activeColor: Theme.of(
//                                 context,
//                               ).colorScheme.onTertiaryFixed,
//                               onChanged: (val) {
//                                 onChanged(val!);
//                                 entry?.remove();
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     overlay.insert(entry);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // ✅ Validate if showError is true
//     final errorText = showError && validator != null ? validator!(value) : null;
//     final hasError = errorText != null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Opacity(
//           opacity: enabled ? 1.0 : 0.5, // ✅ Visual feedback when disabled
//           child: GestureDetector(
//             onTap: enabled
//                 ? () => _showOverlay(context)
//                 : null, // ✅ Only tap if enabled
//             child: AbsorbPointer(
//               absorbing: !enabled, // ✅ Prevent interaction when disabled
//               child: InputDecorator(
//                 decoration: InputDecoration(
//                   labelText: labelText,
//                   labelStyle: theme.textTheme.bodyMedium?.copyWith(
//                     color: !enabled
//                         ? Colors.grey.shade400
//                         : (hasError
//                               ? ColorManager.error
//                               : ColorManager.darkAccent1),
//                   ),

//                   // ✅ Normal border
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: !enabled
//                           ? Colors.grey.shade300
//                           : (hasError
//                                 ? ColorManager.error
//                                 : ColorManager.darkAccent1),
//                       width: hasError ? 1.5.w : 1.2.w,
//                     ),
//                   ),

//                   // ✅ Focused border
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: ColorManager.darkAccent,
//                       width: 1.8.w,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         value ?? S.of(context).select,
//                         style: value == null
//                             ? theme.textTheme.bodyMedium?.copyWith(
//                                 color: Theme.of(context).colorScheme.onError,
//                               )
//                             : theme.textTheme.bodyMedium,
//                       ),
//                     ),
//                     Icon(
//                       Icons.arrow_drop_down_rounded,
//                       color: !enabled
//                           ? Colors.grey.shade400
//                           : Theme.of(context).colorScheme.onError,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),

//         // ✅ Error text below dropdown
//         if (hasError)
//           Padding(
//             padding: EdgeInsets.only(top: 4.h, left: 4.w),
//             child: Text(
//               errorText,
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: ColorManager.error,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';

class AppDropdownOverlay extends StatefulWidget {
  final String labelText;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const AppDropdownOverlay({
    super.key,
    required this.labelText,
    this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<AppDropdownOverlay> createState() => _AppDropdownOverlayState();
}

class _AppDropdownOverlayState extends State<AppDropdownOverlay> {
  final GlobalKey<FormFieldState<String>> _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void didUpdateWidget(AppDropdownOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update FormField value when widget value changes
    if (oldWidget.value != widget.value) {
      // Defer the update until after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _fieldKey.currentState?.didChange(widget.value);
          // Validate if the field has been interacted with before
          if (_fieldKey.currentState?.hasError ?? false) {
            _fieldKey.currentState?.validate();
          }
        }
      });
    }
  }

  void _showOverlay(BuildContext context) {
    if (!widget.enabled) return;

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
                    children: widget.options.map((opt) {
                      final isSelected = widget.value == opt;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          widget.onChanged(opt);
                          entry?.remove();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 8.h,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : null,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListTile(
                            title: Text(
                              opt,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                            ),
                            trailing: Radio<String>(
                              value: opt,
                              groupValue: widget.value,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.onTertiaryFixed,
                              onChanged: (val) {
                                widget.onChanged(val!);
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

    return FormField<String>(
      key: _fieldKey,
      initialValue: widget.value,
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: widget.enabled ? 1.0 : 0.5,
              child: GestureDetector(
                onTap: widget.enabled ? () => _showOverlay(context) : null,
                child: AbsorbPointer(
                  absorbing: !widget.enabled,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: !widget.enabled
                            ? Colors.grey.shade400
                            : (field.hasError
                                  ? ColorManager.error
                                  : ColorManager.darkAccent1),
                      ),
                      errorMaxLines: 3,
                      
                      // Enabled border
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: !widget.enabled
                              ? Colors.grey.shade300
                              : ColorManager.darkAccent1,
                          width: 1.2.w,
                        ),
                      ),
                      
                      // Focused border
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: ColorManager.darkAccent,
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.value ?? S.of(context).select,
                            style: widget.value == null
                                ? theme.textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onError,
                                  )
                                : theme.textTheme.bodyMedium,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: !widget.enabled
                              ? Colors.grey.shade400
                              : Theme.of(context).colorScheme.onError,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
