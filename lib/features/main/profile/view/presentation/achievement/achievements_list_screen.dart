import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/profile_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/profile_event.dart';
import 'package:sports_in/features/main/profile/view_model/profile_state.dart';
import 'package:sports_in/generated/l10n.dart';
import 'achievement_detail_screen.dart';
import 'achievement_edit_screen.dart';

class AchievementsListScreen extends StatelessWidget {
  final String userId;
  final bool isCurrentUser;

  const AchievementsListScreen({
    super.key,
    required this.userId,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()
        ..add(LoadAchievements(userId: userId, page: 1)),
      child: _AchievementsListView(
        userId: userId,
        isCurrentUser: isCurrentUser,
      ),
    );
  }
}

class _AchievementsListView extends StatefulWidget {
  final String userId;
  final bool isCurrentUser;

  const _AchievementsListView({
    required this.userId,
    required this.isCurrentUser,
  });

  @override
  State<_AchievementsListView> createState() => _AchievementsListViewState();
}

class _AchievementsListViewState extends State<_AchievementsListView> {
  final ScrollController _scrollController = ScrollController();
  final List<Achievement> _achievements = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

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
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() {
      _isLoadingMore = true;
    });
    context.read<ProfileBloc>().add(
          LoadAchievements(
            userId: widget.userId,
            page: _currentPage + 1,
          ),
        );
  }

  void _refreshAchievements() {
    setState(() {
      _achievements.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    context.read<ProfileBloc>().add(
          LoadAchievements(
            userId: widget.userId,
            page: 1,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.achievements),
        actions: widget.isCurrentUser
            ? [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AchievementEditScreen(
                          userId: widget.userId,
                        ),
                      ),
                    );
                    // Refresh list if achievement was created
                    if (result == true) {
                      _refreshAchievements();
                    }
                  },
                ),
              ]
            : null,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is AchievementsLoaded) {
            setState(() {
              if (_currentPage == 1) {
                _achievements.clear();
              }
              _achievements.addAll(state.achievements);
              _hasMore = state.hasMore;
              _currentPage++;
              _isLoadingMore = false;
            });
          } else if (state is AchievementCreated) {
            // Refresh the list when new achievement is created
            _refreshAchievements();
          } else if (state is AchievementDeleted) {
            // Remove deleted achievement from list
            setState(() {
              _achievements.removeWhere((a) => a.id == state.achievementId);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  // strings.achievementDeleted ??
                   'Achievement deleted successfully',
                ),
                backgroundColor: theme.colorScheme.primary,
              ),
            );
          } else if (state is ProfileError) {
            setState(() {
              _isLoadingMore = false;
            });
          }
        },
        builder: (context, state) {
          // Show loading only on initial load
          if (state is ProfileLoading && _achievements.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error only if no achievements loaded yet
          if (state is ProfileError && _achievements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _refreshAchievements,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show empty state
          if (_achievements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 64.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    widget.isCurrentUser
                        ? 'No achievements yet'
                        : 'No achievements',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (widget.isCurrentUser) ...[
                    SizedBox(height: 8.h),
                    Text(
                      'Add your first achievement',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AchievementEditScreen(
                              userId: widget.userId,
                            ),
                          ),
                        );
                        if (result == true) {
                          _refreshAchievements();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        // strings.addAchievement ?? 
                        'Add Achievement'),
                    ),
                  ],
                ],
              ),
            );
          }

          // Show achievements list
          return RefreshIndicator(
            onRefresh: () async {
              _refreshAchievements();
              // Wait a bit for the refresh to complete
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.all(16.r),
              itemCount: _achievements.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                // Show loading indicator at bottom
                if (index >= _achievements.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final achievement = _achievements[index];
                return _AchievementCard(
                  achievement: achievement,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<ProfileBloc>(),
                          child: AchievementDetailScreen(
                            achievement: achievement,
                            isCurrentUser: widget.isCurrentUser,
                            userId: widget.userId,
                          ),
                        ),
                      ),
                    );
                    // Refresh if achievement was deleted or updated
                    if (result == true) {
                      _refreshAchievements();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onTap;

  const _AchievementCard({required this.achievement, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFDCE2D9), width: 1.5), // Match the light green/grey border
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Year Badge
                  Text(
                    achievement.date?.year.toString() ?? "",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Title
                  Text(
                    achievement.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color:theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Subtitle
                  Text(
                    achievement.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Achievement Image (Right Side)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 80.w,
                height: 60.h,
                color: theme.colorScheme.primary, // Matching the yellow/green background in UI
                child: Image.network(
                  achievement.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      Icon(Icons.emoji_events, color: theme.colorScheme.onSecondaryFixed
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}