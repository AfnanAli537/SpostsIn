import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/update_opportunity_screen.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/details.dart';
import 'package:sports_in/features/main/opportunity/view/widgets/opportunity_card_shimmer.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/main/profile/view/widgets/text_switch.dart';
import 'package:sports_in/generated/l10n.dart';
// import 'package:sports_in/generated/l10n.dart';

class MyOpportunitiesListScreen extends StatelessWidget {
  final bool showActiveOnly;
  final bool isCurrentUser;

  const MyOpportunitiesListScreen({
    super.key,
    this.showActiveOnly = true,
    this.isCurrentUser = true,
    // true = active, false = inactive
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OpportunityBloc>()
            ..add(FetchMyOpportunities(showActive: showActiveOnly)),
      child: _MyOpportunitiesListView(
        showActiveOnly: showActiveOnly,
        isCurrentUser: isCurrentUser,
      ),
    );
  }
}

// ignore: must_be_immutable
class _MyOpportunitiesListView extends StatefulWidget {
  bool showActiveOnly;
  final bool isCurrentUser;

  _MyOpportunitiesListView({
    required this.showActiveOnly,
    required this.isCurrentUser,
  });

  @override
  State<_MyOpportunitiesListView> createState() =>
      _MyOpportunitiesListViewState();
}

class _MyOpportunitiesListViewState extends State<_MyOpportunitiesListView> {
  final ScrollController _scrollController = ScrollController();

  // Cache the last loaded opportunities
  List<OpportunityModel>? _cachedOpportunities;
  bool _hasMore = false;

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
      final state = context.read<OpportunityBloc>().state;
      if (state is MyOpportunitiesLoaded && state.hasMore) {
        if (context.read<OpportunityBloc>().state is! OpportunityLoadingMore) {
          context.read<OpportunityBloc>().add(
            LoadMoreMyOpportunities(showActive: widget.showActiveOnly),
          );
        }
      }
    }
  }

  void _refreshOpportunities() {
    context.read<OpportunityBloc>().add(
      FetchMyOpportunities(showActive: widget.showActiveOnly, page: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.isCurrentUser
                  ? string.myOpportunities
                  : string.opportunities,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            widget.showActiveOnly
                ? Text(
                    string.publicOpportunities,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onError,
                    ),
                  )
                : Text(
                    string.archiveOpportunities,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onError,
                    ),
                  ),
          ],
        ),
        actions: [
          if (widget.isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconSwitch(
                value: widget.showActiveOnly,
                onChanged: (value) {
                  setState(() {
                    widget.showActiveOnly = value;
                  });
                  _refreshOpportunities();
                },
                activeIcon: Icons.visibility_off_sharp,
                inactiveIcon: Icons.visibility_sharp,
                activeColor: theme.colorScheme.primary,
                inactiveColor: Colors.grey[300]!,
                width: 70.w,
                height: 28.h,
              ),
            ),
        ],
      ),
      body: BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
          if (state is OpportunityDeleted) {
            _refreshOpportunities();
            Fluttertoast.showToast(
              msg: 'Opportunity deleted successfully',
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          } else if (state is OpportunityUpdated) {
            // Refresh immediately when an update completes
            _refreshOpportunities();
            Fluttertoast.showToast(
              msg: 'Opportunity updated successfully',
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          } else if (state is OpportunityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Update cache when we have fresh data
          if (state is MyOpportunitiesLoaded) {
            _cachedOpportunities = state.opportunities;
            _hasMore = state.hasMore;
          }

          // Determine if we should show cached data while loading/updating
          final bool isLoading =
              state is MyOpportunitiesLoading ||
              state is OpportunityInitial ||
              state is OpportunityLoadingMore;

          final bool isUpdating = state is OpportunityUpdated;

          // If we have cached data and we're in a transient state, show the cached list
          if ((isLoading || isUpdating) &&
              _cachedOpportunities != null &&
              _cachedOpportunities!.isNotEmpty) {
            return _buildOpportunityList(
              opportunities: _cachedOpportunities!,
              hasMore: _hasMore,
              isLoadingMore: state is OpportunityLoadingMore,
              theme: theme,
              string: string,
            );
          }

          // Show shimmer on initial load with no cache
          if ((state is MyOpportunitiesLoading ||
                  state is OpportunityInitial) &&
              _cachedOpportunities == null) {
            return ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: 3,
              itemBuilder: (context, index) => const OpportunityCardShimmer(),
            );
          }

          // Show error with retry
          if (state is OpportunityError) {
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
                    onPressed: _refreshOpportunities,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show loaded list (normal case)
          if (state is MyOpportunitiesLoaded) {
            if (state.opportunities.isEmpty &&
                _cachedOpportunities?.isEmpty != false) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 64.sp,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      widget.showActiveOnly
                          ? 'No active opportunities'
                          : 'No inactive opportunities',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onError,
                      ),
                    ),
                  ],
                ),
              );
            }
            return _buildOpportunityList(
              opportunities: state.opportunities,
              hasMore: state.hasMore,
              isLoadingMore: false,
              theme: theme,
              string: string,
            );
          }

          // Fallback: show cached list if available, otherwise empty
          if (_cachedOpportunities != null &&
              _cachedOpportunities!.isNotEmpty) {
            return _buildOpportunityList(
              opportunities: _cachedOpportunities!,
              hasMore: _hasMore,
              isLoadingMore: false,
              theme: theme,
              string: string,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOpportunityList({
    required List<OpportunityModel> opportunities,
    required bool hasMore,
    required bool isLoadingMore,
    required ThemeData theme,
    required S string,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        _refreshOpportunities();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.all(16.r),
        itemCount: opportunities.length + (hasMore ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index >= opportunities.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final opportunity = opportunities[index];
          return _MyOpportunityCard(
            opportunity: opportunity,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<OpportunityBloc>(),
                    child: OpportunityDetailsPage(
                      opportunityId: opportunity.id,
                      isOwner: opportunity.isOwner,
                    ),
                  ),
                ),
              );
              if (result == true) _refreshOpportunities();
            },
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<OpportunityBloc>(),
                    child: UpdateOpportunityScreen(
                      opportunityId: opportunity.id,
                    ),
                  ),
                ),
              );
              if (result == true) _refreshOpportunities();
            },
            onDelete: () => _showDeleteConfirmation(
              context,
              opportunity.id,
              opportunity.title,
            ),
            onToggle: (bool isArchiving) =>
                _showToggleConfirmation(context, opportunity.id, isArchiving),
            showActiveOnly: widget.showActiveOnly,
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String opportunityId,
    String title,
  ) {
    ConfirmationDialog.show(
      context: context,
      title: 'Delete Opportunity',
      message:
          'Are you sure you want to delete "$title"? This action cannot be undone.',
      onConfirm: () {
        context.read<OpportunityBloc>().add(
          DeleteOpportunity(opportunityId: opportunityId),
        );
      },
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }

  void _showToggleConfirmation(
    BuildContext context,
    String opportunityId,
    bool isArchiving,
  ) {
    final action = isArchiving ? 'Archive' : 'Restore';
    ConfirmationDialog.show(
      context: context,
      title: '$action Opportunity',
      message: 'Are you sure you want to $action this opportunity?',
      onConfirm: () {
        context.read<OpportunityBloc>().add(
          ToggleOpportunityVisibility(opportunityId: opportunityId),
        );
      },
      confirmText: action,
    );
  }
}

class _MyOpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle; // Now expects a bool
  final bool showActiveOnly;

  const _MyOpportunityCard({
    required this.opportunity,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.showActiveOnly,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context); // Add if needed

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFF2F2F2), width: 1.0),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        opportunity.publisherName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Since ${_formatDate(opportunity.createdAt)}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3147),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _buildLeadingWidget(opportunity),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -10,
              right: -10,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  } else if (value == 'archive') {
                    onToggle(true); // isArchiving = true
                  } else if (value == 'restore') {
                    onToggle(false); // isArchiving = false
                  }
                },
                itemBuilder: (context) => [
                  if (showActiveOnly)
                    PopupMenuItem(
                      value: 'archive',
                      child: Row(
                        children: [
                          Icon(Icons.archive_outlined, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(strings.archive), // Use localized string
                        ],
                      ),
                    )
                  else
                    PopupMenuItem(
                      value: 'restore',
                      child: Row(
                        children: [
                          Icon(Icons.restore_outlined, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(strings.restore),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20.sp),
                        SizedBox(width: 8.w),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 20.sp,
                          color: Colors.red[700],
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadingWidget(OpportunityModel opportunity) {
    if (opportunity.mediaUrl != null && opportunity.mediaUrl!.isNotEmpty) {
      return Image.network(
        opportunity.mediaUrl!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _defaultIcon(),
      );
    }
    return _defaultIcon();
  }

  Widget _defaultIcon() {
    return Center(
      child: Icon(
        Icons.calendar_today_outlined,
        color: Colors.white,
        size: 30.sp,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays >= 1) return '${difference.inDays}d ago';
    if (difference.inHours >= 1) return '${difference.inHours}h ago';
    return '${difference.inMinutes}m ago';
  }
}
