import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view/widgets/section_header.dart';
import 'package:sports_in/generated/l10n.dart';

class AdsSection extends StatelessWidget {
  final List<ProfileAd> ads;

  /// Called when "Show All" is tapped → navigate to MyAdsScreen
  final VoidCallback? onShowAll;

  /// Called when a single ad card is tapped
  final Function(ProfileAd)? onAdTap;

  /// Whether to show the "Show All" button (only for profile owner)
  final bool isOwner;

  final ThemeData theme;
  final S string;

  const AdsSection({
    super.key,
    required this.ads,
    this.onShowAll,
    this.onAdTap,
    required this.isOwner,
    required this.theme,
    required this.string,
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (url == 'string') return false;
    if (url.length < 5) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: string.advertisements,
          onShowAllPressed: onShowAll,
        ),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: ads.length > 3 ? 3 : ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              final hasValidImage = _isValidImageUrl(ad.mediaUrl);

              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: () => onAdTap?.call(ad),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onError.withOpacity(0.1),
                      ),
                      child: hasValidImage
                          ? Image.network(
                              ad.mediaUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(
                                  Icons.campaign_outlined,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.campaign_outlined,
                                color: theme.colorScheme.primary,
                                size: 40.sp,
                              ),
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}