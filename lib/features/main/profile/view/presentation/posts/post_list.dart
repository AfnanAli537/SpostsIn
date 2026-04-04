import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view/widgets/post_shimmer.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/features/main/profile/view/widgets/text_switch.dart';
import 'package:sports_in/generated/l10n.dart';

class ProfilePostsListScreen extends StatefulWidget {
  final String userId;
  final bool isCurrentUser;
  final bool onlyInactive;
  const ProfilePostsListScreen({
    super.key,
    required this.userId,
    this.onlyInactive = false,
    this.isCurrentUser = false,
  });

  @override
  State<ProfilePostsListScreen> createState() => _ProfilePostsListScreenState();
}

class _ProfilePostsListScreenState extends State<ProfilePostsListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PostsBloc>()
        ..add(
          FetchUserPosts(
            userId: widget.userId,
            page: 1,
            onlyInactive: widget.onlyInactive,
          ),
        ),
      child: _ProfilePostsListView(
        userId: widget.userId,
        isCurrentUser: widget.isCurrentUser,
        onlyInactive: widget.onlyInactive,
      ),
    );
  }
}

// ignore: must_be_immutable
class _ProfilePostsListView extends StatefulWidget {
  final String userId;
  final bool isCurrentUser;
  bool onlyInactive;

  _ProfilePostsListView({
    required this.userId,
    required this.isCurrentUser,
    required this.onlyInactive,
  });

  @override
  State<_ProfilePostsListView> createState() => _ProfilePostsListViewState();
}

class _ProfilePostsListViewState extends State<_ProfilePostsListView> {
  final ScrollController _scrollController = ScrollController();
  // ignore: unused_field
  int _currentPage = 1;

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
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<PostsBloc>().state;
      if (state is PostsLoaded && state.hasNextPage) {
        final currentState = context.read<PostsBloc>().state;
        if (currentState is! PostsLoadingMore) {
          context.read<PostsBloc>().add(LoadMorePosts());
        }
      }
    }
  }

  void _refreshPosts() {
    setState(() {
      _currentPage = 1;
    });
    context.read<PostsBloc>().add(
      FetchUserPosts(
        userId: widget.userId,
        page: 1,
        onlyInactive: widget.onlyInactive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Column(
          children: [
            Text(
              widget.isCurrentUser ? string.myPosts : string.posts,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            widget.onlyInactive
                ? Text(
                    string.archivePosts,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onError,
                    ),
                  )
                : Text(
                    string.publicPosts,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onError,
                    ),
                  ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 12.0), // adjust as needed
              child: IconSwitch(
                value: widget.onlyInactive,
                onChanged: (value) {
                  setState(() {
                    widget.onlyInactive = value;
                  });
                  _refreshPosts();
                },
                activeIcon: Icons.visibility_sharp,
                inactiveIcon: Icons.visibility_off_sharp,
                activeColor: theme.colorScheme.primary,
                inactiveColor: Colors.grey[300]!,
                width: 70.w, // you can tweak these numbers
                height: 28.h,
              ),
            ),
        ],
      ),
      body: BlocConsumer<PostsBloc, PostsState>(
        listener: (context, state) {
          if (state is PostDeleteSuccess) {
            Fluttertoast.showToast(
              msg: string.postDeleted,
              backgroundColor: ColorManager.success,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            if (state is PostArchivedSuccess) {
              Fluttertoast.showToast(
                msg: string.postArchived,
                backgroundColor: ColorManager.success,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          } else if (state is PostsError) {
            Fluttertoast.showToast(
              msg: state.message,
              backgroundColor: ColorManager.error,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        builder: (context, state) {
          // Show loading only on initial load
          if (state is PostsLoading) {
            return ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: 3,
              itemBuilder: (context, index) => const PostShimmer(),
            );
          }

          // Show error state
          if (state is PostsError) {
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
                    string.postLoadFailed,
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: _refreshPosts,
                    child: Text(string.retry),
                  ),
                ],
              ),
            );
          }

          // Show posts if loaded
          if (state is! UserPostsLoaded) {
            return const SizedBox.shrink();
          }

          final posts = state.posts;

          // Show empty state
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64.sp,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    widget.isCurrentUser
                        ? widget.onlyInactive
                              ? string.noArchivedPosts
                              : string.noPostsYet
                        : string.noPostsAvailable,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onError,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show posts list
          return RefreshIndicator(
            onRefresh: () async {
              _refreshPosts();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: posts.length + (state.hasNextPage ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at bottom
                if (index >= posts.length) {
                  return Padding(
                    padding: EdgeInsets.all(16.r),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final post = posts[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: PostWidget(
                    post: post,
                    isCurrentUser: widget.isCurrentUser,
                    onDeleted: () {
                      // Delete handled by PostsBloc automatically
                      _refreshPosts();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
