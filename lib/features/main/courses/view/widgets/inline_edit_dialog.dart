import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class InlineEditDialog {
  /// Edit single text field
  static Future<String?> editTextField({
    required BuildContext context,
    required String title,
    required String currentValue,
    required String hintText,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) async {
    final controller = TextEditingController(text: currentValue);
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            validator: validator,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text('Save', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  /// Edit price field
  static Future<double?> editPriceField({
    required BuildContext context,
    required double currentPrice,
    required bool isFree,
  }) async {
    final controller = TextEditingController(
      text: isFree ? '0' : currentPrice.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();
    bool isCurrentlyFree = isFree;

    return showDialog<double>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Edit Price',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Free checkbox
                CheckboxListTile(
                  title: Text(
                    'Free Course',
                    style: GoogleFonts.poppins(fontSize: 14.sp),
                  ),
                  value: isCurrentlyFree,
                  onChanged: (value) {
                    setState(() {
                      isCurrentlyFree = value ?? false;
                      if (isCurrentlyFree) {
                        controller.text = '0';
                      }
                    });
                  },
                ),
                SizedBox(height: 16.h),

                // Price input
                TextFormField(
                  controller: controller,
                  enabled: !isCurrentlyFree,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  autofocus: !isCurrentlyFree,
                  decoration: InputDecoration(
                    labelText: 'Price (EGP)',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (isCurrentlyFree) return null;
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return 'Invalid price';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final price = isCurrentlyFree 
                      ? 0.0 
                      : double.parse(controller.text.trim());
                  Navigator.pop(context, price);
                }
              },
              child: Text('Save', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }

  /// Confirmation dialog
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red[700] : null,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? ElevatedButton.styleFrom(backgroundColor: Colors.red[700])
                : null,
            child: Text(
              confirmText,
              style: GoogleFonts.poppins(
                color: isDestructive ? Colors.white : null,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}