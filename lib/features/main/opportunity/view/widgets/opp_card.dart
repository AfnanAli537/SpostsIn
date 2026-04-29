import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/details.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/main/profile/data/interface/i_profile_data_source.dart';
import 'package:sports_in/generated/l10n.dart';

class LatestOpportunityCard extends StatefulWidget {
  const LatestOpportunityCard({super.key});

  @override
  State<LatestOpportunityCard> createState() => _LatestOpportunityCardState();
}

class _LatestOpportunityCardState extends State<LatestOpportunityCard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final currentState = context.read<OpportunityBloc>().state;
      if (currentState is! OpportunityLoaded) {
        context
            .read<OpportunityBloc>()
            .add(const FetchOpportunities(isRefresh: true));
      }
    });
  }

  void _openDetails(OpportunityModel opportunity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (BuildContext context) =>
              OpportunityBloc(opportunityRepo: getIt<OpportunityReposatory>(), profileRepo: getIt<IProfileDataSource>(),),
          child: OpportunityDetailsPage(opportunityId: opportunity.id,  isOwner: opportunity.isOwner),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return BlocBuilder<OpportunityBloc, OpportunityState>(
      builder: (context, state) {
        if (state is OpportunityLoading || state is OpportunityInitial) {
          return _buildShimmerLoading();
        }

       if (state is OpportunityError) {
  return Padding(
    padding: EdgeInsets.all(16.w),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            state.message,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          ElevatedButton.icon(
            onPressed: () => context
                .read<OpportunityBloc>()
                .add(const FetchOpportunities(isRefresh: true)),
            icon: const Icon(Icons.refresh),
            label: Text(
              strings.retry, 
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

        if (state is OpportunityLoaded) {
          if (state.opportunities.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  strings.noOpportunitiesAvailable,
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                ),
              ),
            );
          }

          final OpportunityModel latest = state.opportunities.first;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.2),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: latest.mediaUrl != null &&
                            latest.mediaUrl!.isNotEmpty
                        ? Image.network(
                            latest.mediaUrl!,
                            width: 100.w,
                            height: 120.h,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 100.w,
                            height: 120.h,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).colorScheme.primary,
                              borderRadius:
                                  BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.event_available_outlined,
                                size: 50.sp,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          latest.title,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color:Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          latest.publisherName,
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _openDetails(latest),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .surface,
                            ),
                            child: Text(
                              strings.details,
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 120.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
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

