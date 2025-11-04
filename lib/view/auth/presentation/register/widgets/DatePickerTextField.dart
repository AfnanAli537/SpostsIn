import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool showError; // ✅ Controls red border

  const DatePickerTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.showError = false,
  });

  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    
    // Add listener to validate on text change
    widget.controller.addListener(_validateField);
  }

  @override
  void didUpdateWidget(DatePickerTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-validate when showError changes
    if (widget.showError != oldWidget.showError) {
      _validateField();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_validateField);
    super.dispose();
  }

  void _validateField() {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(widget.controller.text);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    
    // ✅ Get current theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? ColorScheme.dark(
                    primary: ColorManager.darkPrimary, // Selected date background
                    onPrimary: ColorManager.darkBackground, // Selected date text
                    surface: ColorManager.darkSurface, // Calendar background
                    onSurface: ColorManager.darkTextPrimary, // Calendar text
                  )
                : ColorScheme.light(
                    primary: ColorManager.darkAccent1, // Selected date background
                    onPrimary: ColorManager.lightBackground, // Selected date text
                    surface: ColorManager.lightSurface, // Calendar background
                    onSurface: ColorManager.lightTextPrimary, // Calendar text
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      widget.controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.showError && _errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color:(_focusNode.hasFocus
                          ? ColorManager.darkAccent1
                          : Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14.h,
                  horizontal: 16.w,
                ),
                
                // ✅ Normal border
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: hasError ? ColorManager.error : ColorManager.darkAccent1,
                    width: hasError ? 1.5.w : 1.2.w,
                  ),
                ),
                
                // ✅ Focused border
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: ColorManager.darkAccent,
                    width: 1.8.w,
                  ),
                ),
                
                suffixIcon: Icon(
                  Icons.calendar_today,
                ),
              ),
            ),
          ),
        ),
        
        // ✅ Error text below field
        if (hasError && _errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: Text(
              _errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: ColorManager.error,
              ),
            ),
          ),
      ],
    );
  }
}