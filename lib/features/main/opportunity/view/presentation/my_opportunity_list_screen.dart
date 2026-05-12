// ignore_for_file: unused_field

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

class MyOpportunitiesListScreen extends StatelessWidget {
  final bool showActiveOnly;
  final bool isCurrentUser;
  final String userId;

  const MyOpportunitiesListScreen({
    super.key,
    this.showActiveOnly = true,
    this.isCurrentUser = true,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OpportunityBloc>()
            ..add(isCurrentUser ? FetchMyOpportunities(showActive: showActiveOnly) : FetchOpportunities(isRefresh: true, userId: userId)),
      child: _MyOpportunitiesListView(
        showActiveOnly: showActiveOnly,
        isCurrentUser: isCurrentUser,
        userId: userId,
      ),
    );
  }
}

// ignore: must_be_immutable
class _MyOpportunitiesListView extends StatefulWidget {
  bool showActiveOnly;
  final bool isCurrentUser;
  final String userId;

  _MyOpportunitiesListView({
    required this.showActiveOnly,
    required this.isCurrentUser,
    required this.userId,

  });

  @override
  State<_MyOpportunitiesListView> createState() =>
      _MyOpportunitiesListViewState();
}

class _MyOpportunitiesListViewState extends State<_MyOpportunitiesListView> {
  final ScrollController _scrollController = ScrollController();

  List<OpportunityModel>? _cachedOpportunities;
  bool _hasMore = false;
  
  //For optimistic updates
  OpportunityModel? _deletedOpportunity;
  String? _deletedOpportunityId;
  OpportunityModel? _archivedOpportunity;
  String? _archivedOpportunityId;

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

  Future<void> _refreshOpportunities() async {
    context.read<OpportunityBloc>().add(
          widget.isCurrentUser ?  FetchMyOpportunities(showActive: widget.showActiveOnly, page: 1) : FetchOpportunities(isRefresh: true, userId: widget.userId),
        );
    // Wait a bit for the state to update
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _removeOpportunityFromCache(String opportunityId) {
    if (_cachedOpportunities != null) {
      setState(() {
        _cachedOpportunities!.removeWhere((opp) => opp.id == opportunityId);
      });
    }
  }

  void _addOpportunityBackToCache(OpportunityModel opportunity) {
    if (_cachedOpportunities != null) {
      setState(() {
        _cachedOpportunities!.insert(0, opportunity);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.isCurrentUser
                  ? strings.myOpportunities
                  : strings.opportunities,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            widget.showActiveOnly
                ? Text(
                    strings.publicOpportunities,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onError,
                    ),
                  )
                : Text(
                    strings.archiveOpportunities,
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
          // ✅ Handle delete success
          if (state is OpportunityDeleted) {
            // Removed from cache already (optimistic), just show success
            Fluttertoast.showToast(
              msg: strings.opportunityDeletedSuccess,
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
            _deletedOpportunity = null;
            _deletedOpportunityId = null;
          } 
          // ✅ Handle delete error - undo optimistic removal
          else if (state is OpportunityError) {
            // Check if this is a delete error
            if (_deletedOpportunity != null) {
              _addOpportunityBackToCache(_deletedOpportunity!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              _deletedOpportunity = null;
              _deletedOpportunityId = null;
            } else if (_archivedOpportunity != null) {
              // Archive failed, undo optimistic removal
              _addOpportunityBackToCache(_archivedOpportunity!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              _archivedOpportunity = null;
              _archivedOpportunityId = null;
            } else {
              // Other errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } 
          // ✅ Handle update success
          else if (state is OpportunityUpdated) {
            _refreshOpportunities();
            Fluttertoast.showToast(
              msg: strings.opportunityUpdatedSuccess,
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          } 
          // ✅ Handle toggle success
          else if (state is OpportunityToggeled) {
            _archivedOpportunity = null;
            _archivedOpportunityId = null;
            _refreshOpportunities();
          }
        },
        builder: (context, state) {
          if (state is MyOpportunitiesLoaded) {
            _cachedOpportunities = state.opportunities;
            _hasMore = state.hasMore;
          }

          final bool isLoading = state is MyOpportunitiesLoading ||
              state is OpportunityInitial ||
              state is OpportunityLoadingMore;

          final bool isUpdating = state is OpportunityUpdated;

          if ((isLoading || isUpdating) &&
              _cachedOpportunities != null &&
              _cachedOpportunities!.isNotEmpty) {
            return _buildOpportunityList(
              opportunities: _cachedOpportunities!,
              hasMore: _hasMore,
              isLoadingMore: state is OpportunityLoadingMore,
              theme: theme,
              strings: strings,
            );
          }

          if ((state is MyOpportunitiesLoading || state is OpportunityInitial) &&
              _cachedOpportunities == null) {
            return RefreshIndicator(
              onRefresh: _refreshOpportunities,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                itemCount: 3,
                itemBuilder: (context, index) => const OpportunityCardShimmer(),
              ),
            );
          }

          if (state is OpportunityError) {
            return RefreshIndicator(
              onRefresh: _refreshOpportunities,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 100.h),
                  Center(
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
                          child: Text(strings.retry),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is MyOpportunitiesLoaded) {
            if (state.opportunities.isEmpty &&
                _cachedOpportunities?.isEmpty != false) {
              return RefreshIndicator(
                onRefresh: _refreshOpportunities,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 100.h),
                    Center(
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
                                ? strings.noActiveOpportunities
                                : strings.noInactiveOpportunities,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onError,
                            ),
                          ),
                        ],
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
              strings: strings,
            );
          }

          if (_cachedOpportunities != null && _cachedOpportunities!.isNotEmpty) {
            return _buildOpportunityList(
              opportunities: _cachedOpportunities!,
              hasMore: _hasMore,
              isLoadingMore: false,
              theme: theme,
              strings: strings,
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshOpportunities,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: Text(strings.noData),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOpportunityList({
    required List<OpportunityModel> opportunities,
    required bool hasMore,
    required bool isLoadingMore,
    required ThemeData theme,
    required S strings,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshOpportunities,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
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
            onDelete: () => _handleOptimisticDelete(
              context,
              opportunity,
              strings,
            ),
            onToggle: (bool isArchiving) =>
                _handleOptimisticToggle(context, opportunity, isArchiving, strings),
            showActiveOnly: widget.showActiveOnly,
            strings: strings,
          );
        },
      ),
    );
  }

  void _handleOptimisticDelete(
    BuildContext context,
    OpportunityModel opportunity,
    S strings,
  ) {
    ConfirmationDialog.show(
      context: context,
      title: strings.deleteOpportunity,
      message: strings.deleteOpportunityConfirmation,
      onConfirm: () {
        _deletedOpportunity = opportunity;
        _deletedOpportunityId = opportunity.id;
        
        _removeOpportunityFromCache(opportunity.id);
        
        context.read<OpportunityBloc>().add(
          DeleteOpportunity(opportunityId: opportunity.id),
        );
      },
      confirmText: strings.delete,
      cancelText: strings.cancel,
      icon: Icons.delete_outline,
      isDestructive: true,
    );
  }

  void _handleOptimisticToggle(
    BuildContext context,
    OpportunityModel opportunity,
    bool isArchiving,
    S strings,
  ) {
    final action = isArchiving ? strings.archive : strings.restore;
    final title = isArchiving ? strings.archiveOpportunity : strings.restoreOpportunity;
    
    ConfirmationDialog.show(
      context: context,
      title: title,
      message: strings.archiveRestoreConfirmation(action),
      onConfirm: () {
        _archivedOpportunity = opportunity;
        _archivedOpportunityId = opportunity.id;
        
        _removeOpportunityFromCache(opportunity.id);
        
        context.read<OpportunityBloc>().add(
          ToggleOpportunityVisibility(opportunityId: opportunity.id),
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
  final ValueChanged<bool> onToggle;
  final bool showActiveOnly;
  final S strings;

  const _MyOpportunityCard({
    required this.opportunity,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
    required this.showActiveOnly,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                            strings.sinceDate(_formatDate(opportunity.createdAt)),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
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
                    child: _buildLeadingWidget(),
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
                    onToggle(true);
                  } else if (value == 'restore') {
                    onToggle(false);
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
                          Text(strings.archive),
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
                        Text(strings.edit),
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
                          strings.delete,
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

  Widget _buildLeadingWidget() {
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