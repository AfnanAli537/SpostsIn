import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/advertisement/view/presentation/ad_dashboard_screen.dart';
import 'package:sports_in/features/main/advertisement/view/widgets/ad_widget.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/profile/view/widgets/text_switch.dart';
import 'package:sports_in/generated/l10n.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class MyAdsScreen extends StatelessWidget {
  final String? userId;
  final bool isOwner;

  const MyAdsScreen({
    super.key,
    this.userId,
    this.isOwner = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdsBloc(adsRepo: getIt<AdsRepositoryImpl>())
        ..add(FetchUserAds(userId: userId, isActive: true)),
      child: _MyAdsView(userId: userId, isOwner: isOwner),
    );
  }
}

// ── Inner view ────────────────────────────────────────────────────────────────

class _MyAdsView extends StatefulWidget {
  final String? userId;
  final bool isOwner;

  const _MyAdsView({required this.userId, required this.isOwner});

  @override
  State<_MyAdsView> createState() => _MyAdsViewState();
}

class _MyAdsViewState extends State<_MyAdsView> {
  bool _onlyInactive = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {}

  void _refresh() {
    context.read<AdsBloc>().add(
          FetchUserAds(userId: widget.userId, isActive: !_onlyInactive),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return BlocListener<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is AdDeleted) {
          Fluttertoast.showToast(
            msg: strings.adDeletedSuccessfully,
            backgroundColor: ColorManager.success,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          _refresh();
        } else if (state is AdStatusToggled) {
          Fluttertoast.showToast(
            msg: _onlyInactive ? strings.adActivated : strings.adDeactivated,
            backgroundColor: ColorManager.success,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          _refresh();
        } else if (state is AdUpdated) {
          _refresh();
        } else if (state is AdsError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: ColorManager.error,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            children: [
              Text(
                strings.myAdvertisements,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _onlyInactive ? strings.inactiveDraft : strings.active,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onError),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            if (widget.isOwner)
              Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: IconSwitch(
                  value: _onlyInactive,
                  onChanged: (value) {
                    setState(() => _onlyInactive = value);
                    context.read<AdsBloc>().add(
                          FetchUserAds(
                              userId: widget.userId, isActive: !value),
                        );
                  },
                  activeIcon: Icons.visibility_sharp,
                  inactiveIcon: Icons.visibility_off_sharp,
                  activeColor: theme.colorScheme.primary,
                  inactiveColor: Colors.grey[300]!,
                  width: 70.w,
                  height: 28.h,
                ),
              ),
          ],
        ),
        body: BlocBuilder<AdsBloc, AdsState>(
          builder: (context, state) {
            if (state is AdsLoading) {
              return ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: 3,
                itemBuilder: (_, __) => const PostShimmer(),
              );
            }

            if (state is AdsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64.sp, color: theme.colorScheme.error),
                    SizedBox(height: 16.h),
                    Text(state.message,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: Text(strings.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is UserAdsLoaded) {
              final ads = state.ads;

              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // ── Summary dashboard banner (owner only) ───────────────
                    if (widget.isOwner)
                      SliverToBoxAdapter(
                        child: _OwnerDashboardBanner(userId: widget.userId),
                      ),

                    // ── Empty state ─────────────────────────────────────────
                    if (ads.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.campaign_outlined,
                                  size: 64.sp,
                                  color: theme.colorScheme.primary),
                              SizedBox(height: 16.h),
                              Text(
                                _onlyInactive
                                    ? strings.noInactiveAds
                                    : strings.noActiveAds,
                                style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onError),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // ── Ad list ─────────────────────────────────────────
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, index) => AdWidget(
                            key: ValueKey(ads[index].id),
                            ad: ads[index],
                            isCurrentUser: widget.isOwner,
                            onDeleted: _refresh,
                          ),
                          childCount: ads.length,
                        ),
                      ),

                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ── Summary dashboard banner ──────────────────────────────────────────────────

class _OwnerDashboardBanner extends StatefulWidget {
  final String? userId;

  const _OwnerDashboardBanner({this.userId});

  @override
  State<_OwnerDashboardBanner> createState() => _OwnerDashboardBannerState();
}

class _OwnerDashboardBannerState extends State<_OwnerDashboardBanner> {
  AdDashboardModel? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data =
          await getIt<AdsRepositoryImpl>().getDashboard(adId: '');
      if (mounted) setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AdDashboardScreen(
            // null adId → all-ads overview
            adId: null,
            adTitle: 'All Advertisements',
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primary.withOpacity(0.85),
              theme.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _isLoading
            ? SizedBox(
                height: 60.h,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : _data == null
                ? Row(
                    children: [
                      const Icon(Icons.analytics_outlined,
                          color: Colors.white),
                      SizedBox(width: 10.w),
                      Text(
                        strings.viewAnalyticsDashboard,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: Colors.white),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row
                      Row(
                        children: [
                          const Icon(Icons.analytics_outlined,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6.w),
                          Text(
                            strings.analyticsOverview,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right,
                              color: Colors.white70, size: 18),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Stat row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _BannerStat(
                            label: strings.ads,
                            value: _data!.totalAds.toString(),
                          ),
                          _divider(),
                          _BannerStat(
                            label: strings.views,
                            value: _data!.totalViews.toString(),
                          ),
                          _divider(),
                          _BannerStat(
                            label: strings.clicks,
                            value: _data!.totalClicks.toString(),
                          ),
                          _divider(),
                          _BannerStat(
                            label: strings.completion,
                            value:
                                '${_data!.averageCompletionRate.toStringAsFixed(0)}%',
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 32.h,
        color: Colors.white.withOpacity(0.3),
      );
}

class _BannerStat extends StatelessWidget {
  final String label;
  final String value;

  const _BannerStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
      ],
    );
  }
}