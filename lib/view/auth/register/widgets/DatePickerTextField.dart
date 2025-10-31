import 'package:flutter/material.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

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

  Future<void> _selectDate(BuildContext context, FormFieldState<String> fieldState) async {
    FocusScope.of(context).unfocus();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManager.darkAccent1,
              onPrimary: Colors.white,
              onSurface: ColorManager.darkAccent1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      widget.controller.text = formattedDate;

      // ✅ Tell the FormField that the value has changed
      fieldState.didChange(formattedDate);
      fieldState.validate(); // Optional: force re-validation immediately
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (fieldState) {
        final hasError = fieldState.errorText != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _selectDate(context, fieldState),
              child: AbsorbPointer(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: _focusNode.hasFocus
                          ? ColorManager.darkAccent1
                          : Colors.grey,
                    ),
                    filled: true,
                    fillColor: ColorManager.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.w,
                      horizontal: 16.h,
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
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(top: 4.h, left: 4.w),
                child: Text(
                  fieldState.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: ColorManager.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
