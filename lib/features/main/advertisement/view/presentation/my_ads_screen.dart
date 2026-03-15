import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
// import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/generated/l10n.dart';

class MyAdsScreen extends StatefulWidget {
  const MyAdsScreen({super.key});

  @override
  State<MyAdsScreen> createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<AdsBloc>().add(const FetchUserAds());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return BlocListener<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is AdDeleted) {
          Fluttertoast.showToast(
            msg: 'Ad deleted',
            backgroundColor: Colors.orange,
            gravity: ToastGravity.TOP,
          );
          context.read<AdsBloc>().add(const FetchUserAds());
        } else if (state is AdStatusToggled) {
          context.read<AdsBloc>().add(const FetchUserAds());
        } else if (state is AdsError) {
          Fluttertoast.showToast(
            msg: state.message,
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'My Advertisements',
            style: TextStyle(
                color: theme.onSurface,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: theme.primary),
              onPressed: () => Navigator.pushNamed(
                  context, AppRoutes.createAdScreen),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: theme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: theme.primary,
            onTap: (index) {
              context.read<AdsBloc>().add(
                    FetchUserAds(isActive: index == 0 ? true : false),
                  );
            },
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Drafts / Inactive'),
            ],
          ),
        ),
        body: BlocBuilder<AdsBloc, AdsState>(
          builder: (context, state) {
            if (state is AdsLoading) {
              return Column(
                children: List.generate(4, (_) => const PostShimmer()),
              );
            }

            if (state is UserAdsLoaded) {
              if (state.ads.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.campaign_outlined,
                          size: 72.sp, color: Colors.grey[400]),
                      SizedBox(height: 16.h),
                      Text('No ads yet',
                          style: GoogleFonts.poppins(
                              fontSize: 18.sp, color: Colors.grey[600])),
                      SizedBox(height: 8.h),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                            context, AppRoutes.createAdScreen),
                        icon: const Icon(Icons.add),
                        label: const Text('Create your first ad'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: theme.surface,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: state.ads.length,
                itemBuilder: (_, index) {
                  final ad = state.ads[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  ad.title,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.onSurface,
                                  ),
                                ),
                              ),
                              // status badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: ad.isActive
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.grey.withOpacity(0.15),
                                  borderRadius:
                                      BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  ad.isPaid
                                      ? (ad.isActive
                                          ? 'Active'
                                          : 'Inactive')
                                      : 'Draft',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ad.isActive
                                        ? Colors.green[700]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            ad.description,
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.h),
                          // date range
                          Row(
                            children: [
                              Icon(Icons.date_range,
                                  size: 14.sp, color: Colors.grey[500]),
                              SizedBox(width: 4.w),
                              Text(
                                '${_formatDate(ad.startDate)} → ${_formatDate(ad.endDate)}',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[500]),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          // stats
                          Row(
                            children: [
                              _statChip(
                                  Icons.visibility_outlined,
                                  '${ad.viewCount}',
                                  'Views'),
                              SizedBox(width: 8.w),
                              _statChip(Icons.touch_app_outlined,
                                  '${ad.clickCount}', 'Clicks'),
                              SizedBox(width: 8.w),
                              _statChip(Icons.favorite_border,
                                  '${ad.likesCount}', 'Likes'),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      Navigator.pushNamed(
                                    context,
                                    AppRoutes.createAdScreen,
                                    arguments: ad,
                                  ),
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: Text(strings.edit),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: theme.primary,
                                    side: BorderSide(color: theme.primary),
                                    visualDensity:
                                        VisualDensity.compact,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      context.read<AdsBloc>().add(
                                            ToggleAdStatus(adId: ad.id),
                                          ),
                                  icon: Icon(
                                    ad.isActive
                                        ? Icons.pause_circle_outline
                                        : Icons.play_circle_outline,
                                    size: 16,
                                  ),
                                  label: Text(
                                      ad.isActive ? 'Pause' : 'Activate'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                    side: const BorderSide(
                                        color: Colors.orange),
                                    visualDensity:
                                        VisualDensity.compact,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              IconButton(
                                onPressed: () =>
                                    context.read<AdsBloc>().add(
                                          DeleteAd(adId: ad.id),
                                        ),
                                icon: Icon(Icons.delete_outline,
                                    color: Colors.red[400]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is AdsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64.sp, color: Colors.red[300]),
                    SizedBox(height: 12.h),
                    Text(state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red[400])),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () => context
                          .read<AdsBloc>()
                          .add(const FetchUserAds()),
                      child: Text(strings.retry),
                    ),
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

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Widget _statChip(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: Colors.grey[500]),
        const SizedBox(width: 3),
        Text('$value $label',
            style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ],
    );
  }
}