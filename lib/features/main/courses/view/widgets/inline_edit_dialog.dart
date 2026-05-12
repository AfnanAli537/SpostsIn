import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/generated/l10n.dart';

class InlineEditDialog {
  static Future<String?> editTextField({
    required BuildContext context,
    required String title,
    required String currentValue,
    required String hintText,
    required S string,
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
              string.cancel,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(string.save, style: GoogleFonts.poppins()),
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
    required S string,
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
            string.editPrice,
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
                    string.freeCourse,
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
                    labelText: string.priceEGPtxt,
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  validator: (value) {
                    if (isCurrentlyFree) return null;
                    if (value == null || value.isEmpty) {
                      return string.priceRequired;
                    }
                    final price = double.tryParse(value);
                    if (price == null || price < 0) {
                      return string.invalidPrice;
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
                string.cancel,
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
              child: Text(string.save, style: GoogleFonts.poppins()),
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
    required S string,
    String? confirmText,
    String? cancelText,
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
              cancelText ?? string.cancel,
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? ElevatedButton.styleFrom(backgroundColor: Colors.red[700])
                : null,
            child: Text(
              confirmText ?? (isDestructive ? string.delete : string.confirm),
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