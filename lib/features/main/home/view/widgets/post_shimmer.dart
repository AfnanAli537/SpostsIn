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

              /// 🔹 User Info
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
                      _shimmerBox(width: 120, height: 14), // username
                      const SizedBox(height: 6),
                      _shimmerBox(width: 80, height: 10), // time ago
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// 🔹 Title
              _shimmerBox(width: double.infinity, height: 14),
              const SizedBox(height: 8),

              /// 🔹 Description
              _shimmerBox(width: double.infinity, height: 12),
              const SizedBox(height: 6),
              _shimmerBox(width: 220, height: 12),

              const SizedBox(height: 16),

              /// 🔹 Image (mediaUrl)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔹 Likes & Comments
              Row(
                children: [
                  _shimmerBox(width: 20, height: 20), // like icon
                  const SizedBox(width: 6),
                  _shimmerBox(width: 30, height: 12), // likes count
                  const SizedBox(width: 16),
                  _shimmerBox(width: 20, height: 20), // comment icon
                  const SizedBox(width: 6),
                  _shimmerBox(width: 30, height: 12), // comments count
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
