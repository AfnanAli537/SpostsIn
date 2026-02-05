// // import 'package:flutter/material.dart';

// // class OpportunitiesScreen extends StatefulWidget {
// //   const OpportunitiesScreen({super.key});

// //   @override
// //   State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
// // }

// // class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
// //   String _selectedFilter = '';
// //   bool _isInitialized = false;

// //   final List<Map<String, dynamic>> _allOpportunities = [
// //     {
// //       'id': '1',
// //       'title': 'Summer Training Camp',
// //       'location': 'California',
// //       'duration': 'June 15 - Aug 30',
// //       'image': '🏕️',
// //     },
// //     {
// //       'id': '2',
// //       'title': 'Youth Basketball League',
// //       'location': 'New York',
// //       'duration': 'Sep 1 - Dec 15',
// //       'image': '🏀',
// //     },
// //     {
// //       'id': '3',
// //       'title': 'Soccer Academy',
// //       'location': 'Texas',
// //       'duration': 'Year Round',
// //       'image': '⚽',
// //     },
// //     {
// //       'id': '4',
// //       'title': 'Tennis Workshop',
// //       'location': 'Florida',
// //       'duration': 'March 1 - May 30',
// //       'image': '🎾',
// //     },
// //     {
// //       'id': '5',
// //       'title': 'Golf Training Program',
// //       'location': 'Arizona',
// //       'duration': 'Jan 10 - Apr 20',
// //       'image': '⛳',
// //     },
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _isInitialized = true;
// //   }

// //   List<Map<String, dynamic>> get _filteredOpportunities {
// //     if (_selectedFilter.isEmpty) {
// //       return _allOpportunities;
// //     }

// //     return _allOpportunities.where((opportunity) {
// //       return opportunity['title'].toString().toLowerCase().contains(_selectedFilter.toLowerCase()) ||
// //           opportunity['location'].toString().toLowerCase().contains(_selectedFilter.toLowerCase()) ||
// //           opportunity['duration'].toString().toLowerCase().contains(_selectedFilter.toLowerCase());
// //     }).toList();
// //   }

// //   void _clearFilter() {
// //     setState(() {
// //       _selectedFilter = '';
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
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         title: const Text(
// //           'Opportunities',
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontSize: 20,
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: _showFilterOptions,
// //             child: const Row(
// //               children: [
// //                 Text(
// //                   'Filter',
// //                   style: TextStyle(
// //                     color: Color(0xFF1A5F4E),
// //                     fontSize: 14,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //                 SizedBox(width: 4),
// //                 Icon(
// //                   Icons.keyboard_arrow_down,
// //                   color: Color(0xFF1A5F4E),
// //                   size: 20,
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //         ],
// //       ),
// //       body: SafeArea(
// //         child: _buildOpportunitiesList(),
// //       ),
// //     );
// //   }

// //   Widget _buildOpportunitiesList() {
// //     final filteredOpportunities = _filteredOpportunities;

// //     if (filteredOpportunities.isEmpty) {
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
// //               'No opportunities found',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 color: Colors.grey[600],
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //             const SizedBox(height: 8),
// //             TextButton(
// //               onPressed: _clearFilter,
// //               child: const Text('Clear filter'),
// //             ),
// //           ],
// //         ),
// //       );
// //     }

// //     return ListView.builder(
// //       padding: const EdgeInsets.all(16),
// //       itemCount: filteredOpportunities.length,
// //       itemBuilder: (context, index) {
// //         final opportunity = filteredOpportunities[index];
// //         return _buildOpportunityCard(opportunity);
// //       },
// //     );
// //   }

// //   Widget _buildOpportunityCard(Map<String, dynamic> opportunity) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(12.0),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 50,
// //               height: 50,
// //               decoration: BoxDecoration(
// //                 color: const Color(0xFFF5F5F5),
// //                 borderRadius: BorderRadius.circular(8),
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   opportunity['image'],
// //                   style: const TextStyle(fontSize: 28),
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     opportunity['title'],
// //                     style: const TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w600,
// //                       color: Colors.black,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 4),
// //                   Text(
// //                     opportunity['location'],
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: Colors.grey[600],
// //                     ),
// //                   ),
// //                   const SizedBox(height: 2),
// //                   Text(
// //                     opportunity['duration'],
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       color: Colors.grey[500],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   void _showFilterOptions() {
// //     showModalBottomSheet(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(
// //           top: Radius.circular(20),
// //         ),
// //       ),
// //       builder: (BuildContext sheetContext) {
// //         return Container(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const Text(
// //                 'Filter Opportunities',
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.w600,
// //                 ),
// //               ),
// //               const SizedBox(height: 20),
// //               ListTile(
// //                 leading: const Icon(Icons.calendar_today),
// //                 title: const Text('By Duration'),
// //                 onTap: () {
// //                   setState(() {
// //                     _selectedFilter = 'duration';
// //                   });
// //                   Navigator.pop(sheetContext);
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.location_on),
// //                 title: const Text('By Location'),
// //                 onTap: () {
// //                   setState(() {
// //                     _selectedFilter = 'location';
// //                   });
// //                   Navigator.pop(sheetContext);
// //                 },
// //               ),
// //               ListTile(
// //                 leading: const Icon(Icons.sports),
// //                 title: const Text('By Type'),
// //                 onTap: () {
// //                   setState(() {
// //                     _selectedFilter = 'type';
// //                   });
// //                   Navigator.pop(sheetContext);
// //                 },
// //               ),
// //               const Divider(),
// //               ListTile(
// //                 leading: const Icon(Icons.clear_all),
// //                 title: const Text('Clear Filter'),
// //                 onTap: () {
// //                   _clearFilter();
// //                   Navigator.pop(sheetContext);
// //                 },
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }






// import 'package:flutter/material.dart';

// class OpportunitiesSection extends StatefulWidget {
//   const OpportunitiesSection({super.key});

//   @override
//   State<OpportunitiesSection> createState() =>
//       _OpportunitiesSectionState();
// }

// class _OpportunitiesSectionState extends State<OpportunitiesSection> {
//   String _selectedFilter = '';

//   final List<Map<String, dynamic>> _allOpportunities = [
//     {
//       'id': '1',
//       'title': 'Summer Training Camp',
//       'location': 'California',
//       'duration': 'June 15 - Aug 30',
//       'image': '🏕️',
//     },
//   ];

//   List<Map<String, dynamic>> get _filtered =>
//       _selectedFilter.isEmpty
//           ? _allOpportunities
//           : _allOpportunities;

//   @override
//   Widget build(BuildContext context) {
//     final data = _filtered;

//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (context, index) {
//           final item = data[index];

//           return Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//             child: _buildCard(item),
//           );
//         },
//         childCount: data.length,
//       ),
//     );
//   }

//   Widget _buildCard(Map<String, dynamic> opportunity) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Text(opportunity['image'], style: const TextStyle(fontSize: 26)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(opportunity['title']),
//           ),
//         ],
//       ),
//     );
//   }
// }
