import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/advertisement/view_model/likes_bloc/likes_bloc.dart';
import 'package:sports_in/features/main/home/view/widgets/like_shimmer.dart';
import 'package:sports_in/generated/l10n.dart';

class AdLikesSheet extends StatefulWidget {
  final String adId;
  const AdLikesSheet({super.key, required this.adId});

  @override
  State<AdLikesSheet> createState() => _AdLikesSheetState();
}

class _AdLikesSheetState extends State<AdLikesSheet> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  late AdLikesBloc _bloc;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _bloc = context.read<AdLikesBloc>();
      _bloc.add(FetchAdLikes(adId: widget.adId, page: 1, isRefresh: true));
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
      if (state is AdLikesLoaded && state.hasMore && state is! AdLikesLoadingMore) {
        _currentPage++;
        _bloc.add(FetchAdLikes(adId: widget.adId, page: _currentPage));
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
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
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
              Text(
                strings.likes,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<AdLikesBloc, AdLikesState>(
                  builder: (context, state) {
                    if (state is AdLikesLoading) return buildShimmerLoading();

                    if (state is AdLikesLoaded ||
                        state is AdLikesLoadingMore) {
                      final likes = state is AdLikesLoaded
                          ? state.likes
                          : (state as AdLikesLoadingMore).currentLikes;

                      if (likes.isEmpty) {
                        return Center(
                          child: Text(strings.noLikesYet,
                              style: TextStyle(color: theme.onSurface)),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: likes.length +
                            (state is AdLikesLoaded && state.hasMore ? 1 : 0),
                        itemBuilder: (_, index) {
                          if (index == likes.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                  child: CircularProgressIndicator()),
                            );
                          }
                          final user = likes[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1),
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
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.userProfile,
                                arguments: user.userId,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage:
                                        user.profilePhoto != null
                                            ? NetworkImage(user.profilePhoto!)
                                            : null,
                                    backgroundColor: Colors.grey[300],
                                    child: user.profilePhoto == null
                                        ? Text(
                                            user.fullName.isNotEmpty
                                                ? user.fullName[0]
                                                    .toUpperCase()
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
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: theme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formatTimeAgo(
                                            context,
                                            DateTime.parse(user.createdAt)
                                                .toUtc(),
                                          ),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600]),
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

                    if (state is AdLikesError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message,
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _bloc.add(FetchAdLikes(
                                adId: widget.adId,
                                page: 1,
                                isRefresh: true,
                              )),
                              child: Text(strings.retry,
                                  style:
                                      TextStyle(color: theme.surface)),
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
}