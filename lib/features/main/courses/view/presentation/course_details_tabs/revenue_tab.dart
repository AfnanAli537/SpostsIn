import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';
import 'package:sports_in/features/main/courses/view_model/courses_bloc/courses_bloc.dart';
import 'package:sports_in/generated/l10n.dart';

class RevenueTab extends StatefulWidget {
  final String courseId;

  const RevenueTab({
    super.key,
    required this.courseId,
  });

  @override
  State<RevenueTab> createState() => _RevenueTabState();
}

class _RevenueTabState extends State<RevenueTab> {
  final DateTime _now = DateTime.now();
  late int _selectedMonth;
  late int _selectedYear;

  // Generate last 12 months for dropdown
  final List<int> _months = List.generate(12, (index) => index + 1);
  late final List<int> _years;

  @override
  void initState() {
    super.initState();
    _selectedMonth = _now.month;
    _selectedYear = _now.year;
    
    // Generate years (current year and 2 years back)
    _years = List.generate(3, (index) => _now.year - index);
    
    _fetchRevenue();
  }

  void _fetchRevenue() {
    context.read<CoursesBloc>().add(
      FetchRevenueReport(
        courseId: widget.courseId,
        month: _selectedMonth,
        year: _selectedYear,
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final string = S.of(context);

    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (context, state) {
        if (state is CoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RevenueReportLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              _fetchRevenue();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Month/Year Filter
                  _buildMonthYearFilter(theme),
                  SizedBox(height: 16.h),

                  // Total revenue cards
                  _buildRevenueCards(state.report, theme, string),
                  SizedBox(height: 24.h),

                  // Weekly breakdown chart
                  Text(
                    'Weekly Breakdown',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildRevenueChart(state.report, theme),
                  SizedBox(height: 24.h),

                  // Weekly details
                  _buildWeeklyDetails(state.report, theme, string),
                ],
              ),
            ),
          );
        }

        if (state is CoursesError) {
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
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _fetchRevenue,
                  child: Text(string.retry),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // ✅ Month/Year Filter Dropdowns
  Widget _buildMonthYearFilter(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            color: theme.colorScheme.primary,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          
          // Month Dropdown
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: InputDecoration(
                labelText: 'Month',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              items: _months.map((month) {
                return DropdownMenuItem(
                  value: month,
                  child: Text(
                    _getMonthName(month),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMonth = value;
                  });
                  _fetchRevenue();
                }
              },
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Year Dropdown
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<int>(
              value: _selectedYear,
              decoration: InputDecoration(
                labelText: 'Year',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              items: _years.map((year) {
                return DropdownMenuItem(
                  value: year,
                  child: Text(
                    year.toString(),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedYear = value;
                  });
                  _fetchRevenue();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCards(RevenueReportModel report, ThemeData theme, S string) {
    return Row(
      children: [
        Expanded(
          child: _buildRevenueCard(
            'All-Time Revenue',
            '${report.totalAllTimeRevenue.toStringAsFixed(0)} EGP',
            Icons.account_balance_wallet,
            theme.colorScheme.primary,
            theme,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildRevenueCard(
            '${_getMonthName(_selectedMonth)} ${_selectedYear}',
            '${report.totalMonthRevenue.toStringAsFixed(0)} EGP',
            Icons.calendar_today,
            Colors.green,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueCard(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.sp, color: color),
          SizedBox(height: 8.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(RevenueReportModel report, ThemeData theme) {
    if (report.weeklyBreakdown.isEmpty) {
      return Container(
        height: 200.h,
        alignment: Alignment.center,
        child: Text(
          'No data available for ${_getMonthName(_selectedMonth)} ${_selectedYear}',
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    final maxRevenue = _getMaxRevenue(report);
    final horizontalInterval = maxRevenue > 0 ? (maxRevenue / 5) : 20.0;

    return Container(
      height: 250.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxRevenue > 0 ? maxRevenue * 1.2 : 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(0)} EGP',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < report.weeklyBreakdown.length) {
                    return Text(
                      report.weeklyBreakdown[value.toInt()].weekLabel,
                      style: TextStyle(fontSize: 12.sp),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.w,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: TextStyle(fontSize: 10.sp),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: horizontalInterval,
          ),
          borderData: FlBorderData(show: false),
          barGroups: report.weeklyBreakdown.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.revenue,
                  color: theme.colorScheme.primary,
                  width: 16.w,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWeeklyDetails(RevenueReportModel report, ThemeData theme, S string) {
    if (report.weeklyBreakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...report.weeklyBreakdown.map((week) {
          return Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  week.weekLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${week.revenue.toStringAsFixed(0)} EGP',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  double _getMaxRevenue(RevenueReportModel report) {
    if (report.weeklyBreakdown.isEmpty) return 0;
    return report.weeklyBreakdown
        .map((w) => w.revenue)
        .reduce((a, b) => a > b ? a : b);
  }
}