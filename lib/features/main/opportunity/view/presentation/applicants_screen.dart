// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
// import 'package:sports_in/features/main/opportunity/view_model/bloc/applicants_bloc.dart';

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

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
    
//     // Fetch all applicants initially
//     context.read<ApplicantsBloc>().add(
//           FetchApplicants(opportunityId: widget.opportunityId),
//         );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Applicants',
//           style: GoogleFonts.poppins(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: const Color(0xFF1A5F4E),
//           unselectedLabelColor: Colors.grey,
//           indicatorColor: const Color(0xFF1A5F4E),
//           labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//           unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400),
//           onTap: (index) {
//             String? status;
//             switch (index) {
//               case 0:
//                 status = null; // All
//                 break;
//               case 1:
//                 status = 'accepted';
//                 break;
//               case 2:
//                 status = 'rejected';
//                 break;
//             }
//             context.read<ApplicantsBloc>().add(
//                   FetchApplicants(
//                     opportunityId: widget.opportunityId,
//                     status: status,
//                   ),
//                 );
//           },
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'Accepted'),
//             Tab(text: 'Rejected'),
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
//               ),
//             );
//           }

//           if (state is ApplicantsError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is ApplicantsLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is ApplicantsLoaded) {
//             return _buildApplicantsList(state.response);
//           }

//           if (state is ApplicantsError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error loading applicants',
//                     style: GoogleFonts.poppins(fontSize: 16.sp),
//                   ),
//                   SizedBox(height: 8.h),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<ApplicantsBloc>().add(
//                             FetchApplicants(opportunityId: widget.opportunityId),
//                           );
//                     },
//                     child: const Text('Retry'),
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

//   Widget _buildApplicantsList(ApplicantsResponseModel response) {
//     if (response.items.isEmpty) {
//       return Center(
//         child: Text(
//           'No applicants found',
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
//         return _buildApplicantCard(applicant);
//       },
//     );
//   }

//   Widget _buildApplicantCard(Applicant applicant) {
//     final actionState = context.watch<ApplicantsBloc>().state;
//     final isProcessing = actionState is ApplicantActionLoading &&
//         actionState.applicationId == applicant.applicationId;

//     return Container(
//       margin: EdgeInsets.only(bottom: 12.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//         border: Border.all(color: Colors.grey.shade200),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Profile Picture
//           CircleAvatar(
//             radius: 28.r,
//             backgroundColor: const Color(0xFF1A5F4E).withOpacity(0.1),
//             backgroundImage: applicant.profilePictureUrl != null
//                 ? NetworkImage(applicant.profilePictureUrl!)
//                 : null,
//             child: applicant.profilePictureUrl == null
//                 ? Icon(
//                     Icons.person,
//                     size: 28.sp,
//                     color: const Color(0xFF1A5F4E),
//                   )
//                 : null,
//           ),

//           SizedBox(width: 12.w),

//           // Name and Type
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   applicant.applicantName,
//                   style: GoogleFonts.poppins(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                 ),
//                 Text(
//                   applicant.applicantType,
//                   style: GoogleFonts.poppins(
//                     fontSize: 13.sp,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Action Buttons
//           if (isProcessing)
//             const CircularProgressIndicator()
//           else
//             _buildActionButtons(applicant),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(Applicant applicant) {
//     // If already accepted, show reject button
//     if (applicant.isAccepted) {
//       return _buildRejectButton(applicant, isConvert: true);
//     }

//     // If already rejected, show accept button
//     if (applicant.isRejected) {
//       return _buildAcceptButton(applicant, isConvert: true);
//     }

//     // If pending, show both buttons
//     return Row(
//       children: [
//         _buildAcceptButton(applicant),
//         SizedBox(width: 8.w),
//         _buildRejectButton(applicant),
//       ],
//     );
//   }

//   Widget _buildAcceptButton(Applicant applicant, {bool isConvert = false}) {
//     return ElevatedButton(
//       onPressed: () {
//         context.read<ApplicantsBloc>().add(
//               AcceptApplicant(
//                 applicationId: applicant.applicationId,
//                 status: "accepted",
//               ),
//             );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF1A5F4E),
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         minimumSize: Size(0, 36.h),
//       ),
//       child: Text(
//         isConvert ? 'Accept' : 'Accept',
//         style: GoogleFonts.poppins(
//           fontSize: 13.sp,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildRejectButton(Applicant applicant, {bool isConvert = false}) {

//     return ElevatedButton(
//       onPressed: () {
//         context.read<ApplicantsBloc>().add(
//               RejectApplicant(
//                 applicationId: applicant.applicationId,
//               status  : 'rejected',
//               ),
//             );
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red,
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         minimumSize: Size(0, 36.h),
//       ),
//       child: Text(
//         isConvert ? 'Reject' : 'Reject',
//         style: GoogleFonts.poppins(
//           fontSize: 13.sp,
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
import 'package:sports_in/features/main/opportunity/data/model/applicants_model.dart';
import 'package:sports_in/features/main/opportunity/view_model/bloc/applicants_bloc.dart';

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
  String? _currentStatus; // null = All, 'accepted', 'rejected'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _currentStatus = null; // Start with "All" tab
    
    // Fetch all applicants initially
    context.read<ApplicantsBloc>().add(
          FetchApplicants(opportunityId: widget.opportunityId),
        );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to refresh current tab
  void _refreshCurrentTab() {
    context.read<ApplicantsBloc>().add(
          FetchApplicants(
            opportunityId: widget.opportunityId,
            status: _currentStatus,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Applicants',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1A5F4E),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1A5F4E),
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400),
          onTap: (index) {
            String? status;
            switch (index) {
              case 0:
                status = null; // All
                break;
              case 1:
                status = 'accepted';
                break;
              case 2:
                status = 'rejected';
                break;
            }
            
            // Update current status
            setState(() {
              _currentStatus = status;
            });
            
            // Fetch applicants for selected tab
            context.read<ApplicantsBloc>().add(
                  FetchApplicants(
                    opportunityId: widget.opportunityId,
                    status: status,
                  ),
                );
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Accepted'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: BlocConsumer<ApplicantsBloc, ApplicantsState>(
        listener: (context, state) {
          if (state is ApplicantActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            
            // Refresh the current tab after action success
            _refreshCurrentTab();
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
          if (state is ApplicantsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ApplicantsLoaded) {
            return _buildApplicantsList(state.response);
          }

          if (state is ApplicantsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading applicants',
                    style: GoogleFonts.poppins(fontSize: 16.sp),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      _refreshCurrentTab();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildApplicantsList(ApplicantsResponseModel response) {
    if (response.items.isEmpty) {
      String emptyMessage;
      switch (_currentStatus) {
        case 'accepted':
          emptyMessage = 'No accepted applicants';
          break;
        case 'rejected':
          emptyMessage = 'No rejected applicants';
          break;
        default:
          emptyMessage = 'No applicants found';
      }
      
      return Center(
        child: Text(
          emptyMessage,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: response.items.length,
      itemBuilder: (context, index) {
        final applicant = response.items[index];
        return _buildApplicantCard(applicant);
      },
    );
  }

  Widget _buildApplicantCard(Applicant applicant) {
    final actionState = context.watch<ApplicantsBloc>().state;
    final isProcessing = actionState is ApplicantActionLoading &&
        actionState.applicationId == applicant.applicationId;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 28.r,
            backgroundColor: const Color(0xFF1A5F4E).withOpacity(0.1),
            backgroundImage: applicant.profilePictureUrl != null
                ? NetworkImage(applicant.profilePictureUrl!)
                : null,
            child: applicant.profilePictureUrl == null
                ? Icon(
                    Icons.person,
                    size: 28.sp,
                    color: const Color(0xFF1A5F4E),
                  )
                : null,
          ),

          SizedBox(width: 12.w),

          // Name and Type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicant.applicantName,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  applicant.applicantType,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          if (isProcessing)
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          else
            _buildActionButtons(applicant),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Applicant applicant) {
    // If already accepted, show reject button
    if (applicant.isAccepted) {
      return _buildRejectButton(applicant, isConvert: true);
    }

    // If already rejected, show accept button
    if (applicant.isRejected) {
      return _buildAcceptButton(applicant, isConvert: true);
    }

    // If pending, show both buttons
    return Row(
      children: [
        _buildAcceptButton(applicant),
        SizedBox(width: 8.w),
        _buildRejectButton(applicant),
      ],
    );
  }

  Widget _buildAcceptButton(Applicant applicant, {bool isConvert = false}) {
    return ElevatedButton(
      onPressed: () {
        context.read<ApplicantsBloc>().add(
              AcceptApplicant(
                applicationId: applicant.applicationId,
                status: "accepted",
                opportunityId: widget.opportunityId,
              ),
            );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A5F4E),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        minimumSize: Size(0, 36.h),
      ),
      child: Text(
        'Accept',
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRejectButton(Applicant applicant, {bool isConvert = false}) {
    return ElevatedButton(
      onPressed: () {
        context.read<ApplicantsBloc>().add(
              RejectApplicant(
                applicationId: applicant.applicationId,
                status: 'rejected',
                opportunityId: widget.opportunityId,
              ),
            );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        minimumSize: Size(0, 36.h),
      ),
      child: Text(
        'Reject',
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}