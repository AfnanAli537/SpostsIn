import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/widgets/custom_elevated_button.dart';
import 'package:sports_in/features/main/video_analysis/view_model/video_analysis_bloc/analysis_bloc.dart';
import 'package:sports_in/features/main/video_analysis/view/widgets/analysis_list_item_card.dart';
import 'package:sports_in/features/main/video_analysis/view/presentation/analysis_report_screen.dart';
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

// ─────────────────────────────────────────────────────────────────────────────
// Root — provides both blocs then shows the tabbed view
// ─────────────────────────────────────────────────────────────────────────────

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SearchBloc>()),
        BlocProvider(create: (_) => getIt<AnalysisBloc>()),
      ],
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Tab bar ────────────────────────────────────────────────
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              decoration: BoxDecoration(
                color: theme.colorScheme.onError.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: theme.colorScheme.onPrimary,
                unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(
                  0.6,
                ),
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_rounded, size: 16.sp),
                        SizedBox(width: 6.w),
                        Text(string.people),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sports_soccer_rounded, size: 16.sp),
                        SizedBox(width: 6.w),
                        Text(string.videoAnalysis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [_VideoAnalysisSearchTab(), _PeopleSearchTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1 — People search (existing logic, unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _PeopleSearchTab extends StatefulWidget {
  const _PeopleSearchTab();

  @override
  State<_PeopleSearchTab> createState() => _PeopleSearchTabState();
}

class _PeopleSearchTabState extends State<_PeopleSearchTab> {
  final _searchController = TextEditingController();
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

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onTapOutside: (_) => _searchFocusNode.unfocus(),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: string.searchByUserName,
                hintStyle: TextStyle(color: theme.hintColor),
                prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: theme.iconTheme.color),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : Icon(Icons.tune, color: theme.iconTheme.color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: theme.primaryColor, width: 2),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.onError.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label(string.age, theme),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: theme.colorScheme.primary,
                      inactiveTrackColor: theme.disabledColor,
                      thumbColor: theme.colorScheme.primary,
                      trackHeight: 2.0,
                      overlayColor: theme.primaryColor.withOpacity(0.2),
                      showValueIndicator: ShowValueIndicator.always,
                      rangeThumbShape: const RoundRangeSliderThumbShape(
                        enabledThumbRadius: 12,
                        pressedElevation: 4,
                        disabledThumbRadius: 12,
                      ),
                    ),
                    child: RangeSlider(
                      values: RangeValues(_minAge, _maxAge),
                      min: 18,
                      max: 99,
                      onChanged: (v) => setState(() {
                        _minAge = v.start;
                        _maxAge = v.end;
                      }),
                      labels: RangeLabels(
                        _minAge.round().toString(),
                        _maxAge.round().toString(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '18',
                        style: TextStyle(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                      Text(
                        '99',
                        style: TextStyle(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AppDropdownOverlay(
                    labelText: string.location,
                    value: _selectedLocation,
                    options: locationOptionsWithClear,
                    borderColor: theme.dividerColor,
                    onChanged: (val) => setState(() {
                      _selectedLocation = val == clearLabel ? null : val;
                    }),
                  ),
                  SizedBox(height: 16.h),
                  AppDropdownOverlay(
                    labelText: string.userType,
                    value: _selectedUserType?.label,
                    options: userTypeOptionsWithClear,
                    borderColor: theme.dividerColor,
                    onChanged: (label) => setState(() {
                      _selectedUserType = label == clearLabel
                          ? null
                          : UserType.values.firstWhere((e) => e.label == label);
                    }),
                  ),
                  SizedBox(height: 16.h),
                  AppDropdownOverlay(
                    labelText: string.sport,
                    value: _selectedSportLabel,
                    options: sportOptionsWithClear,
                    borderColor: theme.dividerColor,
                    onChanged: (val) => setState(() {
                      if (val == clearLabel) {
                        _selectedSportLabel = null;
                        _selectedPosition = null;
                      } else {
                        _selectedSportLabel = val;
                        _selectedPosition = null;
                      }
                    }),
                  ),
                  SizedBox(height: 16.h),
                  if (hasPositions) ...[
                    AppDropdownOverlay(
                      labelText: string.position,
                      value: _selectedPosition,
                      options: positionOptionsWithClear,
                      borderColor: theme.dividerColor,
                      onChanged: (val) => setState(() {
                        _selectedPosition = val == clearLabel ? null : val;
                      }),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  SizedBox(height: 24.h),
                  CustomElevatedButton(
                    text: string.search,
                    onPressed: _performSearch,
                    enabled: true,
                    isLoading: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, ThemeData theme) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      text,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2 — Video Analysis public search → /api/Analysis/search/public
// ─────────────────────────────────────────────────────────────────────────────

class _VideoAnalysisSearchTab extends StatefulWidget {
  const _VideoAnalysisSearchTab();

  @override
  State<_VideoAnalysisSearchTab> createState() =>
      _VideoAnalysisSearchTabState();
}

class _VideoAnalysisSearchTabState extends State<_VideoAnalysisSearchTab> {
  final _searchController = TextEditingController();
  String? _selectedType;

  static const _types = ['Goalkeeper', 'Passing', 'Dribbling', 'Match'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    context.read<AnalysisBloc>().add(
      LoadAnalysisSearch(
        mode: AnalysisSearchMode.public,
        term: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        type: _selectedType,
      ),
    );
  }

  void _selectType(String? type) {
    if (_selectedType == type) return;
    setState(() => _selectedType = type);
    _search();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

    return Column(
      children: [
        // ── Search bar ─────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: TextField(
            controller: _searchController,
            onSubmitted: (_) => _search(),
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: strings.searchByPlayerName,
              hintStyle: TextStyle(color: theme.hintColor),
              prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: theme.iconTheme.color),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                        _search();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
            ),
          ),
        ),

        // ── Type filter chips ──────────────────────────────────────
        _TypeFilterRow(
          selected: _selectedType,
          types: _types,
          onSelect: _selectType,
          theme: theme,
        ),

        // ── Results ────────────────────────────────────────────────
        Expanded(
          child: BlocBuilder<AnalysisBloc, AnalysisState>(
            builder: (context, state) {
              if (state is AnalysisInitial) {
                return _buildHint(theme, strings);
              }
              if (state is AnalysisSearchLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AnalysisSearchError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48.sp,
                        color: theme.colorScheme.error,
                      ),
                      SizedBox(height: 12.h),
                      Text(state.message, textAlign: TextAlign.center),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: _search,
                        child: Text(strings.retry),
                      ),
                    ],
                  ),
                );
              }
              if (state is AnalysisSearchLoaded) {
                if (state.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off_outlined,
                          size: 56.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.25),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          strings.noAnalysesFound,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 4.h, bottom: 24.h),
                  itemCount:
                      state.items.length +
                      (state is AnalysisSearchLoadingMore ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == state.items.length) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.h),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                    final item = state.items[i];
                    return AnalysisListItemCard(
                      item: item,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) =>
                                getIt<AnalysisBloc>()
                                  ..add(LoadAnalysisReport(item.id)),
                            child: AnalysisReportScreen(analysisId: item.id),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHint(ThemeData theme, S strings) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.manage_search_rounded,
          size: 64.sp,
          color: theme.colorScheme.onSurface.withOpacity(0.2),
        ),
        SizedBox(height: 14.h),
        Text(
          strings.searchByPlayerInstruction1,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorScheme.onSurface.withOpacity(0.45),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          strings.searchByPlayerInstruction2,
          style: TextStyle(
            fontSize: 12.sp,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared type filter chips widget
// ─────────────────────────────────────────────────────────────────────────────

class _TypeFilterRow extends StatelessWidget {
  final String? selected;
  final List<String> types;
  final ValueChanged<String?> onSelect;
  final ThemeData theme;

  const _TypeFilterRow({
    required this.selected,
    required this.types,
    required this.onSelect,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final allOptions = [null, ...types];
    return Container(
      height: 38.h,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: allOptions.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, i) {
          final option = allOptions[i];
          final isSelected = selected == option;
          return ChoiceChip(
            label: Text(option ?? 'All'),
            selected: isSelected,
            onSelected: (_) => onSelect(option),
            selectedColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.onError.withOpacity(0.2),
            labelStyle: TextStyle(
              fontSize: 12.sp,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            side: BorderSide.none,
            showCheckmark: false,
          );
        },
      ),
    );
  }
}
