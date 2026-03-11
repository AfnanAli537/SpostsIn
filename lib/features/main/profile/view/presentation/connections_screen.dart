import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'package:sports_in/features/main/profile/view_model/connection%20bloc/connections_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/connection%20bloc/connections_event.dart';
import 'package:sports_in/features/main/profile/view_model/connection%20bloc/connections_state.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConnectionsBloc>()..add(LoadConnections()),
      child: const _ConnectionsView(),
    );
  }
}

class _ConnectionsView extends StatelessWidget {
  const _ConnectionsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        centerTitle: true,
      ),
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
          if (state is ConnectionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

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
                    onPressed: () =>
                        context.read<ConnectionsBloc>().add(LoadConnections()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ConnectionsLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<ConnectionsBloc>().add(LoadConnections()),
              child: CustomScrollView(
                slivers: [
                  // ── Pending Requests Section ──────────────────────────────
                  if (state.requests.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: _SectionHeader(
                        title: 'New Connection Requests',
                        count: state.requests.length,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _RequestTile(
                          request: state.requests[index],
                        ),
                        childCount: state.requests.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Divider(
                            height: 1,
                            color: theme.colorScheme.outlineVariant)),
                    SliverToBoxAdapter(child: SizedBox(height: 8.h)),
                  ],

                  // ── Contacts Section ──────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'My Contacts',
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
                            'No contacts yet',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: ColorManager.hintTextColor),
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _ContactTile(contact: state.contacts[index]),
                        childCount: state.contacts.length,
                      ),
                    ),

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

// ── Section Header ────────────────────────────────────────────────────────────

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
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
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

// ── Request Tile ─────────────────────────────────────────────────────────────

class _RequestTile extends StatelessWidget {
  final ConnectionRequest request;

  const _RequestTile({required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          _Avatar(imageUrl: request.profilePictureUrl, name: request.fullName),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.fullName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Wants to connect with you',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: ColorManager.hintTextColor),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Accept
          _ActionButton(
            label: 'Accept',
            isPrimary: true,
            onPressed: () {
              context.read<ConnectionsBloc>().add(
                    RespondToRequest(
                        senderId: request.id, status: 'Accepted'),
                  );
            },
          ),
          SizedBox(width: 6.w),
          // Reject
          _ActionButton(
            label: 'Reject',
            isPrimary: false,
            onPressed: () {
              context.read<ConnectionsBloc>().add(
                    RespondToRequest(
                        senderId: request.id, status: 'Rejected'),
                  );
            },
          ),
        ],
      ),
    );
  }
}

// ── Contact Tile ─────────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final ContactItem contact;

  const _ContactTile({required this.contact});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.userProfile,
            arguments: contact.id);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Stack(
              children: [
                _Avatar(imageUrl: contact.imageUrl, name: contact.title),
                if (contact.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: ColorManager.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: theme.colorScheme.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                contact.title,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (contact.isOnline)
              Text(
                'Online',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: ColorManager.success),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const _Avatar({this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials =
        name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return CircleAvatar(
      radius: 22.r,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
      backgroundImage:
          (imageUrl != null && imageUrl!.isNotEmpty) ? NetworkImage(imageUrl!) : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Text(initials,
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp))
          : null,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isPrimary) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          minimumSize: Size(60.w, 32.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label, style: TextStyle(fontSize: 12.sp)),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        minimumSize: Size(60.w, 32.h),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error.withOpacity(0.6)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12.sp)),
    );
  }
}