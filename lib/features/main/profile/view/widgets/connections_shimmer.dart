import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer for a single card (request or contact) — mirrors InterestCard layout
class _ConnectionCardShimmer extends StatelessWidget {
  final bool showActions; // true = request card, false = contact card

  const _ConnectionCardShimmer({this.showActions = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar circle
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name line
                    Container(
                      width: double.infinity,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Subtitle line
                    Container(
                      width: 140.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    if (showActions) ...[
                      SizedBox(height: 16.h),
                      // Action buttons row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Container(
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Section header shimmer — matches _SectionHeader layout
class _SectionHeaderShimmer extends StatelessWidget {
  const _SectionHeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 140.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 24.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full shimmer for the connections screen — conditionally shows requests section based on isOwner
class ConnectionsShimmer extends StatelessWidget {
  final bool isOwner;
  
  const ConnectionsShimmer({super.key, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contacts section (always shown)
          const _SectionHeaderShimmer(),
          const _ConnectionCardShimmer(),
          const _ConnectionCardShimmer(),
          const _ConnectionCardShimmer(),

          // Only show requests section if user is the owner
          if (isOwner) ...[
            Divider(
              height: 1.h, 
              indent: 0, 
              endIndent: 0,
              color: Theme.of(context).colorScheme.onError.withOpacity(0.6),
            ),
            SizedBox(height: 8.h),

            // Requests section
            const _SectionHeaderShimmer(),
            const _ConnectionCardShimmer(showActions: true),
            const _ConnectionCardShimmer(showActions: true),
          ],
        ],
      ),
    );
  }
}