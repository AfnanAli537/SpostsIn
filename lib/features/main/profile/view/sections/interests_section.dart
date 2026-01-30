import 'package:flutter/material.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';

class InterestsSection extends StatelessWidget {
  final List<Interest> interests;
  final VoidCallback? onShowAll;
  final Function(Interest, bool)? onConnectToggle;
  final Function(Interest, bool)? onFollowToggle;

  const InterestsSection({
    super.key,
    required this.interests,
    this.onShowAll,
    this.onConnectToggle,
    this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Interests',
          onShowAllPressed: onShowAll,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: interests.length > 3 ? 3 : interests.length,
          itemBuilder: (context, index) {
            final interest = interests[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: interest.profileImage.isNotEmpty
                        ? NetworkImage(interest.profileImage)
                        : null,
                    child: interest.profileImage.isEmpty
                        ? Text(
                            interest.name.isNotEmpty 
                                ? interest.name[0].toUpperCase() 
                                : '?',
                            style: const TextStyle(fontSize: 18),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          interest.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          interest.role,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildActionButton(
                    label: interest.isConnected ? 'Connected' : 'Connect',
                    isActive: interest.isConnected,
                    onPressed: () => onConnectToggle?.call(
                      interest, 
                      !interest.isConnected,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    label: interest.isFollowing ? 'Following' : 'Follow',
                    isActive: interest.isFollowing,
                    isPrimary: true,
                    onPressed: () => onFollowToggle?.call(
                      interest, 
                      !interest.isFollowing,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: (isPrimary && !isActive) 
            ? const Color(0xFF1E3A5F) 
            : Colors.transparent,
        foregroundColor: (isPrimary && !isActive) 
            ? Colors.white 
            : const Color(0xFF1E3A5F),
        side: const BorderSide(
          color: Color(0xFF1E3A5F),
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(80, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}