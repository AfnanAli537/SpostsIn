import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/features/main/chat_bot/presentation/chat_history_screen.dart';

class ChatbotOnboardingScreen extends StatelessWidget {
  const ChatbotOnboardingScreen({super.key});

  static const routeName = '/chatbot-onboarding';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // ─── Title ──────────────────────────────────────────────────
              Text(
                'You AI Assistant',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A2E),
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Using this software you can ask questions and receive articles using artificial intelligence assistant.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: 48),

              // ─── Robot Illustration ─────────────────────────────────────
              Expanded(
                child: Center(
                  child: _RobotIllustration(),
                ),
              ),

              const SizedBox(height: 48),

              // ─── Continue Button ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  // onPressed: () => Navigator.pushReplacementNamed(
                  //   context,
                  //   ChatHistoryScreen.routeName,
                  // ),
                  // In ChatbotOnboardingScreen
onPressed: () async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('has_seen_chatbot_onboarding', true);
  
  if (context.mounted) {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) 
      => const ChatHistoryScreen()
  
      ),
    );
    // Navigator.pushReplacementNamed(context, ChatHistoryScreen.routeName);
  }
},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A2E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Simple Robot Illustration ────────────────────────────────────────────────
class _RobotIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Body
          Positioned(
            bottom: 20,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          // Head
          Positioned(
            top: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Eyes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Eye(),
                      const SizedBox(width: 14),
                      _Eye(),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Chat bubble
          Positioned(
            top: 10,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD4F5C4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ),
          ),
          // Gear
          Positioned(
            top: 50,
            left: 10,
            child: Icon(
              Icons.settings,
              color: const Color(0xFFE8F5E9),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: const BoxDecoration(
        color: Color(0xFFD4F5C4),
        shape: BoxShape.circle,
      ),
    );
  }
}