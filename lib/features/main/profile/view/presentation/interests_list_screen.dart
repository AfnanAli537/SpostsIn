import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile%20bloc/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';

class InterestsListScreen extends StatefulWidget {
  final String userId;
  final bool isOwner;

  const InterestsListScreen({
    super.key,
    required this.userId,
    required this.isOwner,
  });

  @override
  State<InterestsListScreen> createState() => _InterestsListScreenState();
}

class _InterestsListScreenState extends State<InterestsListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ProfileBloc>().add(
          LoadUserProfile(userId: widget.userId),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProfileBloc>().add(LoadMoreInterests(userId: widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.interests),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) return _buildShimmer(theme);
          if (state is ProfileError) {
            return _buildError(context, state.message, strings);
          }
          if (state is ProfileLoaded) {
            final interests = state.profile.interests;
            if (interests.isEmpty) return _buildEmpty(theme, strings);
            return _buildList(context, state, interests);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    ProfileLoaded state,
    List<Interest> interests,
  ) {
    final isLoadingMore = state is ProfileLoadingMoreInterests;
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      itemCount: interests.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, i) {
        if (i == interests.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: const CircularProgressIndicator(),
            ),
          );
        }
        return _InterestTile(
          interest: interests[i],
          onTap: () => _navigateToProfile(context, interests[i].id),
        );
      },
    );
  }

  void _navigateToProfile(BuildContext context, String userId) {
    Navigator.pushNamed(context, AppRoutes.userProfile, arguments: userId);
  }

  Widget _buildShimmer(ThemeData theme) => Skeletonizer(
        enabled: true,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          itemCount: 8,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (_, __) => _FakeInterestTile(theme: theme),
        ),
      );

  Widget _buildError(BuildContext context, String message, S strings) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 52.sp, color: Theme.of(context).colorScheme.error),
            SizedBox(height: 12.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => context
                  .read<ProfileBloc>()
                  .add(LoadUserProfile(userId: widget.userId)),
              child: Text(strings.retry),
            ),
          ],
        ),
      );

  Widget _buildEmpty(ThemeData theme, S strings) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 64.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.25),
            ),
            SizedBox(height: 16.h),
            Text(
              strings.noInterestsYet,
              style: TextStyle(
                fontSize: 15.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _InterestTile extends StatelessWidget {
  final Interest interest;
  final VoidCallback onTap;

  const _InterestTile({required this.interest, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage:
                  NetworkImage(interest.profileImage),
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                      interest.name.isNotEmpty
                          ? interest.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    interest.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  ...[
                    SizedBox(height: 2.h),
                    Text(
                      interest.role,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeInterestTile extends StatelessWidget {
  final ThemeData theme;

  const _FakeInterestTile({required this.theme});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 24.r),
            SizedBox(width: 14.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14.h, width: 140.w, color: Colors.grey),
                SizedBox(height: 4.h),
                Container(height: 11.h, width: 90.w, color: Colors.grey),
              ],
            ),
          ],
        ),
      );
}