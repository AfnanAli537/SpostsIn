import 'package:flutter/material.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';

class OpportunitiesSection extends StatelessWidget {
  final List<Opportunity> opportunities;
  final VoidCallback? onShowAll;
  final Function(Opportunity)? onOpportunityTap;

  const OpportunitiesSection({
    super.key,
    required this.opportunities,
    this.onShowAll,
    this.onOpportunityTap,
  });

  @override
  Widget build(BuildContext context) {
    if (opportunities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Opportunities',
          onShowAllPressed: onShowAll,
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: opportunities.length > 6 ? 6 : opportunities.length,
            itemBuilder: (context, index) {
              final opportunity = opportunities[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => onOpportunityTap?.call(opportunity),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Image.network(
                        opportunity.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.work, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}