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
//                     opportunity.description ?? 
//                     'Cairo Falcons FC is seeking its future for a 4-day professional tryout for talented young players who aspire to join one of Egypt\'s leading clubs and compete in the national league.',
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
//                   content: opportunity.requirements != null
//                       ? _buildRequirementsFromText(opportunity.requirements!)
//                       : _buildRequirementsList(),
//                 ),
//                 SizedBox(height: 20.h),

//                 // End Date Section
//                 _buildSection(
//                   title: 'End Date',
//                   content: Text(
//                     opportunity.endDate ?? _formatEndDate(opportunity.createdAt),
//                     style: GoogleFonts.poppins(
//                       fontSize: 14.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),

//                 // Publisher Info (Optional)
//                 _buildSection(
//                   title: 'Published By',
//                   content: Text(
//                     opportunity.publisherName,
//                     style: GoogleFonts.poppins(
//                       fontSize: 14.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
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