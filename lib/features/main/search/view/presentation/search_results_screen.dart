import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sports_in/features/main/search/view/widgets/search_result_card.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../view_model/search_bloc.dart';
import '../../view_model/search_state.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = S.of(context);

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
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: theme.iconTheme.color),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar (read-only, shows current query)
          Padding(
            padding: EdgeInsets.all(16.r),
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                String query = '';
                if (state is SearchLoaded) {
                  query = state.query;
                } else if (state is SearchEmpty) {
                  query = state.query;
                }
                
                return TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: query.isEmpty ? 'Search' : query,
                    prefixIcon: Icon(Icons.search, size: 20.sp),
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
                );
              },
            ),
          ),

          // Results List
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is SearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: theme.colorScheme.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.message,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: state.results.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final result = state.results[index];
                      return SearchResultCard(
                        result: result,
                        onTap: () {
                          // Navigate to user profile
                          // Navigator.push(context, ...);
                          print('Tapped on ${result.name}');
                        },
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
}