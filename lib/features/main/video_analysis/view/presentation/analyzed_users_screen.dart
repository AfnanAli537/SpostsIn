import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/video_analysis/model/analysis_models.dart';
import 'package:sports_in/features/main/video_analysis/view_model/video_analysis_bloc/analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/target_analyses_screen.dart';
import 'package:sports_in/generated/l10n.dart';

class AnalyzedUsersScreen extends StatefulWidget {
  const AnalyzedUsersScreen({super.key});

  @override
  State<AnalyzedUsersScreen> createState() => _AnalyzedUsersScreenState();
}

class _AnalyzedUsersScreenState extends State<AnalyzedUsersScreen> {
  final _scrollController = ScrollController();

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AnalysisBloc>().add(const LoadMoreAnalyzedUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.analyzedPlayers),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state is AnalyzedUsersLoading) return _buildShimmer(theme);
          if (state is AnalyzedUsersError) {
            return _buildError(context, state.message, strings);
          }
          if (state is AnalyzedUsersLoaded) {
            if (state.users.isEmpty) return _buildEmpty(theme, strings);
            return _buildList(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, AnalyzedUsersLoaded state) {
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      itemCount: state.users.length +
          (state is AnalyzedUsersLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, i) {
        if (i == state.users.length) {
          return Center(
              child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: const CircularProgressIndicator()));
        }
        return _AnalyzedUserTile(
          user: state.users[i],
          onTap: () => _openTargetAnalyses(context, state.users[i]),
        );
      },
    );
  }

  void _openTargetAnalyses(BuildContext context, AnalyzedUserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => getIt<AnalysisBloc>()
            ..add(LoadTargetAnalyses(targetUserId: user.userId)),
          child: TargetAnalysesScreen(
            targetUserId: user.userId,
            targetName: user.fullName,
            targetAvatar: user.profilePictureUrl,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(ThemeData theme) => Skeletonizer(
        enabled: true,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          itemCount: 8,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (_, __) => _FakeUserTile(theme: theme),
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
                  .read<AnalysisBloc>()
                  .add(const LoadAnalyzedUsers()),
              child: Text(strings.retry),
            ),
          ],
        ),
      );

  Widget _buildEmpty(ThemeData theme, S strings) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded,
                size: 64.sp,
                color: theme.colorScheme.onSurface.withOpacity(0.25)),
            SizedBox(height: 16.h),
            Text(strings.noAnalyzedPlayersYet,
                style: TextStyle(
                    fontSize: 15.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.5))),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

class _AnalyzedUserTile extends StatelessWidget {
  final AnalyzedUserModel user;
  final VoidCallback onTap;

  const _AnalyzedUserTile({required this.user, required this.onTap});

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
              backgroundImage: user.profilePictureUrl != null
                  ? NetworkImage(user.profilePictureUrl!)
                  : null,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: user.profilePictureUrl == null
                  ? Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: theme.colorScheme.onPrimaryContainer),
                    )
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(user.fullName,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
            ),
            Icon(Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withOpacity(0.3),
                size: 22.sp),
          ],
        ),
      ),
    );
  }
}

class _FakeUserTile extends StatelessWidget {
  final ThemeData theme;

  const _FakeUserTile({required this.theme});

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
            Container(height: 14.h, width: 140.w, color: Colors.grey),
          ],
        ),
      );
}