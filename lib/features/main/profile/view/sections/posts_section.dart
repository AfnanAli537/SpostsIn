import 'package:flutter/material.dart';
import 'package:sports_in/generated/l10n.dart';
import '../../model/profile_model.dart';
import '../widgets/section_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostsSection extends StatelessWidget {
  final List<Post> posts;
  final VoidCallback? onShowAll;
  final Function(Post)? onPostTap;
  final ThemeData theme;
  final S string;

  const PostsSection({
    Key? key,
    required this.posts,
    this.onShowAll,
    this.onPostTap,
    required this.theme,
    required this.string,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: string.posts,
          onShowAllPressed: onShowAll,
        ),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: posts.length > 6 ? 6 : posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: () => onPostTap?.call(post),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                      ),
                      child: Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
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
        SizedBox(height: 16.h),
      ],
    );
  }
}