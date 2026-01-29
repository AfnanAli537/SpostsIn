// import 'package:flutter/material.dart';

// class PostWidget extends StatelessWidget {
//   final String userName;
//   final String timeAgo;
//   final String desc;
//   final String title;
//   final String? mediaUrl;
//   final int likes;
//   final int comments;

//   const PostWidget({
//     super.key,
//     required this.userName,
//     required this.timeAgo,
//     required this.desc,
//     required this.title,
//     required this.mediaUrl,
//     required this.likes,
//     required this.comments,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return 
//     // Shimmer.fromColors(
//     //   baseColor: Colors.grey.shade300,
//     //   highlightColor: Colors.grey.shade100,
//     //   enabled: false,
//     //   child:
//        Card(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundColor: Colors.grey[300],
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(height: 14, width: 120, color: Colors.grey),
//                         const SizedBox(height: 6),
//                         Container(height: 10, width: 80, color: Colors.grey),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Container(height: 12, color: Colors.grey),
//               const SizedBox(height: 8),
//               Container(height: 12, width: 200, color: Colors.grey),
//               const SizedBox(height: 16),
//               Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.grey,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       // ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:sports_in/features/main/home/view/presentation/comments.dart';
import 'package:sports_in/features/main/home/view/presentation/likes.dart';

class PostWidget extends StatelessWidget {
  final String userName;
  final String timeAgo;
  final String desc;
  final String title;
  final String? mediaUrl;
  final int likes;
  final int comments;

  const PostWidget({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.desc,
    required this.title,
    required this.mediaUrl,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show options menu
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

            // Description
            Text(
              desc,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Media (Image or Video)
            if (mediaUrl != null && mediaUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  mediaUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey[500],
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Colors.grey[500],
                ),
              ),
            const SizedBox(height: 16),

            // Like and Comment Section
            Row(
              children: [
                // Like Button
                InkWell(
                  onTap: () {
                    // Handle like
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: (){
                                Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const LikesScreen(),

                             ) );
                          },
                          child: Text(
                            likes.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Comment Button
                InkWell(
                  onTap: () {
                    // Handle comment
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                        icon: Icon(Icons.chat_bubble_outline),
                          color: Colors.grey[600],
                          onPressed: () {
                            Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const CommentsScreen(),

                             ) );
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(
                          comments.toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),

               
              ],
            ),
          ],
        ),
      ),
    );
  }
}
