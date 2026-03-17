import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/core/widgets/custom_avatar.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view/widgets/connections_shimmer.dart';
import 'package:sports_in/features/main/profile/view_model/connection bloc/connections_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/connection bloc/connections_event.dart';
import 'package:sports_in/features/main/profile/view_model/connection bloc/connections_state.dart';
import 'package:sports_in/generated/l10n.dart';

class ConnectionsScreen extends StatelessWidget {
  final bool isOwner;

  /// Pass the other user's ID when isOwner is false.
  /// Null means we're loading the current user's own data.
  final String? userId;

  const ConnectionsScreen({
    super.key,
    required this.isOwner,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConnectionsBloc>()
        ..add(LoadConnections(userId: isOwner ? null : userId)),
      child: _ConnectionsView(isOwner: isOwner),
    );
  }
}

class _ConnectionsView extends StatefulWidget {
  final bool isOwner;
  const _ConnectionsView({required this.isOwner});

  @override
  State<_ConnectionsView> createState() => _ConnectionsViewState();
}

class _ConnectionsViewState extends State<_ConnectionsView> {
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
      context.read<ConnectionsBloc>().add(LoadMoreRequests());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(strings.connections), centerTitle: true),
      body: BlocConsumer<ConnectionsBloc, ConnectionsState>(
        listener: (context, state) {
          if (state is ConnectionsActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        builder: (context, state) {
          // ── Loading ─────────────────────────────────────────────────────
          if (state is ConnectionsLoading) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConnectionsShimmer(isOwner: widget.isOwner),
            );
          }

          // ── Error ───────────────────────────────────────────────────────
          if (state is ConnectionsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48.sp, color: theme.colorScheme.error),
                  SizedBox(height: 12.h),
                  Text(state.message, textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => context
                        .read<ConnectionsBloc>()
                        .add(LoadConnections(
                          userId: widget.isOwner ? null : null,
                        )),
                    child: Text(strings.retry),
                  ),
                ],
              ),
            );
          }

          // ── Loaded ──────────────────────────────────────────────────────
          if (state is ConnectionsLoaded) {
            final bloc = context.read<ConnectionsBloc>();

            return RefreshIndicator(
              onRefresh: () async => bloc.add(LoadConnections(
                userId: widget.isOwner ? null : null,
              )),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // ── Contacts (always shown) ───────────────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: strings.myContacts,
                      count: state.contacts.length,
                    ),
                  ),
                  if (state.contacts.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 32.h),
                        child: Center(
                          child: Text(
                            strings.noContactsYet,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: ColorManager.hintTextColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _ContactCard(
                            contact: state.contacts[index],
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.userProfile,
                              arguments: state.contacts[index].id,
                            ),
                          ),
                          childCount: state.contacts.length,
                        ),
                      ),
                    ),

                  // ── Requests (owner only, paginated) ──────────────────
                  if (widget.isOwner) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Divider(
                          height: 1.h,
                          color: theme.colorScheme.onError.withOpacity(0.6),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 8.h)),

                    if (state.requests.isNotEmpty || state.hasMoreRequests) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: strings.newConnectionRequests,
                          count: state.requests.length,
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final request = state.requests[index];
                              return _RequestCard(
                                request: request,
                                onAccept: () => bloc.add(RespondToRequest(
                                    senderId: request.id, status: 'Accepted')),
                                onReject: () => bloc.add(RespondToRequest(
                                    senderId: request.id, status: 'Rejected')),
                              );
                            },
                            childCount: state.requests.length,
                          ),
                        ),
                      ),
                      if (state.isLoadingMoreRequests)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child:
                                const Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      if (!state.hasMoreRequests &&
                          !state.isLoadingMoreRequests &&
                          state.requests.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child: Text(
                                strings.noMoreRequests,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: ColorManager.hintTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ] else
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 24.h),
                          child: Center(
                            child: Text(
                              strings.noConnectionRequests,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: ColorManager.hintTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],

                  SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          Text(title,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contact Card ───────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final ContactItem contact;
  final VoidCallback onTap;
  const _ContactCard({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CustomAvatar(
                      imageUrl: contact.imageUrl,
                      name: contact.title,
                      radius: 32.r),
                  if (contact.isOnline)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 13.w,
                        height: 13.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: theme.colorScheme.surface, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (contact.isOnline) ...[
                      SizedBox(height: 4.h),
                      Text(
                        strings.online,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: theme.colorScheme.onTertiaryContainer, size: 22.sp),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Request Card ───────────────────────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final ConnectionRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  const _RequestCard(
      {required this.request,
      required this.onAccept,
      required this.onReject});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.userProfile,
          arguments: request.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAvatar(
                  imageUrl: request.profilePictureUrl,
                  name: request.fullName,
                  radius: 32.r),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.fullName,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      strings.wantsToConnect,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: onAccept,
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text(strings.accept,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onReject,
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              foregroundColor: theme.colorScheme.error,
                              side: BorderSide(
                                  color: theme.colorScheme.error
                                      .withOpacity(0.6)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: Text(strings.reject,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
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