import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/main/search/view/widgets/search_result_card.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/search_result_model.dart';
import '../../view_model/search_bloc.dart';
import '../../view_model/search_event.dart';
import '../../view_model/search_state.dart';

const _sportOptions = [
  (id: 1, label: 'football'),
  (id: 2, label: 'basketball'),
  (id: 3, label: 'volleyball'),
  (id: 4, label: 'handball'),
  (id: 5, label: 'teakwando'),
  (id: 6, label: 'gymnastics'),
];

class SearchResultsScreen extends StatefulWidget {
  final String? initialQuery;
  final SearchFilters? initialFilters;

  const SearchResultsScreen({super.key,this.initialQuery, this.initialFilters});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final TextEditingController _searchController;

  String? _selectedLocation;
  String? _selectedSportLabel;
  String? _selectedPosition;
  UserType? _selectedUserType;
  double _minAge = 18;
  double _maxAge = 99;

  int? get _selectedSportTypeId {
    if (_selectedSportLabel == null) return null;
    final strings = S.of(context);
    final sportNameOptions = RegisterLists.sportNameOptions(strings);
    final index = sportNameOptions.indexOf(_selectedSportLabel!);
    if (index == -1) return null;
    return _sportOptions[index].id;
  }

  SearchFilters get _currentFilters => SearchFilters(
        minAge: _minAge.toInt(),
        maxAge: _maxAge.toInt(),
        location: _selectedLocation,
        sportTypeId: _selectedSportTypeId,
        position: _selectedPosition?.isEmpty == true ? null : _selectedPosition,
        userType: _selectedUserType,
      );

  @override
  void initState() {
    super.initState();

    // Initialize filters from passed initialFilters
    final filters = widget.initialFilters;
    if (filters != null) {
      _minAge = (filters.minAge ?? 18).toDouble();
      _maxAge = (filters.maxAge ?? 99).toDouble();
      _selectedLocation = filters.location;
      _selectedUserType = filters.userType;
      _selectedPosition = filters.position;
      if (filters.sportTypeId != null) {
        final match = _sportOptions
            .where((s) => s.id == filters.sportTypeId)
            .firstOrNull;
        if (match != null) {
          final idx = _sportOptions.indexOf(match);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              final strings = S.of(context);
              final sportNames = RegisterLists.sportNameOptions(strings);
              if (idx < sportNames.length) {
                setState(() => _selectedSportLabel = sportNames[idx]);
              }
            }
          });
        }
      }
    }
String query = widget.initialQuery ?? '';
  if (query.isEmpty) {
    final state = context.read<SearchBloc>().state;
    if (state is SearchLoaded) {query = state.query;}
    else if (state is SearchEmpty) {query = state.query;}
  }
  _searchController = TextEditingController(text: query);
    // // Initialize query from bloc state
    // final state = context.read<SearchBloc>().state;
    // String initialQuery = '';
    // if (state is SearchLoaded) {
    //   initialQuery = state.query;
    // } else if (state is SearchEmpty) {
    //   initialQuery = state.query;
    // }
    // _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToUserProfile(String userId) {
    Navigator.pushNamed(context, AppRoutes.userProfile, arguments: userId);
  }

  void _performSearch(String query) {
    context.read<SearchBloc>().add(SearchWithFilters(
          query: query,
          filters: _currentFilters,
        ));
  }

  void _applyFilters() {
    context.read<SearchBloc>().add(SearchWithFilters(
          query: _searchController.text,
          filters: _currentFilters,
        ));
  }

  void _clearFilters() {
    setState(() {
      _selectedLocation = null;
      _selectedSportLabel = null;
      _selectedPosition = null;
      _selectedUserType = null;
      _minAge = 18;
      _maxAge = 99;
    });
    context.read<SearchBloc>().add(SearchWithFilters(
          query: _searchController.text,
          filters: null,
        ));
  }

  void _showOptionsDialog({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelect,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
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
              children: options.map((opt) {
                final isSelected = opt == selected;
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  title: Card(
                    elevation: isSelected ? 4 : 1,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 10.h),
                      child: Text(
                        opt,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer
                              : null,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    onSelect(opt);
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);
    final locationOptions = RegisterLists.locationOptions(strings);
    final sportOptions = RegisterLists.sportNameOptions(strings);
    final hasPositions = RegisterLists.sportHasPositions(_selectedSportLabel);
    final positionOptions =
        RegisterLists.positionOptions(strings, _selectedSportLabel);
    final hasAnyFilter = _selectedLocation != null ||
        _selectedSportLabel != null ||
        _selectedUserType != null ||
        _selectedPosition != null;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          strings.searchResults,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                color: theme.iconTheme.color),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search bar ────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
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
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onSubmitted: _performSearch,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle:
                      TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600]),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                            setState(() {});
                          },
                        )
                      : Icon(Icons.tune, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 14.h),
                ),
              ),
            ),
          ),

          // ── Filter chips ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Location
                  _buildFilterChip(
                    label: _selectedLocation ?? 'Location',
                    isSelected: _selectedLocation != null,
                    theme: theme,
                    onTap: () => _showOptionsDialog(
                      title: 'Location',
                      options: locationOptions,
                      selected: _selectedLocation,
                      onSelect: (val) {
                        setState(() => _selectedLocation = val);
                        _applyFilters();
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // User type
                  _buildFilterChip(
                    label: _selectedUserType?.label ?? 'User Type',
                    isSelected: _selectedUserType != null,
                    theme: theme,
                    onTap: () => _showOptionsDialog(
                      title: 'User Type',
                      options:
                          UserType.values.map((e) => e.label).toList(),
                      selected: _selectedUserType?.label,
                      onSelect: (val) {
                        setState(() {
                          _selectedUserType = UserType.values
                              .firstWhere((e) => e.label == val);
                        });
                        _applyFilters();
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Sport
                  _buildFilterChip(
                    label: _selectedSportLabel ?? 'Sport',
                    isSelected: _selectedSportLabel != null,
                    theme: theme,
                    onTap: () => _showOptionsDialog(
                      title: 'Sport',
                      options: sportOptions,
                      selected: _selectedSportLabel,
                      onSelect: (val) {
                        setState(() {
                          _selectedSportLabel = val;
                          _selectedPosition = null;
                        });
                        _applyFilters();
                      },
                    ),
                  ),

                  // Position (only if sport has positions)
                  if (hasPositions) ...[
                    SizedBox(width: 8.w),
                    _buildFilterChip(
                      label: _selectedPosition ?? 'Position',
                      isSelected: _selectedPosition != null,
                      theme: theme,
                      onTap: () => _showOptionsDialog(
                        title: 'Position',
                        options: positionOptions,
                        selected: _selectedPosition,
                        onSelect: (val) {
                          setState(() => _selectedPosition = val);
                          _applyFilters();
                        },
                      ),
                    ),
                  ],

                  // Clear all
                  if (hasAnyFilter) ...[
                    SizedBox(width: 8.w),
                    _buildFilterChip(
                      label: 'Clear',
                      icon: Icons.clear_all,
                      isSelected: false,
                      theme: theme,
                      onTap: _clearFilters,
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // ── Results ───────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64.sp, color: theme.colorScheme.error),
                        SizedBox(height: 16.h),
                        Text(state.message,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }

                if (state is SearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64.sp,
                            color: theme.colorScheme.onSurfaceVariant),
                        SizedBox(height: 16.h),
                        Text(
                          strings.noResultsFound,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          strings.tryDifferentSearch,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchLoaded) {
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 8.h),
                    itemCount: state.results.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final result = state.results[index];
                      return SearchResultCard(
                        result: result,
                        onTap: () =>
                            _navigateToUserProfile(result.id),
                      );
                    },
                  );
                }

                return Center(
                  child: Text(
                    strings.startSearching,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
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
                  ? theme.colorScheme.surface
                  : theme.colorScheme.onSurface,
            ),
            SizedBox(width: 6.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.surface
                      : theme.colorScheme.onSurface,
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
}