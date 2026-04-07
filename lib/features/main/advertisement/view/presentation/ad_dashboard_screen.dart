import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/generated/l10n.dart';

/// Shows analytics for a single ad (when [adId] is provided) or an
/// overview of all the owner's ads (when [adId] is null).
class AdDashboardScreen extends StatefulWidget {
  /// null → show all-ads summary (the top banner in MyAdsScreen)
  /// non-null → show this specific ad's stats
  final String? adId;
  final String adTitle;

  const AdDashboardScreen({
    super.key,
    this.adId,
    this.adTitle = 'All Advertisements',
  });

  @override
  State<AdDashboardScreen> createState() => _AdDashboardScreenState();
}

class _AdDashboardScreenState extends State<AdDashboardScreen> {
  AdDashboardModel? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // When adId is null the backend /dashboard endpoint is called with an
      // empty adId query — it returns aggregate stats for all the user's ads.
      final data = await getIt<AdsRepositoryImpl>()
          .getDashboard(adId: widget.adId ?? '');
      if (mounted) {
        setState(() {
          _data = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              strings.adDashboard,
              style: TextStyle(
                color: theme.onSurface,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.adTitle,
              style: TextStyle(color: Colors.grey[500], fontSize: 12.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.onSurface),
            onPressed: _load,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64.sp, color: Colors.red[300]),
                      SizedBox(height: 12.h),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[400]),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton.icon(
                        onPressed: _load,
                        icon: const Icon(Icons.refresh),
                        label: Text(strings.retry),
                      ),
                    ],
                  ),
                )
              : _buildDashboard(theme, strings),
    );
  }

  Widget _buildDashboard(ColorScheme theme, S strings) {
    final d = _data!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.adId == null
                ? strings.overviewAllAds
                : strings.performanceOverview,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: theme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),

          // ── Stat grid ─────────────────────────────────────────────────────
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.6,
            children: [
              _StatCard(
                icon: Icons.campaign_outlined,
                label: strings.totalAds,
                value: d.totalAds.toString(),
                color: Colors.blue,
              ),
              _StatCard(
                icon: Icons.visibility_outlined,
                label: strings.totalViews,
                value: d.totalViews.toString(),
                color: Colors.green,
              ),
              _StatCard(
                icon: Icons.touch_app_outlined,
                label: strings.totalClicks,
                value: d.totalClicks.toString(),
                color: Colors.orange,
              ),
              _StatCard(
                icon: Icons.timer_outlined,
                label: strings.engagement,
                value: '${d.totalEngagementSeconds}s',
                color: Colors.purple,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── Completion rate ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bar_chart_outlined,
                        color: Colors.teal, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      strings.averageCompletionRate,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: LinearProgressIndicator(
                    value: (d.averageCompletionRate / 100).clamp(0.0, 1.0),
                    minHeight: 10.h,
                    backgroundColor: Colors.grey[200],
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  strings.percentage(d.averageCompletionRate.toStringAsFixed(1)),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 16.sp),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.onSurface,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}