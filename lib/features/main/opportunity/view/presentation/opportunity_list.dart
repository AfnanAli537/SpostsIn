// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class OpportunitiesContent extends StatefulWidget {
//   const OpportunitiesContent({super.key});

//   @override
//   State<OpportunitiesContent> createState() => _OpportunitiesContentState();
// }

// class _OpportunitiesContentState extends State<OpportunitiesContent> {
//   final TextEditingController _searchController = TextEditingController();
//   String _selectedSport = '';
//   String _selectedLocation = '';
//   String _selectedType = '';
//   String _searchQuery = '';

//   final List<Map<String, dynamic>> _allJobs = [
//     {
//       'id': '1',
//       'title': 'Football Coach - Youth Academy',
//       'organization': 'Elite Youth Football Club',
//       'sport': 'Football',
//       'location': 'London',
//       'type': 'Full-time',
//       'icon': '⚽',
//       'color': const Color(0xFF1A5F4E),
//     },
//     {
//       'id': '2',
//       'title': 'Basketball Analyst',
//       'organization': 'Pro Basketball League',
//       'sport': 'Basketball',
//       'location': 'New York',
//       'type': 'Part-time',
//       'icon': '🏀',
//       'color': const Color(0xFFFF6B35),
//     },
//     {
//       'id': '3',
//       'title': 'Soccer Scout',
//       'organization': 'International Soccer Agency',
//       'sport': 'Football',
//       'location': 'Madrid',
//       'type': 'Contract',
//       'icon': '⚽',
//       'color': const Color(0xFF1A5F4E),
//     },
//     {
//       'id': '4',
//       'title': 'Tennis Coach',
//       'organization': 'Top Tennis Academy',
//       'sport': 'Tennis',
//       'location': 'Paris',
//       'type': 'Full-time',
//       'icon': '🎾',
//       'color': const Color(0xFF8B9D83),
//     },
//     {
//       'id': '5',
//       'title': 'Golf Instructor',
//       'organization': 'Premier Golf Resort',
//       'sport': 'Golf',
//       'location': 'Scotland',
//       'type': 'Seasonal',
//       'icon': '⛳',
//       'color': const Color(0xFF2D5F4F),
//     },
//   ];

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   List<Map<String, dynamic>> get _filteredJobs {
//     List<Map<String, dynamic>> filtered = _allJobs;

//     if (_searchQuery.isNotEmpty) {
//       filtered = filtered.where((job) {
//         return job['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
//             job['organization'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
//             job['sport'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
//       }).toList();
//     }

//     if (_selectedSport.isNotEmpty) {
//       filtered = filtered.where((job) => job['sport'] == _selectedSport).toList();
//     }

//     if (_selectedLocation.isNotEmpty) {
//       filtered = filtered.where((job) => job['location'] == _selectedLocation).toList();
//     }

//     if (_selectedType.isNotEmpty) {
//       filtered = filtered.where((job) => job['type'] == _selectedType).toList();
//     }

//     return filtered;
//   }

//   void _clearFilters() {
//     setState(() {
//       _selectedSport = '';
//       _selectedLocation = '';
//       _selectedType = '';
//       _searchQuery = '';
//       _searchController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredJobs = _filteredJobs;
    
//     return SliverList(
//       delegate: SliverChildListDelegate([
//         // Search Section
//         Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 hintStyle: TextStyle(
//                   color: Colors.grey[400],
//                   fontSize: 16.sp,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: Colors.grey[400],
//                 ),
//                 suffixIcon: Icon(
//                   Icons.tune,
//                   color: Colors.grey[600],
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: 14.h,
//                 ),
//               ),
//             ),
//           ),
//         ),
        
//         // Filter Section
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 _buildFilterChip(
//                   label: 'Sport',
//                   icon: Icons.sports_soccer,
//                   isSelected: _selectedSport.isNotEmpty,
//                   onTap: () {
//                     _showFilterDialog(
//                       'Select Sport',
//                       ['Football', 'Basketball', 'Tennis', 'Golf'],
//                       (selected) {
//                         setState(() {
//                           _selectedSport = selected;
//                         });
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildFilterChip(
//                   label: 'Location',
//                   icon: Icons.location_on,
//                   isSelected: _selectedLocation.isNotEmpty,
//                   onTap: () {
//                     _showFilterDialog(
//                       'Select Location',
//                       ['London', 'New York', 'Madrid', 'Paris', 'Scotland'],
//                       (selected) {
//                         setState(() {
//                           _selectedLocation = selected;
//                         });
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(width: 8.w),
//                 _buildFilterChip(
//                   label: 'Type',
//                   icon: Icons.work_outline,
//                   isSelected: _selectedType.isNotEmpty,
//                   onTap: () {
//                     _showFilterDialog(
//                       'Select Type',
//                       ['Full-time', 'Part-time', 'Contract', 'Seasonal'],
//                       (selected) {
//                         setState(() {
//                           _selectedType = selected;
//                         });
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
        
//         SizedBox(height: 16.h),
        
//         // Jobs List
//         if (filteredJobs.isEmpty)
//           Padding(
//             padding: EdgeInsets.all(40.w),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.search_off,
//                     size: 64.sp,
//                     color: Colors.grey[400],
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     'No jobs found',
//                     style: GoogleFonts.poppins(
//                       fontSize: 18.sp,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   TextButton(
//                     onPressed: _clearFilters,
//                     child: const Text('Clear filters'),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         else
//           ...filteredJobs.map((job) => _buildJobCard(job)).toList(),
        
//         SizedBox(height: 100.h),
//       ]),
//     );
//   }

//   Widget _buildFilterChip({
//     required String label,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF1A5F4E) : Colors.white,
//           borderRadius: BorderRadius.circular(20.r),
//           border: Border.all(
//             color: isSelected ? const Color(0xFF1A5F4E) : Colors.grey.shade300,
//             width: 1,
//           ),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               size: 18.sp,
//               color: isSelected ? Colors.white : Colors.grey[700],
//             ),
//             SizedBox(width: 6.w),
//             Text(
//               label,
//               style: GoogleFonts.poppins(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//                 color: isSelected ? Colors.white : Colors.grey[700],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildJobCard(Map<String, dynamic> job) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     job['title'],
//                     style: GoogleFonts.poppins(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     job['organization'],
//                     style: GoogleFonts.poppins(
//                       fontSize: 14.sp,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 12.w),
//             Container(
//               width: 80.w,
//               height: 80.h,
//               decoration: BoxDecoration(
//                 color: job['color'],
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Center(
//                 child: Text(
//                   job['icon'],
//                   style: TextStyle(fontSize: 40.sp),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showFilterDialog(
//     String title,
//     List<String> options,
//     Function(String) onSelected,
//   ) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: Text(title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: options.map((option) {
//               return ListTile(
//                 title: Text(option),
//                 onTap: () {
//                   onSelected(option);
//                   Navigator.pop(dialogContext);
//                 },
//               );
//             }).toList(),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }














import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/core/constants/color_manager.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/opportunity/view_model/ooprtunity_bloc/opportunity_bloc.dart';

class OpportunitiesContent extends StatefulWidget {
  const OpportunitiesContent({super.key});

  @override
  State<OpportunitiesContent> createState() => _OpportunitiesContentState();
}

class _OpportunitiesContentState extends State<OpportunitiesContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  final Map<String, int> _sportTypes = {
    'Football': 1,
    'Basketball': 2,
    'Volleyball': 3,
    'Handball': 4,
    'Teakwando': 5,
  };
    

  @override
  void initState() {
    super.initState();
    context.read<OpportunityBloc>().add(const FetchOpportunities(isRefresh: true));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<OpportunityBloc>().state;
      if (state is OpportunityLoaded && state.hasNextPage) {
        context.read<OpportunityBloc>().add(const FetchOpportunities());
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
            const SnackBar(
              content: Text('Opportunity created successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        if (state is OpportunityApplied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Application submitted successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildListDelegate([
            // Search Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : Icon(
                            Icons.tune,
                            color: Colors.grey[600],
                          ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
            ),
            
            // Filter Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: state is OpportunityLoaded && state.sportName != null
                          ? state.sportName!
                          : 'Sport',
                      // icon: Icons.sports_soccer,
                      isSelected: state is OpportunityLoaded && state.sportTypeId != null,
                      onTap: () {
                        _showFilterDialog(
                          'Select Sport',
                          _sportTypes.keys.toList(),
                          (selected) {
                            context.read<OpportunityBloc>().add(
                                  UpdateSportFilter(
                                    sportTypeId: _sportTypes[selected],
                                    sportName: selected,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    if (state is OpportunityLoaded &&
                        (state.sportTypeId != null || state.searchTerm != null))
                      _buildFilterChip(
                        label: 'Clear',
                        icon: Icons.clear_all,
                        isSelected: false,
                        onTap: _clearFilters,
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Content based on state
            if (state is OpportunityLoading)
              _buildLoadingState()
            else if (state is OpportunityLoaded)
              ..._buildOpportunitiesList(state)
            else if (state is OpportunityError)
              _buildErrorState(state.message)
            else
              _buildInitialState(),
            
            SizedBox(height: 100.h),
          ]),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Text(
          'Loading opportunities...',
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOpportunitiesList(OpportunityLoaded state) {
    if (state.opportunities.isEmpty) {
      return [_buildEmptyState()];
    }

    final widgets = <Widget>[];
    
    // Add all opportunity cards
    for (var opportunity in state.opportunities) {
      widgets.add(_buildJobCard(opportunity));
    }
    
    // Add loading more indicator
    if (state.hasNextPage) {
      widgets.add(
        Padding(
          padding: EdgeInsets.all(16.h),
          child: Center(
            child: CircularProgressIndicator(
              color: const Color(0xFF1A5F4E),
            ),
          ),
        ),
      );
    }
    
    return widgets;
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No Opportunities found',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: _clearFilters,
              child: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () {
                context.read<OpportunityBloc>().add(
                      const FetchOpportunities(isRefresh: true),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

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
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
        
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
       icon!=null? Icons.clear: Icons.tune,
              size: 18.sp,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(OpportunityModel opportunity) {
    final defaultColor = ColorManager.lightPrimary;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Fetch opportunity details
            context.read<OpportunityBloc>().add(
                  FetchOpportunityDetails(opportunityId: opportunity.id),
                );
            
            // TODO: Navigate to details page
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => BlocProvider.value(
            //       value: context.read<OpportunityBloc>(),
            //       child: OpportunityDetailsPage(opportunity: opportunity),
            //     ),
            //   ),
            // );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
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
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.sp,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4.w),
                          Text(
                           "Since ${_formatDate(opportunity.createdAt)}",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.grey[500],
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
                    color: opportunity.mediaUrl != null ? null : defaultColor,
                    borderRadius: BorderRadius.circular(12.r),
                    image: opportunity.mediaUrl != null
                        ? DecorationImage(
                            image: NetworkImage(opportunity.mediaUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: opportunity.mediaUrl == null
                      ? Center(
                          child: Icon(
                           Icons.event_available_outlined,
                           size: 40.sp,
                        color: Theme.of(context).colorScheme.surface,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(
    String title,
    List<String> options,
    Function(String) onSelected,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return ListTile(
  contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
  title: Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h), // 👈 space inside
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Expanded(
      child: Text(
        option,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ),
  onTap: () {
    onSelected(option);
    Navigator.pop(dialogContext);
  },
);

              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}