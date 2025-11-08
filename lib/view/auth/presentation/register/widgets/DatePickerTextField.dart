import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sports_in/core/constants/color_manager.dart';
class DatePickerTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const DatePickerTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    
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
                    primary: ColorManager.darkPrimary,
                    onPrimary: ColorManager.darkBackground,
                    surface: ColorManager.darkSurface,
                    onSurface: ColorManager.darkTextPrimary,
                  )
                : ColorScheme.light(
                    primary: ColorManager.darkAccent1,
                    onPrimary: ColorManager.lightBackground,
                    surface: ColorManager.lightSurface,
                    onSurface: ColorManager.lightTextPrimary,
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

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: _focusNode.hasFocus
                  ? ColorManager.darkAccent1
                  : Colors.grey,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.h,
              horizontal: 16.w,
            ),
            errorMaxLines: 3,
            
            // Enabled border
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: ColorManager.darkAccent1,
                width: 1.2.w,
              ),
            ),
            
            // Focused border
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: ColorManager.darkAccent,
                width: 1.8.w,
              ),
            ),
            
            // Error border
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: ColorManager.error,
                width: 1.5.w,
              ),
            ),
            
            // Focused error border
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: ColorManager.error,
                width: 1.8.w,
              ),
            ),
            
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}
