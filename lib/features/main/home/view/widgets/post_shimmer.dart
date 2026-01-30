import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmerWidget extends StatelessWidget {
  const PostShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade200,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(width: 120, height: 14),
                      const SizedBox(height: 6),
                      _shimmerBox(width: 80, height: 10), 
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _shimmerBox(width: double.infinity, height: 14),
              const SizedBox(height: 8),
              _shimmerBox(width: double.infinity, height: 12),
              const SizedBox(height: 6),
              _shimmerBox(width: 220, height: 12),
              const SizedBox(height: 16),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _shimmerBox(width: 20, height: 20), 
                  const SizedBox(width: 6),
                  _shimmerBox(width: 30, height: 12), 
                  const SizedBox(width: 16),
                  _shimmerBox(width: 20, height: 20), 
                  const SizedBox(width: 6),
                  _shimmerBox(width: 30, height: 12), 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _shimmerBox({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
