import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/search_result_model.dart';
import '../../view_model/search_bloc.dart';
import '../../view_model/search_event.dart';
import '../../view_model/search_state.dart';
import 'search_results_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>()..add(LoadFilterOptions()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _positionFocusNode = FocusNode();
  final _typeOfPlayFocusNode = FocusNode();
  
  // Filter values
  double _minAge = 18;
  double _maxAge = 50;
  String? _selectedLocation;
  String? _selectedPosition;
  String? _selectedTypeOfPlay;
  String? _selectedLevel;
  UserType? _selectedUserType;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _positionFocusNode.dispose();
    _typeOfPlayFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final filters = SearchFilters(
      minAge: _minAge.toInt(),
      maxAge: _maxAge.toInt(),
      location: _selectedLocation,
      position: _selectedPosition,
      typeOfPlay: _selectedTypeOfPlay,
      level: _selectedLevel,
      userType: _selectedUserType,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SearchBloc>()
            ..add(SearchWithFilters(
              query: _searchController.text,
              filters: filters,
            )),
          child: const SearchResultsScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // appBar: AppBar(
      //   backgroundColor: theme.appBarTheme.backgroundColor,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     strings.search ?? 'Search',
      //     style: theme.textTheme.titleLarge?.copyWith(
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.notifications_outlined, color: theme.iconTheme.color),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: GestureDetector(
        onTap: () {
          // Unfocus any focused text field when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 100.h), // Added bottom padding for nav bar
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
                _performSearch();
              },
              decoration: InputDecoration(
                hintText: strings.search ?? 'Search',
                prefixIcon: Icon(Icons.search, size: 20.sp),
                suffixIcon: IconButton(
                  icon: Icon(Icons.tune, size: 20.sp),
                  onPressed: () {}, // Could show filter sheet
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // // Filter Section
            // _buildFilterHeader(theme, strings),
            // SizedBox(height: 16.h),

            // Age Range
            _buildSectionLabel('Age', theme),
            Row(
              children: [
                Text(
                  '${_minAge.toInt()}',
                  style: theme.textTheme.bodyMedium,
                ),
                Expanded(
                  child: RangeSlider(
                    values: RangeValues(_minAge, _maxAge),
                    min: 18,
                    max: 50,
                    divisions: 32,
                    labels: RangeLabels(
                      _minAge.toInt().toString(),
                      _maxAge.toInt().toString(),
                    ),
                    onChanged: (values) {
                      setState(() {
                        _minAge = values.start;
                        _maxAge = values.end;
                      });
                    },
                  ),
                ),
                Text(
                  '${_maxAge.toInt()}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Location Dropdown
            _buildSectionLabel('Location', theme),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                List<String> locations = [];
                if (state is FilterOptionsLoaded) {
                  locations = state.locations;
                }
                return _buildDropdown(
                  value: _selectedLocation,
                  hint: 'Cairo',
                  items: locations,
                  onChanged: (value) {
                    setState(() => _selectedLocation = value);
                  },
                  theme: theme,
                );
              },
            ),
            SizedBox(height: 16.h),

            // Position
            _buildSectionLabel('Position', theme),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                List<String> positions = [];
                if (state is FilterOptionsLoaded) {
                  positions = state.positions;
                }
                return _buildTextField(
                  value: _selectedPosition,
                  hint: 'Forward',
                  onChanged: (value) {
                    setState(() => _selectedPosition = value);
                  },
                  theme: theme,
                  focusNode: _positionFocusNode,
                );
              },
            ),
            SizedBox(height: 16.h),

            // Type of play
            _buildSectionLabel('Type of play', theme),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                List<String> types = [];
                if (state is FilterOptionsLoaded) {
                  types = state.typesOfPlay;
                }
                return _buildTextField(
                  value: _selectedTypeOfPlay,
                  hint: 'Football',
                  onChanged: (value) {
                    setState(() => _selectedTypeOfPlay = value);
                  },
                  theme: theme,
                  focusNode: _typeOfPlayFocusNode,
                );
              },
            ),
            SizedBox(height: 16.h),

            // Level
            _buildSectionLabel('Level', theme),
            _buildLevelButtons(theme),
            SizedBox(height: 16.h),

            // Type of user
            _buildSectionLabel('Type of user', theme),
            _buildDropdown(
              value: _selectedUserType?.name,
              hint: 'Select type',
              items: UserType.values.map((e) => e.name).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUserType = UserType.values.firstWhere(
                    (e) => e.name == value,
                    orElse: () => UserType.athlete,
                  );
                });
              },
              theme: theme,
            ),
            SizedBox(height: 32.h),

            // Search Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _performSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B2B39),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  strings.search ?? 'Search',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildFilterHeader(ThemeData theme, S strings) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.sp),
          onPressed: () {},
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        SizedBox(width: 8.w),
        Text(
          'Filter',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String? value,
    required String hint,
    required ValueChanged<String> onChanged,
    required ThemeData theme,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildLevelButtons(ThemeData theme) {
    final levels = ['Beginner', 'Intermediate', 'Advanced'];
    
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: levels.map((level) {
        final isSelected = _selectedLevel == level;
        return ChoiceChip(
          label: Text(level),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedLevel = selected ? level : null;
            });
          },
          selectedColor: theme.colorScheme.primary.withOpacity(0.2),
          backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          labelStyle: TextStyle(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13.sp, // Smaller font size
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.2),
          ),
        );
      }).toList(),
    );
  }
}