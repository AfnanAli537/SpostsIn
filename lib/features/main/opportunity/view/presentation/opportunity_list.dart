import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/utils/helper/time_formate.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/details.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class OpportunitiesContent extends StatefulWidget {
  const OpportunitiesContent({super.key});

  @override
  State<OpportunitiesContent> createState() => OpportunitiesContentState();
}

class OpportunitiesContentState extends State<OpportunitiesContent>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  void reload() {
    context.read<OpportunityBloc>().add(
      const FetchOpportunities(isRefresh: true),
    );
  }

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late AnimationController _shimmerController;

  final Map<String, int> _sportTypes = {
    'football': 1,
    'basketball': 2,
    'volleyball': 3,
    'handball': 4,
    'taekwondo': 5,
  };

  String _getLocalizedSportName(String key, S strings) {
    final Map<String, String> names = {
      'football': strings.football,
      'basketball': strings.basketball,
      'volleyball': strings.volleyball,
      'handball': strings.handball,
      'taekwondo': strings.taekwondo,
    };
    return names[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Initial load
    context.read<OpportunityBloc>().add(
      const FetchOpportunities(isRefresh: true),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _shimmerController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<OpportunityBloc>().add(UpdateSearchTerm(searchTerm: value));
    });
  }

  void _clearFilters() {
    _searchController.clear();
    context.read<OpportunityBloc>().add(const ClearFilters());
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final strings = S.of(context);

    return BlocConsumer<OpportunityBloc, OpportunityState>(
      listener: (context, state) {
        if (state is OpportunityError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        if (state is OpportunityCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.opportunityCreatedSuccessfully),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          context.read<OpportunityBloc>().add(
            const FetchOpportunities(isRefresh: true),
          );
        }
        if (state is OpportunityApplied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.applicationSubmittedSuccessfully),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(strings),
            _buildFilterSection(state, strings),
            SizedBox(height: 16.h),
            if (state is OpportunityLoaded)
              ..._buildOpportunitiesList(state, strings)
            else if (state is OpportunityLoading ||
                state is OpportunityInitial)
              ..._buildShimmerList()
            else if (state is OpportunityError)
              _buildErrorState(state.message, strings)
            else
              const SizedBox.shrink(),
            SizedBox(height: 120.h),
          ],
        );
      },
    );
  }

  // ── Search bar ────────────────────────────────────────────────────────────

  Widget _buildSearchBar(S strings) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: strings.search,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600]),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : Icon(Icons.tune, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ),
    );
  }

  // ── Filter chips ──────────────────────────────────────────────────────────

  Widget _buildFilterSection(OpportunityState state, S strings) {
    String sportChipLabel = strings.sport;
    if (state is OpportunityLoaded && state.sportTypeId != null) {
      final selectedKey = _sportTypes.entries
          .firstWhere(
            (e) => e.value == state.sportTypeId,
            orElse: () => const MapEntry('', 0),
          )
          .key;
      sportChipLabel = selectedKey.isNotEmpty
          ? _getLocalizedSportName(selectedKey, strings)
          : (state.sportName ?? strings.sport);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: sportChipLabel,
              isSelected:
                  state is OpportunityLoaded && state.sportTypeId != null,
              onTap: () => _showFilterDialog(strings),
            ),
            SizedBox(width: 8.w),
            if (state is OpportunityLoaded &&
                (state.sportTypeId != null || state.searchTerm != null))
              _buildFilterChip(
                label: strings.clear,
                icon: Icons.clear_all,
                isSelected: false,
                onTap: _clearFilters,
              ),
          ],
        ),
      ),
    );
  }

  // ── Shimmer ───────────────────────────────────────────────────────────────

  List<Widget> _buildShimmerList() =>
      List.generate(5, (_) => _buildShimmerCard());

  Widget _buildShimmerCard() {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    Colors.grey[300]!,
                    Colors.grey[100]!,
                    Colors.grey[300]!,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: _SlidingGradientTransform(
                    slidePercent: _shimmerController.value,
                  ),
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(double.infinity, 18.h),
                        SizedBox(height: 8.h),
                        _shimmerBox(150.w, 18.h),
                        SizedBox(height: 12.h),
                        _shimmerBox(120.w, 14.h),
                        SizedBox(height: 8.h),
                        _shimmerBox(100.w, 12.h),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _shimmerBox(80.w, 80.h, radius: 12.r),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _shimmerBox(double width, double height, {double? radius}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 4.r),
      ),
    );
  }

  // ── Opportunities list ────────────────────────────────────────────────────

  List<Widget> _buildOpportunitiesList(
    OpportunityLoaded state,
    S strings,
  ) {
    if (state.opportunities.isEmpty) return [_buildEmptyState(strings)];

    final widgets = <Widget>[
      for (final opp in state.opportunities) _buildJobCard(opp, strings),
      if (state.hasNextPage)
        Padding(
          padding: EdgeInsets.all(16.h),
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
    ];

    return widgets;
  }

  // ── Empty / error states ──────────────────────────────────────────────────

  Widget _buildEmptyState(S strings) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              strings.noOpportunitiesFound,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: _clearFilters,
              child: Text(strings.clearFilters),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, S strings) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[400]),
            SizedBox(height: 16.h),
            Text(
              strings.somethingWentWrong,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style:
                  GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () => context.read<OpportunityBloc>().add(
                    const FetchOpportunities(isRefresh: true),
                  ),
              icon: const Icon(Icons.refresh),
              label: Text(
                strings.retry,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.surface),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter chip ───────────────────────────────────────────────────────────

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.tune,
              size: 18.sp,
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.onSurface,
            ),
            SizedBox(width: 6.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 120.w),
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Job card ──────────────────────────────────────────────────────────────

  bool _hasValidImage(String? url) =>
      url != null && url.isNotEmpty && url.trim().isNotEmpty;

  Widget _buildJobCard(OpportunityModel opportunity, S strings) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
      shadowColor: Theme.of(context).colorScheme.surface,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => OpportunityBloc(
                    opportunityRepo: getIt<OpportunityReposatory>(),
                  ),
                  child: OpportunityDetailsPage(
                    opportunityId: opportunity.id,
                    isOwner: opportunity.isOwner,
                  ),
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opportunity.title,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        opportunity.publisherName,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14.sp, color: Colors.grey[500]),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              formatTimeAgo(context, opportunity.createdAt),
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: _hasValidImage(opportunity.mediaUrl)
                        ? Colors.grey[200]
                        : Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _hasValidImage(opportunity.mediaUrl)
                        ? Image.network(
                            opportunity.mediaUrl!,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Theme.of(context).colorScheme.primary,
                              child: Center(
                                child: Icon(
                                  Icons.event_available_outlined,
                                  size: 40.sp,
                                  color:
                                      Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.event_available_outlined,
                              size: 40.sp,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Filter dialog ─────────────────────────────────────────────────────────

  void _showFilterDialog(S strings) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            strings.selectSport,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _sportTypes.entries.map((entry) {
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  title: Card(
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 10.h),
                      child: Text(
                        _getLocalizedSportName(entry.key, strings),
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    context.read<OpportunityBloc>().add(
                          UpdateSportFilter(
                            sportTypeId: entry.value,
                            sportName: entry.key,
                          ),
                        );
                    Navigator.pop(dialogContext);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                strings.cancel,
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Shimmer gradient transform ────────────────────────────────────────────────

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
}
