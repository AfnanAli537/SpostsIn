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
  (id: 6, label: 'gymnastics'),
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<SearchBloc>()
            ..add(SearchWithFilters(
              query: _searchController.text.trim(),
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
    final locationOptions = RegisterLists.locationOptions(strings);
    final sportOptions = RegisterLists.sportNameOptions(strings);
    final hasPositions = RegisterLists.sportHasPositions(_selectedSportLabel);
    final positionOptions = RegisterLists.positionOptions(strings, _selectedSportLabel);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Search bar ──────────────────────────────────────────
              Container(
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
                  onSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                    _performSearch();
                  },
                  decoration: InputDecoration(
                    hintText: strings.search,
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.sp),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : Icon(Icons.tune, color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Age range ───────────────────────────────────────────
              _buildSectionLabel('Age', theme),
              Row(
                children: [
                  Text('${_minAge.toInt()}', style: theme.textTheme.bodyMedium),
                  Expanded(
                    child: RangeSlider(
                      values: RangeValues(_minAge, _maxAge),
                      min: 18,
                      max: 99,
                      divisions: 81,
                      labels: RangeLabels(
                        _minAge.toInt().toString(),
                        _maxAge.toInt().toString(),
                      ),
                      onChanged: (values) => setState(() {
                        _minAge = values.start;
                        _maxAge = values.end;
                      }),
                    ),
                  ),
                  Text('${_maxAge.toInt()}', style: theme.textTheme.bodyMedium),
                ],
              ),
              SizedBox(height: 16.h),

              // ── Location ────────────────────────────────────────────
              AppDropdownOverlay(
                labelText: 'Location',
                value: _selectedLocation,
                options: locationOptions,
                borderColor: theme.colorScheme.outline.withOpacity(0.4),
                onChanged: (val) => setState(() => _selectedLocation = val),
              ),
              SizedBox(height: 16.h),

              // ── User type ───────────────────────────────────────────
              AppDropdownOverlay(
                labelText: 'Type of user',
                value: _selectedUserType?.label,
                options: UserType.values.map((e) => e.label).toList(),
                borderColor: theme.colorScheme.outline.withOpacity(0.4),
                onChanged: (label) => setState(() {
                  _selectedUserType = UserType.values.firstWhere(
                    (e) => e.label == label,
                  );
                }),
              ),
              SizedBox(height: 16.h),

              // ── Sport type ──────────────────────────────────────────
              AppDropdownOverlay(
                labelText: 'Sport',
                value: _selectedSportLabel,
                options: sportOptions,
                borderColor: theme.colorScheme.outline.withOpacity(0.4),
                onChanged: (val) => setState(() {
                  _selectedSportLabel = val;
                  _selectedPosition = null;
                  _positionController.clear();
                }),
              ),
              SizedBox(height: 16.h),

              // ── Position (only for team sports) ─────────────────────
              if (hasPositions) ...[
                AppDropdownOverlay(
                  labelText: 'Position',
                  value: _selectedPosition,
                  options: positionOptions,
                  borderColor: theme.colorScheme.outline.withOpacity(0.4),
                  onChanged: (val) => setState(() => _selectedPosition = val),
                ),
                SizedBox(height: 16.h),
              ],

              // ── Search button ───────────────────────────────────────
              SizedBox(height: 16.h),
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
                    strings.search,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
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
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}