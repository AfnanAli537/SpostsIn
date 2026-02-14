// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
// import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
// import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';

// class OpportunityDetailsPage extends StatefulWidget {
//   final String opportunityId;

//   const OpportunityDetailsPage({
//     super.key,
//     required this.opportunityId,
//   });

//   @override
//   State<OpportunityDetailsPage> createState() => _OpportunityDetailsPageState();
// }

// class _OpportunityDetailsPageState extends State<OpportunityDetailsPage> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch opportunity details on init
//     context.read<OpportunityBloc>().add(
//           FetchOpportunityDetails(opportunityId: widget.opportunityId),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.grey[50],
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Apply opportunity',
//           style: GoogleFonts.poppins(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<OpportunityBloc, OpportunityState>(
//         listener: (context, state) {
//           if (state is OpportunityApplied) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Application submitted successfully!'),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//             // Navigate back after successful application
//             Future.delayed(const Duration(seconds: 1), () {
//               if (mounted) {
//                 Navigator.pop(context);
//               }
//             });
//           }

//           if (state is OpportunityError) {
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
//           if (state is OpportunityDetailsLoading) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: const Color(0xFF1A5F4E),
//               ),
//             );
//           }

//           if (state is OpportunityDetailsLoaded) {
//             return _buildDetailsContent(state.opportunity);
//           }

//           if (state is OpportunityError) {
//             return _buildErrorState(state.message);
//           }

//           // Default loading state
//           return Center(
//             child: CircularProgressIndicator(
//               color: const Color(0xFF1A5F4E),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDetailsContent(DetailsModel opportunity) {
//     final isApplying = context.watch<OpportunityBloc>().state is OpportunityApplying;

//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header Image/Logo
//                 _buildHeaderImage(opportunity),
//                 SizedBox(height: 24.h),

//                 // Title Section
//                 _buildSection(
//                   title: 'Title',
//                   content: Text(
//                     opportunity.title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w400,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),

//                 // Description Section
//                 _buildSection(
//                   title: 'Description',
//                   content: Text(
//                     opportunity.description,
//                     style: GoogleFonts.poppins(
//                       fontSize: 14.sp,
//                       height: 1.6,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),

//                 // Requirements Section
//                 _buildSection(
//                   title: 'Requirements',
//                   content:
//                        _buildRequirementsFromText(opportunity.requirements)

//                 ),
//                 SizedBox(height: 20.h),

//                 // End Date Section
//                 _buildSection(
//                   title: 'End Date',
//                   content: Text(
//                    _formatEndDate( opportunity.endDate),
//                     style: GoogleFonts.poppins(
//                       fontSize: 14.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),

//                 // // Publisher Info (Optional)
//                 // _buildSection(
//                 //   title: 'Published By',
//                 //   content: Text(
//                 //     opportunity.publisherName,
//                 //     style: GoogleFonts.poppins(
//                 //       fontSize: 14.sp,
//                 //       color: Colors.black87,
//                 //     ),
//                 //   ),
//                 // ),
//                 SizedBox(height: 100.h), // Space for button
//               ],
//             ),
//           ),
//         ),

//         // Apply Button (Fixed at bottom)
//         Container(
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, -2),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: SizedBox(
//               width: double.infinity,
//               height: 56.h,
//               child: ElevatedButton(
//                 onPressed: isApplying
//                     ? null
//                     : () {
//                         _showApplyConfirmation(opportunity);
//                       },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A5F4E),
//                   disabledBackgroundColor: Colors.grey[400],
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: isApplying
//                     ? SizedBox(
//                         height: 20.h,
//                         width: 20.w,
//                         child: const CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : Text(
//                         'Apply Now',
//                         style: GoogleFonts.poppins(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w600,
//                           color: const Color(0xFFCFFF8D),
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeaderImage(DetailsModel opportunity) {
//     return Container(
//       width: double.infinity,
//       height: 180.h,
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A5F4E),
//         borderRadius: BorderRadius.circular(16.r),
//         image: opportunity.mediaFile != null
//             ? DecorationImage(
//                 image: NetworkImage(opportunity.mediaFile!),
//                 fit: BoxFit.cover,
//               )
//             : null,
//       ),
//       child: opportunity.mediaFile == null
//           ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'FOOTBALL CLUB',
//                   style: GoogleFonts.poppins(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white70,
//                     letterSpacing: 1.5,
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Container(
//                   width: 80.w,
//                   height: 80.h,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: Center(
//                     child: Text(
//                       '⚽',
//                       style: TextStyle(fontSize: 40.sp),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8.h),
//                 Text(
//                   'EST. 1954',
//                   style: GoogleFonts.poppins(
//                     fontSize: 10.sp,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             )
//           : null,
//     );
//   }

//   Widget _buildSection({
//     required String title,
//     required Widget content,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(
//               color: Colors.grey.shade200,
//               width: 1,
//             ),
//           ),
//           child: content,
//         ),
//       ],
//     );
//   }

//   Widget _buildRequirementsList() {
//     // Placeholder requirements - you might want to add these to your model
//     final requirements = [
//       'Male players aged 18-23',
//       'Previous experience in club or academy football',
//       'Good physical condition',
//       'Medical fitness certificate',
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: requirements.map((requirement) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: 8.h),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(top: 6.h, right: 8.w),
//                 width: 6.w,
//                 height: 6.h,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF1A5F4E),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   requirement,
//                   style: GoogleFonts.poppins(
//                     fontSize: 14.sp,
//                     height: 1.5,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildRequirementsFromText(String requirementsText) {
//     // Split by newlines or bullet points
//     final requirements = requirementsText
//         .split(RegExp(r'\n|•|\*'))
//         .where((req) => req.trim().isNotEmpty)
//         .toList();

//     if (requirements.isEmpty) {
//       return Text(
//         requirementsText,
//         style: GoogleFonts.poppins(
//           fontSize: 14.sp,
//           height: 1.6,
//           color: Colors.black87,
//         ),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: requirements.map((requirement) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: 8.h),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(top: 6.h, right: 8.w),
//                 width: 6.w,
//                 height: 6.h,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF1A5F4E),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   requirement.trim(),
//                   style: GoogleFonts.poppins(
//                     fontSize: 14.sp,
//                     height: 1.5,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildErrorState(String message) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(32.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 64.sp,
//               color: Colors.red[400],
//             ),
//             SizedBox(height: 16.h),
//             Text(
//               'Failed to load details',
//               style: GoogleFonts.poppins(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               message,
//               style: GoogleFonts.poppins(
//                 fontSize: 14.sp,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 24.h),
//             ElevatedButton.icon(
//               onPressed: () {
//                 context.read<OpportunityBloc>().add(
//                       FetchOpportunityDetails(opportunityId: widget.opportunityId),
//                     );
//               },
//               icon: const Icon(Icons.refresh),
//               label: const Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1A5F4E),
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showApplyConfirmation(OpportunityModel opportunity) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.r),
//           ),
//           title: Text(
//             'Apply to Opportunity',
//             style: GoogleFonts.poppins(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to apply for "${opportunity.title}"?',
//             style: GoogleFonts.poppins(
//               fontSize: 14.sp,
//               color: Colors.grey[700],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//               child: Text(
//                 'Cancel',
//                 style: GoogleFonts.poppins(
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//                 // Trigger apply event
//                 context.read<OpportunityBloc>().add(
//                       ApplyToOpportunity(opportunityId: opportunity.id),
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1A5F4E),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//               ),
//               child: Text(
//                 'Apply',
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   String _formatEndDate(DateTime createdAt) {
//     // Calculate end date (30 days from creation for example)
//     final endDate = createdAt.add(const Duration(days: 30));
//     final months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];

//     return '${months[endDate.month - 1]} ${endDate.day}, ${endDate.year}';
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
// import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
// import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';

// class OpportunityDetailsPage extends StatefulWidget {
//   final String opportunityId;

//   const OpportunityDetailsPage({
//     super.key,
//     required this.opportunityId,
//   });

//   @override
//   State<OpportunityDetailsPage> createState() =>
//       _OpportunityDetailsPageState();
// }

// class _OpportunityDetailsPageState extends State<OpportunityDetailsPage> {
//   @override
//   void initState() {
//     super.initState();

//     /// fetch details
//     context.read<OpportunityBloc>().add(
//           FetchOpportunityDetails(opportunityId: widget.opportunityId),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.grey[50],
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Apply opportunity',
//           style: GoogleFonts.poppins(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<OpportunityBloc, OpportunityState>(
//         listener: (context, state) {
//           if (state is OpportunityApplied) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Application submitted successfully!'),
//                 backgroundColor: Colors.green,
//               ),
//             );

//             Future.delayed(const Duration(seconds: 1), () {
//               if (mounted) Navigator.pop(context);
//             });
//           }

//           if (state is OpportunityError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         builder: (context, state) {

//           if (state is OpportunityDetailsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is OpportunityDetailsLoaded) {

//             return _buildDetailsContent(state.opportunity);
//           }

//           if (state is OpportunityError) {
//             return _buildErrorState(state.message);
//           }

//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }

//   // =========================================================
//   // DETAILS CONTENT
//   // =========================================================

//   Widget _buildDetailsContent(DetailsModel opportunity,OpportunityModel opp_model) {
//     final isApplying =
//         context.watch<OpportunityBloc>().state is OpportunityApplying;
//   final appled = opportunity.isAlreadyApplied;
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeaderImage(opportunity),
//                 SizedBox(height: 24.h),

//                 _buildSection(
//                   title: 'Title',
//                   content: Text(opportunity.title),
//                 ),

//                 SizedBox(height: 20.h),

//                 _buildSection(
//                   title: 'Description',
//                   content: Text(opportunity.description),
//                 ),

//                 SizedBox(height: 20.h),

//                 _buildSection(
//                   title: 'Requirements',
//                   content:
//                       _buildRequirementsFromText(opportunity.requirements),
//                 ),

//                 SizedBox(height: 20.h),

//                 _buildSection(
//                   title: 'End Date',
//                   content: Text(_formatEndDate(opportunity.endDate)),
//                 ),

//                 SizedBox(height: 100.h),
//               ],
//             ),
//           ),
//         ),

//         /// Apply button
//         _buildApplyButton(opportunity, isApplying,appled),
//       ],
//     );
//   }

//   // =========================================================
//   // HEADER IMAGE (FIXED + BETTER UX)
//   // =========================================================

//   Widget _buildHeaderImage(DetailsModel opportunity) {
//     final imageUrl =
//         opportunity.uploadedMediaUrl ?? opportunity.mediaFile;

//     return Container(
//       width: double.infinity,
//       height: 180.h,
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A5F4E),
//         borderRadius: BorderRadius.circular(16.r),
//         image: imageUrl != null
//             ? DecorationImage(
//                 image: NetworkImage(imageUrl),
//                 fit: BoxFit.cover,
//               )
//             : null,
//       ),
//       child: imageUrl == null
//           ? Center(
//               child: Icon(
//                 Icons.sports_soccer,
//                 size: 60.sp,
//                 color: Colors.white.withOpacity(.9),
//               ),
//             )
//           : null,
//     );
//   }

//   // =========================================================
//   // APPLY BUTTON
//   // =========================================================

//   Widget _buildApplyButton(
//       DetailsModel opportunity, bool isApplying,bool appled) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: const BoxDecoration(color: Colors.white),
//       child: SafeArea(
//         child: SizedBox(
//           width: double.infinity,
//           height: 56.h,
//           child: ElevatedButton(
//             onPressed: isApplying
//                 ? null
//                 : appled==true  || opportunity_model.isOwner==true ? null:  () => _showApplyConfirmation(opportunity),
//             style: ElevatedButton.styleFrom(
//               backgroundColor:appled==true?Colors.grey[600]: const Color(0xFF1A5F4E),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//             ),
//             child: isApplying
//                 ? const CircularProgressIndicator(color: Colors.white)
//                 : Text(
//                     'Apply Now',
//                     style: GoogleFonts.poppins(
//                       color:  const Color(0xFFCFFF8D),
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }

//   // =========================================================
//   // SECTION WIDGET
//   // =========================================================

//   Widget _buildSection({
//     required String title,
//     required Widget content,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(title,
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
//         SizedBox(height: 8.h),
//         Container(
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: content,
//         ),
//       ],
//     );
//   }

//   // =========================================================
//   // REQUIREMENTS
//   // =========================================================

//   Widget _buildRequirementsFromText(String text) {
//     final requirements = text
//         .split(RegExp(r'\n|•|\*'))
//         .where((e) => e.trim().isNotEmpty)
//         .toList();

//     return Column(
//       children: requirements
//           .map(
//             (e) => Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("• "),
//                 Expanded(child: Text(e.trim())),
//               ],
//             ),
//           )
//           .toList(),
//     );
//   }

//   // =========================================================
//   // ERROR
//   // =========================================================

//   Widget _buildErrorState(String message) {
//     return Center(child: Text(message));
//   }

//   // =========================================================
//   // CONFIRM APPLY (FIXED TYPE)
//   // =========================================================

//   void _showApplyConfirmation(DetailsModel opportunity) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Apply'),
//         content:
//             Text('Apply for "${opportunity.title}" ?'),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel')),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<OpportunityBloc>().add(
//                     ApplyToOpportunity(
//                         opportunityId: widget.opportunityId),
//                   );
//             },
//             child: const Text('Apply'),
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================
//   // DATE FORMAT (FIXED – NO +30 DAYS)
//   // =========================================================

//   String _formatEndDate(DateTime date) {
//     final months = [
//       'Jan','Feb','Mar','Apr','May','Jun',
//       'Jul','Aug','Sep','Oct','Nov','Dec'
//     ];
//     return '${months[date.month - 1]} ${date.day}, ${date.year}';
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/core/widgets/confirmation_dialog.dart';
import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/applicants_screen.dart';
import 'package:sports_in/features/main/opportunity/view_model/bloc/applicants_bloc.dart';
import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class OpportunityDetailsPage extends StatefulWidget {
  final String opportunityId;
  final bool? isOwner;
  // final Applicant? applicants;

  const OpportunityDetailsPage({
    super.key,
    required this.opportunityId,
    this.isOwner,
    //  this.applicants,
  });

  @override
  State<OpportunityDetailsPage> createState() => _OpportunityDetailsPageState();
}

class _OpportunityDetailsPageState extends State<OpportunityDetailsPage> {
  @override
  void initState() {
    super.initState();

    /// fetch details
    context.read<OpportunityBloc>().add(
      FetchOpportunityDetails(opportunityId: widget.opportunityId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Apply opportunity',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: widget.isOwner == true ? [
          // Edit button
      IconButton(
        icon: Icon(
          Icons.edit_outlined,
          color: colorScheme.onSurface,
          size: 20.sp,
        ),
        onPressed: () async {
          // First, fetch full opportunity details
          context.read<OpportunityBloc>().add(
                FetchOpportunityDetails(opportunityId: widget.opportunityId),
              );

          // Navigate to update screen
          final result = await Navigator.pushNamed(
            context,
            AppRoutes.opportunityEditScreen,
            arguments: widget.opportunityId, // Pass ID to fetch details
          );

          // Refresh if updated
          if (result == true) {
            context.read<OpportunityBloc>().add(
                  const FetchOpportunities(isRefresh: true),
                );
          }
          Navigator.pop(context);
        },
      ),
      
      // Delete button
      IconButton(
        icon: Icon(
          Icons.delete_outline,
          color: colorScheme.onSurface,
          size: 20.sp,
        ),
        onPressed: () {
          ConfirmationDialog.show(
            context: context,
            title: 'Delete Opportunity',
            message: 'Are you sure you want to delete this opportunity? This action cannot be undone.',
            onConfirm: () {
              context.read<OpportunityBloc>().add(
                    DeleteOpportunity(opportunityId: widget.opportunityId),
                  );

              Fluttertoast.showToast(
                msg: 'Deleting opportunity...',
                backgroundColor: Colors.orange,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            },
            confirmText: 'Delete',
            cancelText: 'Cancel',
            icon: Icons.delete_outline,
            isDestructive: true,
          );
        },
      ),
        ]:null
      ),
      body: BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
          if (state is OpportunityApplied) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Application submitted successfully!'),
                backgroundColor: Colors.green,
              ),
            );

            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) Navigator.pop(context);
            });
          }

          if (state is OpportunityError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is OpportunityDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OpportunityDetailsLoaded) {
            return _buildDetailsContent(
              state.opportunity,
              widget.isOwner ?? false,
            );
          }

          if (state is OpportunityError) {
            return _buildErrorState(state.message);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // =========================================================
  // DETAILS CONTENT
  // =========================================================

  Widget _buildDetailsContent(DetailsModel opportunity, bool isOwner) {
    final isApplying =
        context.watch<OpportunityBloc>().state is OpportunityApplying;
    final appled = opportunity.isAlreadyApplied;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(opportunity),
                SizedBox(height: 24.h),

                _buildSection(title: 'Title', content: Text(opportunity.title)),

                SizedBox(height: 20.h),

                _buildSection(
                  title: 'Description',
                  content: Text(opportunity.description),
                ),

                SizedBox(height: 20.h),

                _buildSection(
                  title: 'Requirements',
                  content: _buildRequirementsFromText(opportunity.requirements),
                ),

                SizedBox(height: 20.h),

                _buildSection(
                  title: 'End Date',
                  content: Text(_formatEndDate(opportunity.endDate)),
                ),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),

        /// Show different button based on ownership
        if (isOwner)
          _buildShowApplicantsButton()
        else
          _buildApplyButton(opportunity, isApplying, appled),
      ],
    );
  }

  // =========================================================
  // HEADER IMAGE (FIXED + BETTER UX)
  // =========================================================

  Widget _buildHeaderImage(DetailsModel opportunity) {
    final imageUrl = opportunity.uploadedMediaUrl ?? opportunity.mediaFile;

    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1A5F4E),
        borderRadius: BorderRadius.circular(16.r),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover)
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Icon(
                Icons.sports_soccer,
                size: 60.sp,
                color: Colors.white.withOpacity(.9),
              ),
            )
          : null,
    );
  }

  // =========================================================
  // SHOW APPLICANTS BUTTON (FOR OWNER)
  // =========================================================

  Widget _buildShowApplicantsButton() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigate to applicants page
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => ApplicantsBloc(repository: getIt<OpportunityReposatory>()),
                    child: ApplicantsPage(opportunityId: widget.opportunityId),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A5F4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Show Applicants',
              style: GoogleFonts.poppins(
                color: const Color(0xFFCFFF8D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // APPLY BUTTON
  // =========================================================

  Widget _buildApplyButton(
    DetailsModel opportunity,
    bool isApplying,
    bool appled,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: isApplying || appled
                ? null
                : () => _showApplyConfirmation(opportunity),
            style: ElevatedButton.styleFrom(
              backgroundColor: appled
                  ? Colors.grey[600]
                  : const Color(0xFF1A5F4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: isApplying
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    appled ? 'Already Applied' : 'Apply Now',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFCFFF8D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SECTION WIDGET
  // =========================================================

  Widget _buildSection({required String title, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: content,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // REQUIREMENTS
  // =========================================================

  Widget _buildRequirementsFromText(String text) {
    final requirements = text
        .split(RegExp(r'\n|•|\*'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return Column(
      children: requirements
          .map(
            (e) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• "),
                Expanded(child: Text(e.trim())),
              ],
            ),
          )
          .toList(),
    );
  }

  // =========================================================
  // ERROR
  // =========================================================

  Widget _buildErrorState(String message) {
    return Center(child: Text(message));
  }

  // =========================================================
  // CONFIRM APPLY (FIXED TYPE)
  // =========================================================

  void _showApplyConfirmation(DetailsModel opportunity) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Apply'),
        content: Text('Apply for "${opportunity.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<OpportunityBloc>().add(
                ApplyToOpportunity(opportunityId: widget.opportunityId),
              );
            },
            child: const Text('Apply', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DATE FORMAT (FIXED – NO +30 DAYS)
  // =========================================================

  String _formatEndDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
