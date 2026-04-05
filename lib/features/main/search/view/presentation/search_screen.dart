import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/features/register/data/data_sources/register_lists.dart';
import 'package:sports_in/features/register/view/presentation/register/widgets/radio_dropdown_overlay.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/search_result_model.dart';
import '../../view_model/search_bloc.dart';
import '../../view_model/search_event.dart';
import 'search_results_screen.dart';

const _sportOptions = [
  (id: 1, label: 'football'),
  (id: 2, label: 'basketball'),
  (id: 3, label: 'volleyball'),
  (id: 4, label: 'handball'),
  (id: 5, label: 'teakwando'),
];

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>(),
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
  final _positionController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  double _minAge = 18;
  double _maxAge = 99;
  String? _selectedLocation;
  String? _selectedSportLabel;
  String? _selectedPosition;
  UserType? _selectedUserType;

  int? get _selectedSportTypeId {
    if (_selectedSportLabel == null) return null;
    final strings = S.of(context);
    final sportNameOptions = RegisterLists.sportNameOptions(strings);
    final index = sportNameOptions.indexOf(_selectedSportLabel!);
    if (index == -1) return null;
    return _sportOptions[index].id;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _positionController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final filters = SearchFilters(
      minAge: _minAge.toInt(),
      maxAge: _maxAge.toInt(),
      location: _selectedLocation,
      sportTypeId: _selectedSportTypeId,
      position: _selectedPosition?.isEmpty == true ? null : _selectedPosition,
      userType: _selectedUserType,
    );

    final query = _searchController.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SearchBloc>()
            ..add(SearchWithFilters(query: query, filters: filters)),
          child: SearchResultsScreen(
            initialQuery: query,
            initialFilters: filters,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);
    final locationOptions = RegisterLists.locationOptions(string);
    final sportOptions = RegisterLists.sportNameOptions(string);
    final hasPositions = RegisterLists.sportHasPositions(_selectedSportLabel);
    final positionOptions = RegisterLists.positionOptions(
      string,
      _selectedSportLabel,
    );

    final clearLabel = string.clear;
    final locationOptionsWithClear = [...locationOptions, clearLabel];
    final userTypeLabels = UserType.values.map((e) => e.label).toList();
    final userTypeOptionsWithClear = [...userTypeLabels, clearLabel];
    final sportOptionsWithClear = [...sportOptions, clearLabel];
    final positionOptionsWithClear = [...positionOptions, clearLabel];

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                // ── Top Search Bar (with clear icon) ─────────────────
                TextField(
                  controller: _searchController,
                  onTapOutside: (event) => _searchFocusNode.unfocus(),
                  onChanged: (_) => setState(() {}), // rebuild to show/hide clear icon
                  decoration: InputDecoration(
                    hintText: string.search,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : const Icon(Icons.tune),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFF2E3E4C)),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Filter Section ───────────────────────────────────
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6F6),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Age Range
                      _buildSectionLabel(string.age, theme),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black12,
                          thumbColor: Colors.black,
                          trackHeight: 2.0,
                        ),
                        child: RangeSlider(
                          values: RangeValues(_minAge, _maxAge),
                          min: 18,
                          max: 99,
                          onChanged: (values) => setState(() {
                            _minAge = values.start;
                            _maxAge = values.end;
                          }),
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("18"), Text("99")],
                      ),
                      SizedBox(height: 16.h),

                      // Location Dropdown (with clear option)
                      AppDropdownOverlay(
                        labelText: string.location,
                        value: _selectedLocation,
                        options: locationOptionsWithClear,
                        borderColor: const Color(0xFF2E3E4C),
                        onChanged: (val) => setState(() {
                          if (val == clearLabel) {
                            _selectedLocation = null;
                          } else {
                            _selectedLocation = val;
                          }
                        }),
                      ),
                      SizedBox(height: 16.h),

                      // User Type Dropdown (with clear option)
                      AppDropdownOverlay(
                        labelText: string.userType,
                        value: _selectedUserType?.label,
                        options: userTypeOptionsWithClear,
                        borderColor: const Color(0xFF2E3E4C),
                        onChanged: (label) => setState(() {
                          if (label == clearLabel) {
                            _selectedUserType = null;
                          } else {
                            _selectedUserType = UserType.values.firstWhere(
                              (e) => e.label == label,
                            );
                          }
                        }),
                      ),
                      SizedBox(height: 16.h),

                      // Sport Dropdown (with clear option)
                      AppDropdownOverlay(
                        labelText: string.sport,
                        value: _selectedSportLabel,
                        options: sportOptionsWithClear,
                        borderColor: const Color(0xFF2E3E4C),
                        onChanged: (val) => setState(() {
                          if (val == clearLabel) {
                            _selectedSportLabel = null;
                            _selectedPosition = null; // also clear position
                          } else {
                            _selectedSportLabel = val;
                            _selectedPosition = null; // reset position on sport change
                          }
                        }),
                      ),
                      SizedBox(height: 16.h),

                      // Position Dropdown (conditional, with clear option)
                      if (hasPositions) ...[
                        AppDropdownOverlay(
                          labelText: string.position,
                          value: _selectedPosition,
                          options: positionOptionsWithClear,
                          borderColor: const Color(0xFF2E3E4C),
                          onChanged: (val) => setState(() {
                            if (val == clearLabel) {
                              _selectedPosition = null;
                            } else {
                              _selectedPosition = val;
                            }
                          }),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      SizedBox(height: 24.h),

                      // Search Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _performSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B2B39),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            string.search,
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
      ),
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
}