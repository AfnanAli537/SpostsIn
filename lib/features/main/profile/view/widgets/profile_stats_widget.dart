import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';

class ProfileStatsWidget extends StatelessWidget {
  final ProfileStats stats;
  final VoidCallback? onFollowersPressed;
  final VoidCallback? onFollowingPressed;
  final VoidCallback? onConnectionsPressed;
  final VoidCallback? onAnalyzedPeoplePressed;
  final ThemeData theme;
  final S string;

  const ProfileStatsWidget({
    super.key,
    required this.stats,
    this.onFollowersPressed,
    this.onFollowingPressed,
    this.onConnectionsPressed,
    this.onAnalyzedPeoplePressed,
    required this.theme,
    required this.string,
  });

  String _formatCount(String count) {
    final number = int.tryParse(count.replaceAll(',', '')) ?? 0;
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return count;
  }

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatItem(
            label: string.followers,
            value: _formatCount(stats.followers),
            onTap: onFollowersPressed,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            label: string.following,
            value: _formatCount(stats.following),
            onTap: onFollowingPressed,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            label: string.connections,
            value: _formatCount(stats.connections),
            onTap: onConnectionsPressed,
          ),
          const SizedBox(width: 24),
          _buildStatItem(
            label: string.analyzedPeople,
            value: _formatCount(stats.analyzedPeople),
            onTap: onAnalyzedPeoplePressed,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatItem({
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onTertiaryFixed,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}