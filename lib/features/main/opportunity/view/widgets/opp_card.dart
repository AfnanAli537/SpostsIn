// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // Widget buildOpportunityPreviewCard() {
// //   return Card(
// //     margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
// //     shape: RoundedRectangleBorder(
// //       borderRadius: BorderRadius.circular(16.r),
// //     ),
// //     elevation: 2,
// //     shadowColor: Colors.black.withOpacity(0.2),
// //     child: Padding(
// //       padding: EdgeInsets.all(12.w),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(12.r),
// //             child: Image.network(
// //               "https://placeholder.com/100", 
// //               width: 100.w,
// //               height: 120.h,
// //               fit: BoxFit.cover,
// //               errorBuilder: (context, error, stackTrace) => Container(
// //                 width: 100.w,
// //                 height: 120.h,
// //                 color: Colors.grey[200],
// //                 child: const Icon(Icons.image),
// //               ),
// //             ),
// //           ),
// //           SizedBox(width: 16.w),
// //           Expanded(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   "Summer Training Camp",
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 16.sp,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.grey[800],
// //                   ),
// //                 ),
// //                 SizedBox(height: 4.h),
// //                 Text(
// //                   "End: April 20",
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 14.sp,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //                 Text(
// //                   "Location: City Arena",
// //                   style: GoogleFonts.poppins(
// //                     fontSize: 14.sp,
// //                     color: Colors.grey[600],
// //                   ),
// //                 ),
// //                 SizedBox(height: 12.h),
// //                 SizedBox(
// //                   width: double.infinity, 
// //                   child: ElevatedButton(
// //                     onPressed: () {},
// //                     child: Text(
// //                       "Apply",
// //                       style: GoogleFonts.poppins(
// //                         fontSize: 15.sp,
// //                         color: Colors.black,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }






// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sports_in/features/main/opportunity/view/presentation/details.dart';
// import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';
// import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';

// class LatestOpportunityCard extends StatefulWidget {
//   const LatestOpportunityCard({super.key});

//   @override
//   State<LatestOpportunityCard> createState() => _LatestOpportunityCardState();
// }

// class _LatestOpportunityCardState extends State<LatestOpportunityCard> {
//   @override
//   void initState() {
//     super.initState();
//     // Dispatch fetch event when widget loads
//     Future.microtask(() {
//       context.read<OpportunityBloc>().add(const FetchOpportunities(isRefresh: true));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OpportunityBloc, OpportunityState>(
//       builder: (context, state) {
//         if (state is OpportunityLoading) {
//           return Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 20.h),
//               child: const CircularProgressIndicator(),
//             ),
//           );
//         }

//         if (state is OpportunityError) {
//           return Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Center(
//               child: Text(
//                 state.message,
//                 style: GoogleFonts.poppins(
//                   fontSize: 14.sp,
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           );
//         }

//         if (state is OpportunityLoaded) {
//           if (state.opportunities.isEmpty) {
//             return Padding(
//               padding: EdgeInsets.all(16.w),
//               child: Center(
//                 child: Text(
//                   "No opportunities available",
//                   style: GoogleFonts.poppins(fontSize: 14.sp),
//                 ),
//               ),
//             );
//           }

//           final OpportunityModel latest = state.opportunities.first; // first = latest

//           return InkWell(
//             onTap: () =>    Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => BlocProvider.value(
//                   value: context.read<OpportunityBloc>(),
//                   child: OpportunityDetailsPage(opportunityId: latest.id),
//                 ),
//               ),
//             ),
//             child: Card(
//               margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//               elevation: 2,
//               shadowColor: Colors.black.withOpacity(0.2),
//               child: Padding(
//                 padding: EdgeInsets.all(12.w),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12.r),
//                       child: ClipRRect(
//               borderRadius: BorderRadius.circular(12.r),
//               child: latest.mediaUrl != null && latest.mediaUrl!.isNotEmpty
//                   ? Image.network(
//             latest.mediaUrl!,
//             width: 100.w,
//             height: 120.h,
//             fit: BoxFit.cover,
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return Container(
//                 width: 100.w,
//                 height: 120.h,
//                 color: Colors.grey[200],
//                 child: const Center(
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 ),
//               );
//             },
//             errorBuilder: (context, error, stackTrace) => _buildNoImagePlaceholder(),
//                     )
//                   // : _buildNoImagePlaceholder(),
//                   :  Container(
//                   width: 100.w,
//                   height: 110.h,
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primary,
//                     borderRadius: BorderRadius.circular(12.r),
//                   ),
//                   child: 
//                        Center(
//                           child: Icon(
//                            Icons.event_available_outlined,
//                            size: 50.sp,
//                         color: Theme.of(context).colorScheme.surface,
//                           ),
//                         )
                  
//                 ),
         
//             ),
//                     ),
//                     SizedBox(width: 16.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             latest.title ,
//                             style: GoogleFonts.poppins(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey[800],
//                             ),
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             latest.publisherName ,
//                             style: GoogleFonts.poppins(
//                               fontSize: 14.sp,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 12.h),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 context.read<OpportunityBloc>().add(
//                                     ApplyToOpportunity(opportunityId: latest.id));
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 foregroundColor:  Theme.of(context).colorScheme.surface,
//                               ),
//                               child: Text(
//                                 "Apply",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 15.sp,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         return const SizedBox.shrink();
//       },
//     );
//   }
// }


// // Helper widget for placeholder
// Widget _buildNoImagePlaceholder() {
//   return Container(
//     width: 100.w,
//     height: 120.h,
//     color: Colors.grey[200],
//     child: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.image_not_supported, size: 30.sp, color: Colors.grey[500]),
//           SizedBox(height: 4.h),
//           Text(
//             "No Image",
//             style: GoogleFonts.poppins(
//               fontSize: 12.sp,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }









import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sports_in/features/main/opportunity/data/model/details_model.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/details.dart';
import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';

class LatestOpportunityCard extends StatefulWidget {
  const LatestOpportunityCard({super.key});

  @override
  State<LatestOpportunityCard> createState() => _LatestOpportunityCardState();
}

class _LatestOpportunityCardState extends State<LatestOpportunityCard> {
  @override
  void initState() {
    super.initState();
    // Dispatch fetch event when widget loads
    Future.microtask(() {
      context.read<OpportunityBloc>().add(const FetchOpportunities(isRefresh: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpportunityBloc, OpportunityState>(
      builder: (context, state) {
        if (state is OpportunityLoading) {
          return _buildShimmerLoading();
        }

        if (state is OpportunityError) {
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Center(
              child: Text(
                state.message,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (state is OpportunityLoaded) {
          if (state.opportunities.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  "No opportunities available",
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                ),
              ),
            );
          }
          final OpportunityModel latest = state.opportunities.first;

          return InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<OpportunityBloc>(),
                  child: OpportunityDetailsPage(opportunityId: latest.id),
                ),
              ),
            ),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 2,
              shadowColor: Colors.black.withOpacity(0.2),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: latest.mediaUrl != null && latest.mediaUrl!.isNotEmpty
                          ? Image.network(
                              latest.mediaUrl!,
                              width: 100.w,
                              height: 120.h,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 100.w,
                                  height: 120.h,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildNoImagePlaceholder(context),
                            )
                          : Container(
                              width: 100.w,
                              height: 120.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.event_available_outlined,
                                  size: 50.sp,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            latest.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            latest.publisherName,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                
                              onPressed: () {
                           
                                context.read<OpportunityBloc>().add(
                                      ApplyToOpportunity(opportunityId: latest.id),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.surface,
                              ),
                              child: Text(
                                "Apply",
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 100.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      width: double.infinity,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Subtitle placeholder
                    Container(
                      width: 120.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Button placeholder
                    Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoImagePlaceholder(BuildContext context) {
    return Container(
      width: 100.w,
      height: 120.h,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 30.sp, color: Colors.grey[500]),
            SizedBox(height: 4.h),
            Text(
              "No Image",
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}