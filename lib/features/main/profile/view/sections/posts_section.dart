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

  // ✅ Helper method to check if URL is valid
  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    if (url == 'string') return false; // Handle literal "string" from API
    if (url.length < 5) return false; // Too short to be valid URL
    
    // Check if it starts with http:// or https://
    return url.startsWith('http://') || url.startsWith('https://');
  }

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
            itemCount: posts.length > 3 ? 3 : posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final hasValidImage = _isValidImageUrl(post.imageUrl);
              
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
                      // ✅ Only use Image.network if URL is valid
                      child: hasValidImage
                          ? Image.network(
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
                            )
                          : Center(
                              child: Icon(
                                Icons.article_outlined,
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 40.sp,
                              ),
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