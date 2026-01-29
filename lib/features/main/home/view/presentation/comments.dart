import 'package:flutter/material.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  
  // Sample comments list
  List<CommentModel> comments = [
    CommentModel(
      username: 'alex_design',
      timeAgo: '2h',
      text: 'Exploring the mountains today! Every breath of fresh air feels like a new beginning. #nature #hiking #adventure',
      likes: 0,
      isLiked: false,
    ),
    CommentModel(
      username: 'traveler_99',
      timeAgo: '1h',
      text: 'This view is incredible! I can\'t wait to visit this spot next month.',
      likes: 12,
      isLiked: false,
    ),
    CommentModel(
      username: 'photo_enthusiast',
      timeAgo: '45m',
      text: 'What camera did you use? The dynamic range is stunning!',
      likes: 2,
      isLiked: true,
    ),
    CommentModel(
      username: 'mountain_mike',
      timeAgo: '12m',
      text: 'I need to go there next summer. Adding to my bucket list right now.',
      likes: 0,
      isLiked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2332),
      
      // 📱 AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2332),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white, size: 24),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 💬 Comments List (في المنتصف)
          Expanded(
            child: comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments yet',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Be the first to comment',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return _buildCommentItem(comments[index], index);
                    },
                  ),
          ),
          
          // ✍️ Comment Input (في الأسفل)
          _buildCommentInput(),
        ],
      ),
    );
  }

  // 💬 Comment Item Widget
  Widget _buildCommentItem(CommentModel comment, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👤 Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[700],
            child: Text(
              comment.username[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 📝 Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username + Time
                Row(
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.timeAgo,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Comment Text
                _buildCommentText(comment.text),
                const SizedBox(height: 8),

                // Reply + Likes
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle reply
                        _commentController.text = '@${comment.username} ';
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (comment.likes > 0) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.thumb_up,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.likes.toString(),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ❤️ Like Button
          Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    comment.isLiked = !comment.isLiked;
                    if (comment.isLiked) {
                      comment.likes++;
                    } else {
                      comment.likes--;
                    }
                  });
                },
                icon: Icon(
                  comment.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: comment.isLiked ? Colors.red : Colors.grey[600],
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              // Delete button for demo (optional)
              if (comment.username == 'current_user')
                IconButton(
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
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.grey[600],
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // 📝 Comment Text with Hashtags and Mentions
  Widget _buildCommentText(String text) {
    // Check if text contains hashtags or mentions
    if (text.contains('#') || text.contains('@')) {
      final words = text.split(' ');
      return RichText(
        text: TextSpan(
          children: words.map((word) {
            if (word.startsWith('#') || word.startsWith('@')) {
              return TextSpan(
                text: '$word ',
                style: const TextStyle(
                  color: Color(0xFF5B9FED),
                  fontSize: 14,
                  height: 1.4,
                ),
              );
            }
            return TextSpan(
              text: '$word ',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            );
          }).toList(),
        ),
      );
    }

    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        height: 1.4,
      ),
    );
  }

  // ✍️ Comment Input Widget
  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[700],
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            
            // TextField
            Expanded(
              child: TextField(
                controller: _commentController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                textInputAction: TextInputAction.newline,
              ),
            ),
            
            // Post Button
            TextButton(
              onPressed: () {
                if (_commentController.text.trim().isNotEmpty) {
                  setState(() {
                    // Add new comment to the top of the list
                    comments.insert(
                      0,
                      CommentModel(
                        username: 'current_user',
                        timeAgo: 'Just now',
                        text: _commentController.text,
                        likes: 0,
                        isLiked: false,
                      ),
                    );
                  });
                  
                  _commentController.clear();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Comment posted!'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: const Color(0xFF5B9FED),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Color(0xFF5B9FED),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
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

// 📦 Comment Model
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