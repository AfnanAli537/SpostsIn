// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/generated/l10n.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final string = S.of(context);
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
                      Text(
                        string.privacyPolicyTitle,
                        style: textTheme.headlineSmall,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        string.lastUpdated,
                        style: textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      _buildSectionTitle(string.introductionTitle),
                      _buildBodyText(string.informationBody),

                      _buildSectionTitle(string.informationTitle),
                      _buildBodyText(string.informationBody),

                      _buildSectionTitle(string.useInfoTitle),
                      _buildBodyText(string.useInfoBody),

                      _buildSectionTitle(string.sharingInfoTitle),
                      _buildBodyText(string.sharingInfoBody),

                      _buildSectionTitle(string.changesTitle),
                      _buildBodyText(string.changesBody),

                      _buildSectionTitle(string.contactTitle),
                      _buildBodyText(string.contactBody),
                      Row(
                        children: [
                          Checkbox(
                            value: _isAgreed,
                            activeColor: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            onChanged: (value) =>
                                setState(() => _isAgreed = value ?? false),
                          ),
                          Expanded(
                            child: Text(
                              string.agreeLabel,
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
                text: string.continueButton,
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
