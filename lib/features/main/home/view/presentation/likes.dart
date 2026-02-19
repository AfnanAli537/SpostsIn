import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/home/view_model/likes_bloc/likes_bloc.dart';

class LikesSheet extends StatefulWidget {
  final String postId;
  const LikesSheet({super.key, required this.postId});

  @override
  State<LikesSheet> createState() => _LikesSheetState();
}

class _LikesSheetState extends State<LikesSheet> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  late LikesBloc _bloc;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _bloc = context.read<LikesBloc>();
      _bloc.add(FetchLikes(postId: widget.postId, page: 1, isRefresh: true));
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = _bloc.state;
      if (state is LikesLoaded && state.hasMore) {
        if (state is! LikesLoadingMore) {
          _currentPage++;
          _bloc.add(FetchLikes(postId: widget.postId, page: _currentPage));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'Likes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: BlocBuilder<LikesBloc, LikesState>(
                  builder: (context, state) {
                    if (state is LikesLoading) {
                      return _buildShimmerLoading();
                    } else if (state is LikesLoaded ||
                        state is LikesLoadingMore) {
                      final likes = state is LikesLoaded
                          ? state.likes
                          : (state as LikesLoadingMore).currentLikes;

                      if (likes.isEmpty) {
                        return const Center(
                          child: Text(
                            'No likes yet',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount:
                            likes.length +
                            (state is LikesLoaded && state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == likes.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final user = likes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.userProfile,
                                  arguments: user.userId,
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: user.profilePhoto != null
                                        ? NetworkImage(user.profilePhoto!)
                                        : null,
                                    backgroundColor: Colors.grey[300],
                                    child: user.profilePhoto == null
                                        ? Text(
                                            user.fullName.isNotEmpty
                                                ? user.fullName[0].toUpperCase()
                                                : 'U',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.fullName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formatTimeAgo(
                                            DateTime.parse(
                                              user.createdAt,
                                            ).toUtc(),
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is LikesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${state.message}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (mounted) {
                                  _bloc.add(
                                    FetchLikes(
                                      postId: widget.postId,
                                      page: 1,
                                      isRefresh: true,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: Colors.grey[300]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
