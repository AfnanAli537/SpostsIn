import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/advertisement/model/ad_model.dart';
import 'package:sports_in/features/main/advertisement/view/widgets/ad_widget.dart';
import 'package:sports_in/features/main/advertisement/view_model/ads_bloc/ads_bloc.dart';

/// Navigate to this screen with:
/// Navigator.pushNamed(context, AppRoutes.adDetail, arguments: adId);
class AdDetailScreen extends StatelessWidget {
  final String adId;
  const AdDetailScreen({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdsBloc>()..add(FetchSingleAd(adId: adId)),
      child: _AdDetailView(adId: adId),
    );
  }
}

class _AdDetailView extends StatelessWidget {
  final String adId;
  const _AdDetailView({required this.adId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Advertisement'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AdsBloc, AdsState>(
        builder: (context, state) {
          // ── Loading ──────────────────────────────────────────────────────
          if (state is AdsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ── Loaded (list of ads) – find the one we need ─────────────────
          if (state is AdsLoaded) {
            final AdModel? ad = state.ads
                .cast<AdModel?>()
                .firstWhere((a) => a?.id == adId, orElse: () => null);

            if (ad == null) return _buildNotFound(context);

            return _buildAdContent(context, ad);
          }

          // ── Single ad loaded (preferred, if your bloc supports it) ──────
          if (state is SingleAdLoaded) {
            return _buildAdContent(context, state.ad);
          }

          // ── Error ───────────────────────────────────────────────────────
          if (state is AdsError) {
            return _buildError(context, state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAdContent(BuildContext context, AdModel ad) {
    // Determine if the current user is the owner of this ad.
    // Replace with your actual logic (e.g., from AuthBloc or shared preferences).
    final bool isCurrentUser = _isCurrentUser(ad);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: AdWidget(
        ad: ad,
        isCurrentUser: isCurrentUser,
        onDeleted: () => Navigator.pop(context), // Return to previous screen after deletion
      ),
    );
  }

  bool _isCurrentUser(AdModel ad) {
    final sharedPref = getIt<SharedPref>();
    final String? currentUserId = sharedPref.getUserId();
    return ad.author?.userId == currentUserId;
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 56.sp, color: Colors.black26),
          SizedBox(height: 12.h),
          const Text(
            'Advertisement not found',
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 48.sp, color: Colors.black26),
          SizedBox(height: 12.h),
          Text(
            message,
            style: const TextStyle(color: Colors.black45, fontSize: 13),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context
                .read<AdsBloc>()
                .add(FetchSingleAd(adId: adId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}