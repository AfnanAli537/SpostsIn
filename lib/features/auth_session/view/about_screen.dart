import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '...'; // Initial placeholder
  final String _lastUpdated = 'May 15, 2024';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  // Accesses the actual version of the app from pubspec.yaml
  Future<void> _loadPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          string.aboutUs,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),

            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    // App Name
                    'SportsIn',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Description
                  Text(
                    'SportsIn is a sports networking platform for athletes, coaches, clubs, and agents. Our mission is to connect sports professionals and facilitate collaboration.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),
            _buildCustomTile(
              label: 'Version',
              value: _version, // Dynamically loaded version
              borderColor: theme.colorScheme.onTertiaryContainer,
              theme: theme.colorScheme,
            ),
            SizedBox(height: 12.h),
            // Info List Tiles
            _buildCustomTile(
              label: 'Last Updated',
              value: _lastUpdated,
              borderColor: theme.colorScheme.onTertiaryContainer,
              onTap: () => _launchUrl(
                'https://drive.google.com/drive/folders/1pmlboJSg2-GHS9qh0DOYxhEfo_mDI1If?usp=drive_link',
              ),
              theme: theme.colorScheme,
            ),
            SizedBox(height: 12.h),
            _buildCustomTile(
              label: 'Privacy Policy',
              trailingIcon: Icons.arrow_forward,
              borderColor: theme.colorScheme.onTertiaryContainer,
              onTap: () => _launchUrl('https://sportsin.com/privacy'),
              theme: theme.colorScheme,
            ),
            SizedBox(height: 12.h),

            _buildCustomTile(
              label: 'Terms of Service',
              trailingIcon: Icons.arrow_forward,
              borderColor: theme.colorScheme.onTertiaryContainer,
              onTap: () => _launchUrl('https://sportsin.com/terms'),
              theme: theme.colorScheme,
            ),

            SizedBox(height: 50.h),

            // Social Header
            Text(
              'Connect with Us',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 30.h),

            // Social Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialIcon(
                  icon: Icons.language, // Using standard icons for placeholders
                  label: 'Twitter',
                  bgColor: theme.colorScheme.primary, // Using primary color for Twitter as seen in the image
                  onTap: () => _launchUrl('https://twitter.com/sportsin'),
                  theme: theme.colorScheme,
                ),
                _buildSocialIcon(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  bgColor: theme.colorScheme.primary,
                  onTap: () => _launchUrl('https://facebook.com/sportsin'),
                  theme: theme.colorScheme,
                ),
                _buildSocialIcon(
                  icon: Icons.camera_alt,
                  label: 'Instagram',
                  bgColor: theme.colorScheme.primary,
                  onTap: () => _launchUrl('https://instagram.com/sportsin'),
                  theme: theme.colorScheme,
                ),
              ],
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  // Custom tile builder for the bordered look
  Widget _buildCustomTile({
    required ColorScheme theme,
    required String label,
    String? value,
    IconData? trailingIcon,
    required Color borderColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: theme.onSurface,
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: theme.onSurface,
                ),
              ),
            if (trailingIcon != null)
              Icon(trailingIcon, size: 20.sp, color: theme.onSurface),
          ],
        ),
      ),
    );
  }

  // Custom builder for circular social icons
  Widget _buildSocialIcon({
    required ColorScheme theme,
    required IconData icon,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 24.r,
            backgroundColor: bgColor,
            child: Icon(icon, color: theme.surface, size: 24.sp),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: theme.onSurface,
          ),
        ),
      ],
    );
  }
}