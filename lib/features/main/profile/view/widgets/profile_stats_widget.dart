import 'package:flutter/material.dart';
import '../../model/profile_model.dart';

class ProfileStatsWidget extends StatelessWidget {
  final ProfileStats stats;
  final VoidCallback? onFollowersPressed;
  final VoidCallback? onFollowingPressed;
  final VoidCallback? onConnectionsPressed;
  final VoidCallback? onAnalyzedPeoplePressed;

  const ProfileStatsWidget({
    Key? key,
    required this.stats,
    this.onFollowersPressed,
    this.onFollowingPressed,
    this.onConnectionsPressed,
    this.onAnalyzedPeoplePressed,
  }) : super(key: key);

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            label: 'Followers',
            value: _formatCount(stats.followers),
            onTap: onFollowersPressed,
          ),
          _buildStatItem(
            context,
            label: 'Following',
            value: _formatCount(stats.following),
            onTap: onFollowingPressed,
          ),
          _buildStatItem(
            context,
            label: 'Connections',
            value: _formatCount(stats.connections),
            onTap: onConnectionsPressed,
          ),
          _buildStatItem(
            context,
            label: 'Analyzed people',
            value: _formatCount(stats.analyzedPeople),
            onTap: onAnalyzedPeoplePressed,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}