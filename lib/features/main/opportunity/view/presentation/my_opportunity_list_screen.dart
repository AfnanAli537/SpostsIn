import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/update_opportunity_screen.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/details.dart';
import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class MyOpportunitiesListScreen extends StatelessWidget {
  final bool showActiveOnly;

  const MyOpportunitiesListScreen({
    super.key,
    this.showActiveOnly = true, // true = active, false = inactive
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OpportunityBloc>()
        ..add(FetchMyOpportunities(showActive: showActiveOnly)),
      child: _MyOpportunitiesListView(showActiveOnly: showActiveOnly),
    );
  }
}

class _MyOpportunitiesListView extends StatefulWidget {
  final bool showActiveOnly;

  const _MyOpportunitiesListView({required this.showActiveOnly});

  @override
  State<_MyOpportunitiesListView> createState() =>
      _MyOpportunitiesListViewState();
}

class _MyOpportunitiesListViewState extends State<_MyOpportunitiesListView> {
  final ScrollController _scrollController = ScrollController();
  final List<OpportunityModel> _opportunities = [];
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
    context.read<OpportunityBloc>().add(
          FetchMyOpportunities(
            showActive: widget.showActiveOnly,
            page: _currentPage + 1,
          ),
        );
  }

  void _refreshOpportunities() {
    setState(() {
      _opportunities.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    context.read<OpportunityBloc>().add(
          FetchMyOpportunities(
            showActive: widget.showActiveOnly,
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
        title: Text(widget.showActiveOnly 
            ?  'Active Opportunities'
            : 'Inactive Opportunities'),
      ),
      body: BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
          if (state is MyOpportunitiesLoaded) {
            setState(() {
              if (_currentPage == 1) {
                _opportunities.clear();
              }
              _opportunities.addAll(state.opportunities);
              _hasMore = state.hasMore;
              _currentPage++;
              _isLoadingMore = false;
            });
          } else if (state is OpportunityDeleted) {
            setState(() {
              _opportunities.removeWhere((o) => o.id == state.opportunityId);
            });
            Fluttertoast.showToast(
              msg: 'Opportunity deleted successfully',
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
            );
          } else if (state is OpportunityUpdated) {
            // Refresh the list after update
            _refreshOpportunities();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Opportunity updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is OpportunityError) {
            setState(() {
              _isLoadingMore = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Show loading on initial load
          if (state is OpportunityLoading && _opportunities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error only if no opportunities loaded
          if (state is OpportunityError && _opportunities.isEmpty) {
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

          // Show empty state
          if (_opportunities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 64.sp,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    widget.showActiveOnly
                        ? 'No active opportunities'
                        : 'No inactive opportunities',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show opportunities list
          return RefreshIndicator(
            onRefresh: () async {
              _refreshOpportunities();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.all(16.r),
              itemCount: _opportunities.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (index >= _opportunities.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final opportunity = _opportunities[index];
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
                    if (result == true) {
                      _refreshOpportunities();
                    }
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
                    if (result == true) {
                      _refreshOpportunities();
                    }
                  },
                  onDelete: () => _showDeleteConfirmation(
                    context,
                    opportunity.id,
                    opportunity.title,
                  ),
                );
              },
            ),
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
      message: 'Are you sure you want to delete "$title"? This action cannot be undone.',
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
}
class _MyOpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MyOpportunityCard({
    required this.opportunity,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Set a fixed height or let it expand based on padding
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFFF2F2F2),
            width: 1.0,
          ),
        ),
        child: Stack(
          children: [
            // Main Content Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Text Details
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
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                // Right Side: Dark Navy Box / Logo
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
            
            // Top Right Popup Menu
            Positioned(
              top: -10, // Adjust to align with your preference
              right: -10,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey[400],
                  size: 20.sp,
                ),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                          Icon(Icons.edit_outlined, size: 20.sp),
                          SizedBox(width: 8.w),
                          const Text('Edit')
                        ]),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                          Icon(Icons.delete_outline, size: 20.sp, color: Colors.red[700]),
                          SizedBox(width: 8.w),
                          Text('Delete', style: TextStyle(color: Colors.red[700]))
                        ]),
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