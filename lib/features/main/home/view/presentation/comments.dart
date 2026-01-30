import 'package:flutter/material.dart';

class CommentsBottomSheet extends StatefulWidget {
  const CommentsBottomSheet({super.key});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  List<CommentModel> comments = [
    CommentModel(
      username: 'alex_design',
      timeAgo: '2h',
      text: 'Exploring the mountains today! #nature #hiking',
      likes: 0,
      isLiked: false,
    ),
    CommentModel(
      username: 'traveler_99',
      timeAgo: '1h',
      text: 'This view is incredible!',
      likes: 12,
      isLiked: false,
    ),
    CommentModel(
      username: 'photo_enthusiast',
      timeAgo: '45m',
      text: 'What camera did you use?',
      likes: 2,
      isLiked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // 🔘 Handle bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // 📝 Title
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // 💬 Comments list
              Expanded(
                child: comments.isEmpty
                    ? const Center(
                        child: Text(
                          'No comments yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return _buildCommentItem(comments[index], index);
                        },
                      ),
              ),

              // ✍️ Input
              _buildCommentInput(),
            ],
          ),
        );
      },
    );
  }

  // 💬 Comment Item
  Widget _buildCommentItem(CommentModel comment, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            child: Text(
              comment.username[0].toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.timeAgo,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _buildCommentText(comment.text),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    _commentController.text = '@${comment.username} ';
                  },
                  child: const Text(
                    'Reply',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

      Column(
  children: [
    IconButton(
      icon: Icon(
        comment.isLiked
            ? Icons.favorite
            : Icons.favorite_border,
        color: comment.isLiked ? Colors.red : Colors.grey,
        size: 20,
      ),
      onPressed: () {
        setState(() {
          comment.isLiked = !comment.isLiked;
          comment.likes += comment.isLiked ? 1 : -1;
        });
      },
    ),

    if (comment.likes > 0)
      Text(
        comment.likes.toString(),
        style: const TextStyle(fontSize: 12),
      ),

    // 🗑 Delete (ONLY current user)
    if (comment.username == 'current_user')
      IconButton(
        icon: const Icon(
          Icons.delete_outline,
          size: 18,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            comments.removeAt(index);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment deleted'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
  ],
),
      ],
      ),
    );
  }

  // 📝 Comment Text (hashtags & mentions)
  Widget _buildCommentText(String text) {
    final words = text.split(' ');
    return RichText(
      text: TextSpan(
        children: words.map((word) {
          final isTag = word.startsWith('#') || word.startsWith('@');
          return TextSpan(
            text: '$word ',
            style: TextStyle(
              color: isTag ? Colors.blue : Colors.black87,
              fontSize: 14,
            ),
          );
        }).toList(),
      ),
    );
  }

  // ✍️ Input
 Widget _buildCommentInput() {
  return AnimatedPadding(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: TextField(
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),

            TextButton(
              onPressed: () {
                if (_commentController.text.trim().isEmpty) return;

                setState(() {
                  comments.insert(
                    0,
                    CommentModel(
                      username: 'current_user',
                      timeAgo: 'Now',
                      text: _commentController.text,
                      likes: 0,
                      isLiked: false,
                    ),
                  );
                });

                _commentController.clear();
              },
              child: const Text(
                'Post',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

// 📦 Model
class CommentModel {
  final String username;
  final String timeAgo;
  final String text;
  int likes;
  bool isLiked;

  CommentModel({
    required this.username,
    required this.timeAgo,
    required this.text,
    required this.likes,
    required this.isLiked,
  });
}
