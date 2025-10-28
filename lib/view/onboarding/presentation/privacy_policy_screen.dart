// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 22.sp,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 5.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Privacy & Policy", style: textTheme.headlineSmall),
                      SizedBox(height: 6.h),
                      Text(
                        "Last updated: 11 October 2025",
                        style: textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      _buildSectionTitle("Introduction"),
                      _buildBodyText(
                        "SportsIn is a professional social platform for athletes, coaches, and sports clubs to connect, share experiences, and discover opportunities.",
                      ),

                      _buildSectionTitle("Information We Collect"),
                      _buildBodyText(
                        "When you use SportsIn, we may collect the following types of information:\n\n"
                        "• Personal data: your name, email, profile photo, sports skills, and interests.\n"
                        "• Activity data: posts, messages, likes, and other interactions.\n"
                        "• Device data: device type, operating system, and IP address.",
                      ),

                      _buildSectionTitle("How We Use Your Information"),
                      _buildBodyText(
                        "We use the collected data to:\n\n"
                        "• Personalize your experience within the app.\n"
                        "• Improve our features and services.\n"
                        "• Send you relevant notifications about activities or opportunities.\n"
                        "• Ensure the security and integrity of our platform.",
                      ),

                      _buildSectionTitle("Sharing Your Information"),
                      _buildBodyText(
                        "We do not share your personal data with third parties except in the following cases:\n\n"
                        "• To comply with legal obligations or official requests.\n"
                        "• To provide services through trusted partners (e.g., analytics or notification services).",
                      ),

                      _buildSectionTitle("Changes to This Policy"),
                      _buildBodyText(
                        "We may update this Privacy Policy from time to time. Any significant changes will be communicated through the app.",
                      ),

                      _buildSectionTitle("Contact Us"),
                      _buildBodyText(
                        "If you have any questions or concerns about this Privacy Policy, please contact us at: support@sportsin.app",
                      ),
                          Row(
                children: [
                  Checkbox(
                    value: _isAgreed,
                    activeColor: Theme.of(context).colorScheme.onSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    onChanged: (value) =>
                        setState(() => _isAgreed = value ?? false),
                  ),
                  Expanded(
                    child: Text(
                      "I agree",
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8.h),
          
              CustomElevatedButton(
                text: "CONTINUE",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
                },
                enabled: _isAgreed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: EdgeInsets.only(top: 14.h, bottom: 4.h),
    child: Text(
      title,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
    ),
  );

  Widget _buildBodyText(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 13.5.sp,
      height: 1.4,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
    ),
  );
}
