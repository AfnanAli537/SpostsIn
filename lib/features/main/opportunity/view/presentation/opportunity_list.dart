// // import 'package:flutter/material.dart';

// // class JobsListScreen extends StatefulWidget {
// //   const JobsListScreen({super.key});

// //   @override
// //   State<JobsListScreen> createState() => _JobsListScreenState();
// // }

// // class _JobsListScreenState extends State<JobsListScreen> {
// //   final TextEditingController _searchController = TextEditingController();
// //   String _selectedSport = '';
// //   String _selectedLocation = '';
// //   String _selectedType = '';
// //   String _searchQuery = '';
// //   bool _isInitialized = false;

// //   final List<Map<String, dynamic>> _allJobs = [
// //     {
// //       'id': '1',
// //       'title': 'Football Coach - Youth Academy',
// //       'organization': 'Elite Youth Football Club',
// //       'sport': 'Football',
// //       'location': 'London',
// //       'type': 'Full-time',
// //       'icon': '⚽',
// //       'color': const Color(0xFF1A5F4E),
// //     },
// //     {
// //       'id': '2',
// //       'title': 'Basketball Analyst',
// //       'organization': 'Pro Basketball League',
// //       'sport': 'Basketball',
// //       'location': 'New York',
// //       'type': 'Part-time',
// //       'icon': '🏀',
// //       'color': const Color(0xFFFF6B35),
// //     },
// //     {
// //       'id': '3',
// //       'title': 'Soccer Scout',
// //       'organization': 'International Soccer Agency',
// //       'sport': 'Football',
// //       'location': 'Madrid',
// //       'type': 'Contract',
// //       'icon': '⚽',
// //       'color': const Color(0xFF1A5F4E),
// //     },
// //     {
// //       'id': '4',
// //       'title': 'Tennis Coach',
// //       'organization': 'Top Tennis Academy',
// //       'sport': 'Tennis',
// //       'location': 'Paris',
// //       'type': 'Full-time',
// //       'icon': '🎾',
// //       'color': const Color(0xFF8B9D83),
// //     },
// //     {
// //       'id': '5',
// //       'title': 'Golf Instructor',
// //       'organization': 'Premier Golf Resort',
// //       'sport': 'Golf',
// //       'location': 'Scotland',
// //       'type': 'Seasonal',
// //       'icon': '⛳',
// //       'color': const Color(0xFF2D5F4F),
// //     },
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _isInitialized = true;
// //   }

// //   @override
// //   void dispose() {
// //     _searchController.dispose();
// //     super.dispose();
// //   }

// //   List<Map<String, dynamic>> get _filteredJobs {
// //     List<Map<String, dynamic>> filtered = _allJobs;

// //     // Apply search filter
// //     if (_searchQuery.isNotEmpty) {
// //       filtered = filtered.where((job) {
// //         return job['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
// //             job['organization'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
// //             job['sport'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
// //       }).toList();
// //     }

// //     // Apply sport filter
// //     if (_selectedSport.isNotEmpty) {
// //       filtered = filtered.where((job) => job['sport'] == _selectedSport).toList();
// //     }

// //     // Apply location filter
// //     if (_selectedLocation.isNotEmpty) {
// //       filtered = filtered.where((job) => job['location'] == _selectedLocation).toList();
// //     }

// //     // Apply type filter
// //     if (_selectedType.isNotEmpty) {
// //       filtered = filtered.where((job) => job['type'] == _selectedType).toList();
// //     }

// //     return filtered;
// //   }

// //   void _clearFilters() {
// //     setState(() {
// //       _selectedSport = '';
// //       _selectedLocation = '';
// //       _selectedType = '';
// //       _searchQuery = '';
// //       _searchController.clear();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (!_isInitialized) {
// //       return const Scaffold(
// //         body: Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //     }

// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F5F5),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             _buildSearchSection(),
// //             _buildFilterSection(),
// //             Expanded(
// //               child: _buildJobsList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildSearchSection() {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(12),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.05),
// //               blurRadius: 10,
// //               offset: const Offset(0, 2),
// //             ),
// //           ],
// //         ),
// //         child: TextField(
// //           controller: _searchController,
// //           onChanged: (value) {
// //             setState(() {
// //               _searchQuery = value;
// //             });
// //           },
// //           decoration: InputDecoration(
// //             hintText: 'Search',
// //             hintStyle: TextStyle(
// //               color: Colors.grey[400],
// //               fontSize: 16,
// //             ),
// //             prefixIcon: Icon(
// //               Icons.search,
// //               color: Colors.grey[400],
// //             ),
// //             suffixIcon: Icon(
// //               Icons.tune,
// //               color: Colors.grey[600],
// //             ),
// //             border: InputBorder.none,
// //             contentPadding: const EdgeInsets.symmetric(
// //               horizontal: 16,
// //               vertical: 14,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFilterSection() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //       child: Row(
// //         children: [
// //           _buildFilterChip(
// //             label: 'Sport',
// //             icon: Icons.sports_soccer,
// //             isSelected: _selectedSport.isNotEmpty,
// //             onTap: () {
// //               _showFilterDialog(
// //                 'Select Sport',
// //                 ['Football', 'Basketball', 'Tennis', 'Golf'],
// //                 (selected) {
// //                   setState(() {
// //                     _selectedSport = selected;
// //                   });
// //                 },
// //               );
// //             },
// //           ),
// //           const SizedBox(width: 8),
// //           _buildFilterChip(
// //             label: 'Location',
// //             icon: Icons.location_on,
// //             isSelected: _selectedLocation.isNotEmpty,
// //             onTap: () {
// //               _showFilterDialog(
// //                 'Select Location',
// //                 ['London', 'New York', 'Madrid', 'Paris', 'Scotland'],
// //                 (selected) {
// //                   setState(() {
// //                     _selectedLocation = selected;
// //                   });
// //                 },
// //               );
// //             },
// //           ),
// //           const SizedBox(width: 8),
// //           _buildFilterChip(
// //             label: 'Type',
// //             icon: Icons.work_outline,
// //             isSelected: _selectedType.isNotEmpty,
// //             onTap: () {
// //               _showFilterDialog(
// //                 'Select Type',
// //                 ['Full-time', 'Part-time', 'Contract', 'Seasonal'],
// //                 (selected) {
// //                   setState(() {
// //                     _selectedType = selected;
// //                   });
// //                 },
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFilterChip({
// //     required String label,
// //     required IconData icon,
// //     required bool isSelected,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// //         decoration: BoxDecoration(
// //           color: isSelected ? const Color(0xFF1A5F4E) : Colors.white,
// //           borderRadius: BorderRadius.circular(20),
// //           border: Border.all(
// //             color: isSelected ? const Color(0xFF1A5F4E) : Colors.grey.shade300,
// //             width: 1,
// //           ),
// //         ),
// //         child: Row(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Icon(
// //               icon,
// //               size: 18,
// //               color: isSelected ? Colors.white : Colors.grey[700],
// //             ),
// //             const SizedBox(width: 6),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 fontSize: 14,
// //                 fontWeight: FontWeight.w500,
// //                 color: isSelected ? Colors.white : Colors.grey[700],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildJobsList() {
// //     final filteredJobs = _filteredJobs;

// //     if (filteredJobs.isEmpty) {
// //       return Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.search_off,
// //               size: 64,
// //               color: Colors.grey[400],
// //             ),
// //             const SizedBox(height: 16),
// //             Text(
// //               'No jobs found',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 color: Colors.grey[600],
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             TextButton(
// //               onPressed: _clearFilters,
// //               child: const Text('Clear filters'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       padding: const EdgeInsets.all(16),
// //       itemCount: filteredJobs.length,
// //       itemBuilder: (context, index) {
// //         final job = filteredJobs[index];
// //         return _buildJobCard(job);
// //       },
// //     );
// //   }

// //   Widget _buildJobCard(Map<String, dynamic> job) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Row(
// //           children: [
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     job['title'],
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.w600,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     job['organization'],
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       color: Colors.grey[600],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Container(
// //               width: 80,
// //               height: 80,
// //               decoration: BoxDecoration(
// //                 color: job['color'],
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   job['icon'],
// //                   style: const TextStyle(fontSize: 40),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showFilterDialog(
// //     String title,
// //     List<String> options,
// //     Function(String) onSelected,
// //   ) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext dialogContext) {
// //         return AlertDialog(
// //           title: Text(title),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: options.map((option) {
// //               return ListTile(
// //                 title: Text(option),
// //                 onTap: () {
// //                   onSelected(option);
// //                   Navigator.pop(dialogContext);
// //                 },
// //               );
// //             }).toList(),
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(dialogContext);
// //               },
// //               child: const Text('Cancel'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }








// import 'package:flutter/material.dart';

// class JobsSection extends StatefulWidget {
//   const JobsSection({super.key});

//   @override
//   State<JobsSection> createState() => _JobsSectionState();
// }

// class _JobsSectionState extends State<JobsSection> {
//   final List<Map<String, dynamic>> _jobs = [
//     {
//       'title': 'Football Coach',
//       'icon': '⚽',
//     }
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           final job = _jobs[index];

//           return Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             child: _buildCard(job),
//           );
//         },
//         childCount: _jobs.length,
//       ),
//     );
//   }

//   Widget _buildCard(Map<String, dynamic> job) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         children: [
//           Text(job['icon'], style: const TextStyle(fontSize: 28)),
//           const SizedBox(width: 10),
//           Expanded(child: Text(job['title'])),
//         ],
//       ),
//     );
//   }
// }
