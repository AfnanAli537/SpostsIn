import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
import 'package:sports_in/features/main/opportunity/view_model/applicants_bloc/applicants_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class ApplicantsPage extends StatefulWidget {
  final String opportunityId;

  const ApplicantsPage({super.key, required this.opportunityId});

  @override
  State<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<ApplicantsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _currentStatus;
  String? _generalStatus;
  final Map<String, ApplicantsResponseModel> _tabCache = {};
  final Set<String> _dirtyTabs = {};
  String get _cacheKey => _currentStatus ?? 'null';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentStatus = null;
    _fetchCurrentTab();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchCurrentTabIfNeeded() {
    final hasCached = _tabCache.containsKey(_cacheKey);
    final isDirty = _dirtyTabs.contains(_cacheKey);

    if (!hasCached || isDirty) {
      _fetchCurrentTab();
    } else {
      setState(() {});
    }
  }

  void _fetchCurrentTab() {
    context.read<ApplicantsBloc>().add(
      FetchApplicants(
        opportunityId: widget.opportunityId,
        status: _currentStatus,
      ),
    );
  }

  void _markAllTabsDirty() {
    _dirtyTabs.addAll(['null', 'accepted', 'rejected']);
  }

  void _onTabTapped(int index) {
    String? status;
    switch (index) {
      case 0:
        status = null;
        break;
      case 1:
        status = 'accepted';
        break;
      case 2:
        status = 'rejected';
        break;
    }
    setState(() => _currentStatus = status);
    setState(() => _generalStatus = status);

    _fetchCurrentTabIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.applicants,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: theme.onSurface,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          dividerColor: theme.surface,
          controller: _tabController,
          labelColor: theme.primary,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: theme.onSurface, width: 3),
          ),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
          ),
          onTap: _onTabTapped,
          tabs: [
            Tab(text: strings.all),
            Tab(text: strings.accepted),
            Tab(text: strings.rejected),
          ],
        ),
      ),
      body: BlocConsumer<ApplicantsBloc, ApplicantsState>(
        listener: (context, state) {
          if (state is ApplicantsLoaded) {
            final key = _generalStatus ?? 'null';
            _tabCache[key] = state.response;
            _dirtyTabs.remove(key);
          }

          if (state is ApplicantActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            _markAllTabsDirty();
            _tabCache.remove(_cacheKey);
            _fetchCurrentTab();
          }

          if (state is ApplicantsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final cachedData = _tabCache[_cacheKey];
          if (state is ApplicantsLoading && cachedData == null) {
            return _buildShimmerList(isDark: isDark);
          }
          if (cachedData != null) {
            return _buildRefreshable(
              isDark: isDark,
              child: _buildApplicantsList(cachedData, strings),
            );
          }
          if (state is ApplicantsLoaded && _generalStatus == _currentStatus) {
            return _buildRefreshable(
              isDark: isDark,
              child: _buildApplicantsList(state.response, strings),
            );
          }
          if (state is ApplicantsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    strings.errorLoadingApplicants,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton.icon(
                    onPressed: _fetchCurrentTab,
                    icon: Icon(Icons.refresh, color: theme.surface),
                    label: Text(
                      strings.retry,
                      style: TextStyle(color: theme.surface),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return _buildShimmerList(isDark: isDark);
        },
      ),
    );
  }

  Widget _buildRefreshable({required Widget child, required bool isDark}) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
      strokeWidth: 2.5,
      onRefresh: () async {
        _tabCache.remove(_cacheKey);
        _fetchCurrentTab();
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: child,
    );
  }

  Widget _buildShimmerList({required bool isDark}) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 4,
      itemBuilder: (_, __) => _buildShimmerCard(isDark: isDark),
    );
  }

  Widget _buildShimmerCard({required bool isDark}) {
    final baseColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade500 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 0,
        color: isDark ? Colors.grey.shade800 : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: isDark
                    ? Colors.grey.shade600
                    : Colors.grey.shade300,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 11.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade600
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 36.h,
                width: 72.w,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplicantsList(ApplicantsResponseModel response, S strings) {
    if (response.items.isEmpty) {
      final emptyMessage = _currentStatus == 'accepted'
          ? strings.noAcceptedApplicants
          : _currentStatus == 'rejected'
          ? strings.noRejectedApplicants
          : strings.noApplicantsFound;
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 56.sp,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    emptyMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: response.items.length,
      itemBuilder: (context, index) =>
          _buildApplicantCard(response.items[index], strings),
    );
  }

  Widget _buildApplicantCard(Applicant applicant, S strings) {
    final actionState = context.watch<ApplicantsBloc>().state;
    final isProcessing =
        actionState is ApplicantActionLoading &&
        actionState.applicationId == applicant.applicationId;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: Colors.grey.shade400,
              backgroundImage: applicant.profilePictureUrl != null
                  ? NetworkImage(applicant.profilePictureUrl!)
                  : null,
              child: applicant.profilePictureUrl == null
                  ? Icon(Icons.person, size: 28.sp, color: Colors.grey.shade200)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    applicant.applicantName,
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    applicant.applicantType,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (isProcessing)
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else
              _buildActionButtons(applicant, strings),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Applicant applicant, S strings) {
    if (applicant.isAccepted) return _buildRejectButton(applicant, strings);
    if (applicant.isRejected) return _buildAcceptButton(applicant, strings);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAcceptButton(applicant, strings),
        SizedBox(width: 8.w),
        _buildRejectButton(applicant, strings),
      ],
    );
  }

  Widget _buildAcceptButton(Applicant applicant, S strings) {
    return ElevatedButton(
      onPressed: () => context.read<ApplicantsBloc>().add(
        AcceptApplicant(
          applicationId: applicant.applicationId,
          status: 'accepted',
          opportunityId: widget.opportunityId,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A5F4E),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        minimumSize: Size(0, 36.h),
        elevation: 0,
      ),
      child: Text(
        strings.accept,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRejectButton(Applicant applicant, S strings) {
    return ElevatedButton(
      onPressed: () => context.read<ApplicantsBloc>().add(
        RejectApplicant(
          applicationId: applicant.applicationId,
          status: 'rejected',
          opportunityId: widget.opportunityId,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        minimumSize: Size(0, 36.h),
        elevation: 0,
      ),
      child: Text(
        strings.reject,
        style: GoogleFonts.poppins(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
