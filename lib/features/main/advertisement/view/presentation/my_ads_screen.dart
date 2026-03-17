import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/advertisement/data/repo/ads_repository.dart';
import 'package:sports_in/features/main/advertisement/view/widgets/ad_widget.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/profile/view/widgets/text_switch.dart';
import 'package:sports_in/generated/l10n.dart';


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
        ..add(FetchUserAds(
          userId: userId,
          isActive: true,
        )),
      child: _MyAdsView(userId: userId, isOwner: isOwner),
    );
  }
}


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

  void _onScroll() {
    // placeholder for future load-more
  }

  void _refresh() {
    context.read<AdsBloc>().add(
          FetchUserAds(
            userId: widget.userId,
            isActive: !_onlyInactive,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocListener<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is AdDeleted) {
          Fluttertoast.showToast(
            msg: 'Ad deleted successfully',
            backgroundColor: ColorManager.success,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          _refresh();
        } else if (state is AdStatusToggled) {
          Fluttertoast.showToast(
            msg: _onlyInactive ? 'Ad activated' : 'Ad deactivated',
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
                'My Advertisements',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _onlyInactive ? 'Inactive / Draft' : 'Active',
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
                            userId: widget.userId,
                            isActive: !value,
                          ),
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
            // // Create button — owner only
            // if (widget.isOwner)
            //   IconButton(
            //     icon: Icon(Icons.add_circle_outline,
            //         color: theme.colorScheme.primary),
            //     onPressed: () => Navigator.pushNamed(
            //       context,
            //       AppRoutes.createAdScreen,
            //     ).then((_) => _refresh()),
            //   ),
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
                      child: Text(string.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is UserAdsLoaded) {
              final ads = state.ads;

              if (ads.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.campaign_outlined,
                          size: 64.sp, color: theme.colorScheme.primary),
                      SizedBox(height: 16.h),
                      Text(
                        _onlyInactive
                            ? 'No inactive advertisements'
                            : 'No active advertisements',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: theme.colorScheme.onError),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: ads.length,
                  itemBuilder: (_, index) => AdWidget(
                    key: ValueKey(ads[index].id),
                    ad: ads[index],
                    isCurrentUser: widget.isOwner,
                    onDeleted: _refresh,
                  ),
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