import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/main/home/data/model/post_model.dart';
import 'package:sports_in/features/main/home/view/widgets/post.dart';
import 'package:sports_in/features/main/home/view_model/posts_bloc/posts_bloc.dart';

/// Navigate to this screen with:
/// Navigator.pushNamed(context, AppRoutes.postDetail, arguments: postId);
class PostDetailScreen extends StatelessWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PostsBloc>()..add(FetchSinglePost(postId: postId)),
      child: _PostDetailView(postId: postId),
    );
  }
}

class _PostDetailView extends StatelessWidget {
  final String postId;
  const _PostDetailView({required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          // ── Loading ──────────────────────────────────────────────────────
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ── Loaded — find the post we need ───────────────────────────────
          if (state is PostsLoaded) {
            final PostModel? post = state.posts
                .cast<PostModel?>()
                .firstWhere((p) => p?.id == postId, orElse: () => null);

            if (post == null) return _buildNotFound(context);

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: PostWidget(
                post: post,
                isCurrentUser: false, // pass real value if available
              ),
            );
          }

          // ── Single post state (if your bloc supports it) ─────────────────
          if (state is SinglePostLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: PostWidget(
                post: state.post,
                isCurrentUser: false,
              ),
            );
          }

          // ── Error ────────────────────────────────────────────────────────
          if (state is PostsError) {
            return _buildError(context, state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 56.sp, color: Colors.black26),
          SizedBox(height: 12.h),
          const Text('Post not found',
              style: TextStyle(fontSize: 16, color: Colors.black45)),
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
          Text(message,
              style: const TextStyle(color: Colors.black45, fontSize: 13)),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => context
                .read<PostsBloc>()
                .add(FetchSinglePost(postId: postId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}