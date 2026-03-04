import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';
import 'package:sports_in/generated/l10n.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ManagePostsScreen extends StatefulWidget {
  const ManagePostsScreen({super.key});

  @override
  State<ManagePostsScreen> createState() => _ManagePostsScreenState();
}

class _ManagePostsScreenState extends State<ManagePostsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _page = 1;
  final int _pageSize = 10;
  List<PostModel> _activePosts = [];
  List<PostModel> _inactivePosts = [];
  bool _isLoadingActive = false;
  bool _isLoadingInactive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadPosts();
      }
    });
    _loadPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    final userId = await getIt<SharedPref>().getUserId();
    if (userId == null) return;

    if (_tabController.index == 0) {
      // Load active posts (isActive = true)
      setState(() => _isLoadingActive = true);
      context.read<PostsBloc>().add(
            FetchAllPosts(
              targetUserId: userId,
              onlyInactive: false,
              page: _page,
              size: _pageSize,
            ),
          );
    } else {
      // Load inactive posts (isActive = false)
      setState(() => _isLoadingInactive = true);
      context.read<PostsBloc>().add(
            FetchAllPosts(
              targetUserId: userId,
              onlyInactive: true,
              page: _page,
              size: _pageSize,
            ),
          );
    }
  }

  Future<void> _togglePostVisibility(PostModel post) async {
    // Toggle via API endpoint
    context.read<PostsBloc>().add(TogglePostVisibility(postId: post.id));
    
    Fluttertoast.showToast(
      msg: 'Post visibility updated',
      backgroundColor: Colors.green,
    );

    // Refresh current tab after a short delay
    await Future.delayed(const Duration(milliseconds: 500));
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Posts'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Inactive'),
          ],
        ),
      ),
      body: BlocListener<PostsBloc, PostsState>(
        listener: (context, state) {
          if (state is PostsLoaded) {
            setState(() {
              if (_tabController.index == 0) {
                _activePosts = state.posts;
                _isLoadingActive = false;
              } else {
                _inactivePosts = state.posts;
                _isLoadingInactive = false;
              }
            });
          } else if (state is PostsError) {
            setState(() {
              _isLoadingActive = false;
              _isLoadingInactive = false;
            });
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPostsList(_activePosts, _isLoadingActive, true),
            _buildPostsList(_inactivePosts, _isLoadingInactive, false),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList(List<PostModel> posts, bool isLoading, bool isActive) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              isActive ? 'No active posts' : 'No inactive posts',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadPosts(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _buildPostCardWithToggle(post, isActive);
        },
      ),
    );
  }

  Widget _buildPostCardWithToggle(PostModel post, bool isActive) {
    return Stack(
      children: [
        Opacity(
          opacity: isActive ? 1.0 : 0.6,
          child: PostWidget(
            post: post,
            isCurrentUser: true,
            onDeleted: () => _loadPosts(),
          ),
        ),
        Positioned(
          top: 16.h,
          right: 16.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () => _togglePostVisibility(post),
                  child: Icon(
                    isActive ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}