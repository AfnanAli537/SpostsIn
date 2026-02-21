// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
// import 'package:sports_in/features/main/opportunity/view_model/applicants_bloc/applicants_bloc.dart';
// import 'package:sports_in/generated/l10n.dart';

// class ApplicantsPage extends StatefulWidget {
//   final String opportunityId;

//   const ApplicantsPage({
//     super.key,
//     required this.opportunityId,
//   });

//   @override
//   State<ApplicantsPage> createState() => _ApplicantsPageState();
// }

// class _ApplicantsPageState extends State<ApplicantsPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String? _currentStatus;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _currentStatus = null;

//     context.read<ApplicantsBloc>().add(
//           FetchApplicants(opportunityId: widget.opportunityId),
//         );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _refreshCurrentTab() {
//     context.read<ApplicantsBloc>().add(
//           FetchApplicants(
//             opportunityId: widget.opportunityId,
//             status: _currentStatus,
//           ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final strings = S.of(context);
//     final theme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: theme.onSurface),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           strings.applicants,
//           style: GoogleFonts.poppins(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: theme.onSurface,
//           ),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           dividerColor: theme.surface,
//           controller: _tabController,
//           labelColor: theme.primary,
//           unselectedLabelColor: Colors.grey,
//           indicator: UnderlineTabIndicator(
//             borderRadius: BorderRadius.circular(4),
//             borderSide: BorderSide(
//               color: theme.primary,
//               width: 3,
//             ),
//           ),
//           labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//           unselectedLabelStyle:
//               GoogleFonts.poppins(fontWeight: FontWeight.w400),
//           onTap: (index) {
//             String? status;
//             switch (index) {
//               case 0:
//                 status = null;
//                 break;
//               case 1:
//                 status = 'accepted';
//                 break;
//               case 2:
//                 status = 'rejected';
//                 break;
//             }

//             setState(() {
//               _currentStatus = status;
//             });

//             context.read<ApplicantsBloc>().add(
//                   FetchApplicants(
//                     opportunityId: widget.opportunityId,
//                     status: status,
//                   ),
//                 );
//           },
//           tabs: [
//             Tab(text: strings.all),
//             Tab(text: strings.accepted),
//             Tab(text: strings.rejected),
//           ],
//         ),
//       ),
//       body: BlocConsumer<ApplicantsBloc, ApplicantsState>(
//         listener: (context, state) {
//           if (state is ApplicantActionSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//                 duration: const Duration(seconds: 2),
//               ),
//             );

//             _refreshCurrentTab();
//           }

//           if (state is ApplicantsError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 3),
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ApplicantsLoading) {
//             return _buildShimmerList();
//           }

//           if (state is ApplicantsLoaded) {
//             return _buildApplicantsList(state.response, strings);
//           }

//           if (state is ApplicantsError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     strings.errorLoadingApplicants,
//                     style: GoogleFonts.poppins(fontSize: 16.sp),
//                   ),
//                   SizedBox(height: 8.h),
//                   ElevatedButton(
//                     onPressed: _refreshCurrentTab,
//                     child: Text(
//                       strings.retry,
//                       style: TextStyle(color: Theme.of(context).colorScheme.surface),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   // ─── Shimmer ────────────────────────────────────────────────────────────────

//   Widget _buildShimmerList() {
//     return ListView.builder(
//       padding: EdgeInsets.all(16.w),
//       itemCount: 6,
//       itemBuilder: (context, index) => _buildShimmerCard(),
//     );
//   }

//   Widget _buildShimmerCard() {
//     return Shimmer.fromColors(
//       baseColor:Theme.of(context).colorScheme.onError,
//       highlightColor: Colors.grey,
//       // highlightColor:Theme.of(context).colorScheme.onError ,
//       child: Card(
//         margin: EdgeInsets.only(bottom: 12.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         elevation: 2,
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Row(
//             children: [
//               // Avatar placeholder
//               CircleAvatar(
//                 radius: 28.r,
//                 backgroundColor: Colors.white,
//               ),
//               SizedBox(width: 12.w),
//               // Text placeholders
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 14.h,
//                       width: 140.w,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Container(
//                       height: 11.h,
//                       width: 90.w,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               // Button placeholder
//               Container(
//                 height: 36.h,
//                 width: 72.w,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ─── Applicants list ────────────────────────────────────────────────────────

//   Widget _buildApplicantsList(ApplicantsResponseModel response, S strings) {
//     if (response.items.isEmpty) {
//       String emptyMessage;
//       switch (_currentStatus) {
//         case 'accepted':
//           emptyMessage = strings.noAcceptedApplicants;
//           break;
//         case 'rejected':
//           emptyMessage = strings.noRejectedApplicants;
//           break;
//         default:
//           emptyMessage = strings.noApplicantsFound;
//       }

//       return Center(
//         child: Text(
//           emptyMessage,
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             color: Colors.grey,
//           ),
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: EdgeInsets.all(16.w),
//       itemCount: response.items.length,
//       itemBuilder: (context, index) {
//         final applicant = response.items[index];
//         return _buildApplicantCard(applicant, strings);
//       },
//     );
//   }

//   // ─── Applicant card ─────────────────────────────────────────────────────────

//   Widget _buildApplicantCard(Applicant applicant, S strings) {
//     final actionState = context.watch<ApplicantsBloc>().state;
//     final isProcessing = actionState is ApplicantActionLoading &&
//         actionState.applicationId == applicant.applicationId;

//     return Card(
//       margin: EdgeInsets.only(bottom: 12.h),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       elevation: 2,
//       shadowColor: Colors.black.withOpacity(0.08),
//       child: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Row(
//           children: [
//             // Avatar
//             CircleAvatar(
//               radius: 28.r,
//               backgroundColor: Colors.grey.shade500,
//               backgroundImage: applicant.profilePictureUrl != null
//                   ? NetworkImage(applicant.profilePictureUrl!)
//                   : null,
//               child: applicant.profilePictureUrl == null
//                   ? Icon(
//                       Icons.person,
//                       size: 28.sp,
//                       color: Colors.grey.shade300,
//                     )
//                   : null,
//             ),
//             SizedBox(width: 12.w),
//             // Name & type
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     applicant.applicantName,
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     applicant.applicantType,
//                     style: GoogleFonts.poppins(
//                       fontSize: 12.sp,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Action / loading
//             if (isProcessing)
//               SizedBox(
//                 width: 24.w,
//                 height: 24.h,
//                 child: const CircularProgressIndicator(strokeWidth: 2),
//               )
//             else
//               _buildActionButtons(applicant, strings),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─── Action buttons ──────────────────────────────────────────────────────────

//   Widget _buildActionButtons(Applicant applicant, S strings) {
//     if (applicant.isAccepted) {
//       return _buildRejectButton(applicant, strings);
//     }

//     if (applicant.isRejected) {
//       return _buildAcceptButton(applicant, strings);
//     }

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildAcceptButton(applicant, strings),
//         SizedBox(width: 8.w),
//         _buildRejectButton(applicant, strings),
//       ],
//     );
//   }

//   Widget _buildAcceptButton(Applicant applicant, S strings) {
//     return ElevatedButton(
//       onPressed: () {
//         context.read<ApplicantsBloc>().add(
//               AcceptApplicant(
//                 applicationId: applicant.applicationId,
//                 status: "accepted",
//                 opportunityId: widget.opportunityId,
//               ),
//             );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF1A5F4E),
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         minimumSize: Size(0, 36.h),
//         elevation: 0,
//       ),
//       child: Text(
//         strings.accept,
//         style: GoogleFonts.poppins(
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildRejectButton(Applicant applicant, S strings) {

//     return ElevatedButton(
//       onPressed: () {
//         context.read<ApplicantsBloc>().add(
//               RejectApplicant(
//                 applicationId: applicant.applicationId,
//                 status: 'rejected',
//                 opportunityId: widget.opportunityId,
//               ),
//             );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red,
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         minimumSize: Size(0, 36.h),
//         elevation: 0,
//       ),
//       child: Text(
//         strings.reject,
//         style: GoogleFonts.poppins(
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
// import 'package:sports_in/features/main/opportunity/view_model/applicants_bloc/applicants_bloc.dart';
// import 'package:sports_in/generated/l10n.dart';

// class ApplicantsPage extends StatefulWidget {
//   final String opportunityId;

//   const ApplicantsPage({
//     super.key,
//     required this.opportunityId,
//   });

//   @override
//   State<ApplicantsPage> createState() => _ApplicantsPageState();
// }

// class _ApplicantsPageState extends State<ApplicantsPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String? _currentStatus;

//   final Map<String, ApplicantsResponseModel> _cache = {};

//   String get _cacheKey => _currentStatus ?? 'all';

//   static const List<String?> _tabStatuses = [null, 'accepted', 'rejected'];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _currentStatus = null;
//     _fetchIfNeeded();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _fetchIfNeeded() {
//     if (_cache.containsKey(_cacheKey)) {
//       context.read<ApplicantsBloc>().add(
//             LoadCachedApplicants(cached: _cache[_cacheKey]!),
//           );
//     } else {
//       context.read<ApplicantsBloc>().add(
//             FetchApplicants(
//               opportunityId: widget.opportunityId,
//               status: _currentStatus,
//             ),
//           );
//     }
//   }

//   Future<void> _forceRefresh() async {
//     _cache.remove(_cacheKey);
//     context.read<ApplicantsBloc>().add(
//           FetchApplicants(
//             opportunityId: widget.opportunityId,
//             status: _currentStatus,
//           ),
//         );
//   }

//   void _invalidateAllAndRefresh() {
//     _cache.clear();
//     _fetchIfNeeded();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final strings = S.of(context);
//     final theme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: theme.onSurface),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           strings.applicants,
//           style: GoogleFonts.poppins(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: theme.onSurface,
//           ),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           dividerColor: theme.surface,
//           controller: _tabController,
//           labelColor: theme.primary,
//           unselectedLabelColor: Colors.grey,
//           indicator: UnderlineTabIndicator(
//             borderRadius: BorderRadius.circular(4),
//             borderSide: BorderSide(
//               color: theme.primary,
//               width: 3,
//             ),
//           ),
//           labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//           unselectedLabelStyle:
//               GoogleFonts.poppins(fontWeight: FontWeight.w400),
//           onTap: (index) {
//             final newStatus = _tabStatuses[index];
//             if (newStatus == _currentStatus) return;

//             setState(() {
//               _currentStatus = newStatus;
//             });

//             _fetchIfNeeded();
//           },
//           tabs: [
//             Tab(text: strings.all),
//             Tab(text: strings.accepted),
//             Tab(text: strings.rejected),
//           ],
//         ),
//       ),
//       body: BlocConsumer<ApplicantsBloc, ApplicantsState>(
//         listener: (context, state) {
//           if (state is ApplicantsLoaded) {
//             _cache[_cacheKey] = state.response;
//           }

//           if (state is ApplicantActionSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//                 duration: const Duration(seconds: 2),
//               ),
//             );
//             _invalidateAllAndRefresh();
//           }

//           if (state is ApplicantsError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 3),
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ApplicantsLoading) {
//             return _buildShimmerList();
//           }

//           if (state is ApplicantsLoaded) {
//             return _buildApplicantsList(state.response, strings);
//           }

//           if (state is ApplicantsError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     strings.errorLoadingApplicants,
//                     style: GoogleFonts.poppins(fontSize: 16.sp),
//                   ),
//                   SizedBox(height: 8.h),
//                   ElevatedButton(
//                     onPressed: _forceRefresh,
//                     child: Text(
//                       strings.retry,
//                       style: TextStyle(color: theme.surface),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildShimmerList() {
//     final theme = Theme.of(context).colorScheme;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final baseColor =
//         isDark ? theme.surfaceVariant : theme.surfaceVariant.withOpacity(0.8);
//     final highlightColor =
//         isDark ? theme.surface.withOpacity(0.5) : theme.surface;

//     return ListView.builder(
//       padding: EdgeInsets.all(16.w),
//       itemCount: 6,
//       itemBuilder: (context, index) => Shimmer.fromColors(
//         baseColor: baseColor,
//         highlightColor: highlightColor,
//         child: Card(
//           margin: EdgeInsets.only(bottom: 12.h),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           elevation: 2,
//           color: theme.surfaceVariant,
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 28.r,
//                   backgroundColor: theme.surface,
//                 ),
//                 SizedBox(width: 12.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: 14.h,
//                         width: 140.w,
//                         decoration: BoxDecoration(
//                           color: theme.surface,
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Container(
//                         height: 11.h,
//                         width: 90.w,
//                         decoration: BoxDecoration(
//                           color: theme.surface,
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 12.w),
//                 Container(
//                   height: 36.h,
//                   width: 72.w,
//                   decoration: BoxDecoration(
//                     color: theme.surface,
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildApplicantsList(ApplicantsResponseModel response, S strings) {
//     if (response.items.isEmpty) {
//       String emptyMessage;
//       switch (_currentStatus) {
//         case 'accepted':
//           emptyMessage = strings.noAcceptedApplicants;
//           break;
//         case 'rejected':
//           emptyMessage = strings.noRejectedApplicants;
//           break;
//         default:
//           emptyMessage = strings.noApplicantsFound;
//       }

//       return RefreshIndicator(
//         onRefresh: _forceRefresh,
//         color: Theme.of(context).colorScheme.primary,
//         child: ListView(
//           padding: EdgeInsets.all(16.w),
//           children: [
//             SizedBox(height: MediaQuery.of(context).size.height * 0.35),
//             Center(
//               child: Text(
//                 emptyMessage,
//                 style: GoogleFonts.poppins(
//                   fontSize: 16.sp,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _forceRefresh,
//       color: Theme.of(context).colorScheme.primary,
//       child: ListView.builder(
//         padding: EdgeInsets.all(16.w),
//         itemCount: response.items.length,
//         itemBuilder: (context, index) {
//           final applicant = response.items[index];
//           return _buildApplicantCard(applicant, strings);
//         },
//       ),
//     );
//   }

//   Widget _buildApplicantCard(Applicant applicant, S strings) {
//     final theme = Theme.of(context).colorScheme;
//     final actionState = context.watch<ApplicantsBloc>().state;
//     final isProcessing = actionState is ApplicantActionLoading &&
//         actionState.applicationId == applicant.applicationId;

//     return Card(
//       margin: EdgeInsets.only(bottom: 12.h),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       elevation: 2,
//       shadowColor: Colors.black.withOpacity(0.08),
//       child: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 28.r,
//               backgroundColor: Colors.grey.shade500,
//               backgroundImage: applicant.profilePictureUrl != null
//                   ? NetworkImage(applicant.profilePictureUrl!)
//                   : null,
//               child: applicant.profilePictureUrl == null
//                   ? Icon(
//                       Icons.person,
//                       size: 28.sp,
//                       color: Colors.grey.shade300,
//                     )
//                   : null,
//             ),
//             SizedBox(width: 12.w),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     applicant.applicantName,
//                     style: GoogleFonts.poppins(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: theme.onSurface,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     applicant.applicantType,
//                     style: GoogleFonts.poppins(
//                       fontSize: 12.sp,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (isProcessing)
//               SizedBox(
//                 width: 24.w,
//                 height: 24.h,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: theme.primary,
//                 ),
//               )
//             else
//               _buildActionButtons(applicant, strings),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButtons(Applicant applicant, S strings) {
//     if (applicant.isAccepted) {
//       return _buildRejectButton(applicant, strings);
//     }

//     if (applicant.isRejected) {
//       return _buildAcceptButton(applicant, strings);
//     }

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _buildAcceptButton(applicant, strings),
//         SizedBox(width: 8.w),
//         _buildRejectButton(applicant, strings),
//       ],
//     );
//   }

//   Widget _buildAcceptButton(Applicant applicant, S strings) {
//     return ElevatedButton(
//       onPressed: () {
//         context.read<ApplicantsBloc>().add(
//               AcceptApplicant(
//                 applicationId: applicant.applicationId,
//                 status: 'accepted',
//                 opportunityId: widget.opportunityId,
//               ),
//             );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF1A5F4E),
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         minimumSize: Size(0, 36.h),
//         elevation: 0,
//       ),
//       child: Text(
//         strings.accept,
//         style: GoogleFonts.poppins(
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildRejectButton(Applicant applicant, S strings) {
//     return ElevatedButton(
//       onPressed: () {
//         context.read<ApplicantsBloc>().add(
//               RejectApplicant(
//                 applicationId: applicant.applicationId,
//                 status: 'rejected',
//                 opportunityId: widget.opportunityId,
//               ),
//             );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red,
//         padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         minimumSize: Size(0, 36.h),
//         elevation: 0,
//       ),
//       child: Text(
//         strings.reject,
//         style: GoogleFonts.poppins(
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }




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

  const ApplicantsPage({
    super.key,
    required this.opportunityId,
  });

  @override
  State<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<ApplicantsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _currentStatus;
 String? _generalStatus;

  /// Per-tab in-memory cache. Key = 'null' | 'accepted' | 'rejected'.
  final Map<String, ApplicantsResponseModel> _tabCache = {};

  /// Tabs that need a fresh fetch (dirtied by accept/reject actions).
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

  // ─── Fetch helpers ───────────────────────────────────────────────────────────

  /// Fetches from API only when no cached data exists or tab is dirty.
  void _fetchCurrentTabIfNeeded() {
    final hasCached = _tabCache.containsKey(_cacheKey);
    final isDirty = _dirtyTabs.contains(_cacheKey);

    if (!hasCached || isDirty) {
      _fetchCurrentTab();
    } else {
      setState(() {}); // rebuild to show cached data
    }
  }

  /// Always hits the API — used for initial load, force-refresh, and
  /// post-action refresh.
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

  // ─── Build ───────────────────────────────────────────────────────────────────

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
            borderSide: BorderSide(color: theme.primary, width: 3),
          ),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.w400),
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
          // Cache fresh data and clear dirty flag
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
            // All tabs are now stale — refresh current one immediately
            _markAllTabsDirty();
            _tabCache.remove(_cacheKey); // force shimmer on current tab
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

          // ── Case 1: loading and NO cache → show shimmer ──────────────────
          if (state is ApplicantsLoading && cachedData == null) {
            return _buildShimmerList(isDark: isDark);
          }

          // ── Case 2: have cache → show it immediately (no flicker) ────────
          // The listener will update the cache when the fresh fetch lands.
          if (cachedData != null) {
            return _buildRefreshable(
              isDark: isDark,
              child: _buildApplicantsList(cachedData, strings),
            );
          }

          // ── Case 3: loaded state matches current tab ──────────────────────
          if (state is ApplicantsLoaded && _generalStatus == _currentStatus) {
            return _buildRefreshable(
              isDark: isDark,
              child: _buildApplicantsList(state.response, strings),
            );
          }

          // ── Case 4: error with no cached fallback ─────────────────────────
          if (state is ApplicantsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 48.sp, color: Colors.grey.shade400),
                  SizedBox(height: 12.h),
                  Text(
                    strings.errorLoadingApplicants,
                    style: GoogleFonts.poppins(
                        fontSize: 16.sp, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton.icon(
                    onPressed: _fetchCurrentTab,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: Text(strings.retry,
                        style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                  ),
                ],
              ),
            );
          }

          // ── Fallback: shimmer while waiting for first response ────────────
          return _buildShimmerList(isDark: isDark);
        },
      ),
    );
  }

  // ─── Pull-to-refresh wrapper ─────────────────────────────────────────────────

  Widget _buildRefreshable({required Widget child, required bool isDark}) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: isDark ? Colors.grey.shade800 : Colors.white,
      strokeWidth: 2.5,
      onRefresh: () async {
        _tabCache.remove(_cacheKey);
        _fetchCurrentTab();
        // Wait long enough for the bloc to emit a new state
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: child,
    );
  }

  // ─── Shimmer ────────────────────────────────────────────────────────────────

  Widget _buildShimmerList({required bool isDark}) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (_, __) => _buildShimmerCard(isDark: isDark),
    );
  }

  Widget _buildShimmerCard({required bool isDark}) {
    final baseColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final highlightColor =
        isDark ? Colors.grey.shade500 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)),
        elevation: 0,
        color: isDark ? Colors.grey.shade800 : Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor:
                    isDark ? Colors.grey.shade600 : Colors.grey.shade300,
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
                  color: isDark
                      ? Colors.grey.shade600
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Applicants list ────────────────────────────────────────────────────────

  Widget _buildApplicantsList(ApplicantsResponseModel response, S strings) {
    if (response.items.isEmpty) {
      final emptyMessage = _currentStatus == 'accepted'
          ? strings.noAcceptedApplicants
          : _currentStatus == 'rejected'
              ? strings.noRejectedApplicants
              : strings.noApplicantsFound;

      // Must be scrollable so RefreshIndicator works on empty state
      return LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline,
                      size: 56.sp, color: Colors.grey.shade300),
                  SizedBox(height: 12.h),
                  Text(
                    emptyMessage,
                    style: GoogleFonts.poppins(
                        fontSize: 15.sp, color: Colors.grey.shade500),
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

  // ─── Applicant card ─────────────────────────────────────────────────────────

  Widget _buildApplicantCard(Applicant applicant, S strings) {
    final actionState = context.watch<ApplicantsBloc>().state;
    final isProcessing = actionState is ApplicantActionLoading &&
        actionState.applicationId == applicant.applicationId;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r)),
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
                  ? Icon(Icons.person,
                      size: 28.sp, color: Colors.grey.shade200)
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
                        fontSize: 12.sp, color: Colors.grey.shade500),
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

  // ─── Action buttons ──────────────────────────────────────────────────────────

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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)),
        minimumSize: Size(0, 36.h),
        elevation: 0,
      ),
      child: Text(strings.accept,
          style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white)),
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)),
        minimumSize: Size(0, 36.h),
        elevation: 0,
      ),
      child: Text(strings.reject,
          style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white)),
    );
  }
}