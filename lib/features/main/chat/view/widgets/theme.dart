import 'package:flutter/material.dart';

class ChatColors {
  static const primary = Color(0xFF4F8EF7);
  static const primaryDark = Color(0xFF6A5ACD);
  static const background = Color(0xFFF7F8FC);
  static const surface = Colors.white;
  static const border = Color(0xFFEEF0F5);
  static const textPrimary = Color(0xFF1A1D2E);
  static const textSecondary = Color(0xFF8A8D9F);
  static const textMuted = Color(0xFFA0A3B1);
  static const online = Color(0xFF2ECC71);
  static const unreadBadge = Color(0xFF4F8EF7);
  static const danger = Color(0xFFE74C3C);
  static const myBubbleStart = Color(0xFF4F8EF7);
  static const myBubbleEnd = Color(0xFF6A5ACD);
  static const theirBubble = Colors.white;
}

class ChatTextStyles {
  static const heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
  );
  static const sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: ChatColors.textMuted,
    letterSpacing: 0.6,
  );
  static const chatName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: ChatColors.textPrimary,
  );
  static const chatPreview = TextStyle(
    fontSize: 13,
    color: ChatColors.textSecondary,
  );
  static const timestamp = TextStyle(
    fontSize: 11,
    color: ChatColors.textMuted,
  );
  static const myBubbleText = TextStyle(
    fontSize: 14,
    color: Colors.white,
    height: 1.45,
  );
  static const theirBubbleText = TextStyle(
    fontSize: 14,
    color: ChatColors.textPrimary,
    height: 1.45,
  );
  static const inputHint = TextStyle(
    fontSize: 14,
    color: ChatColors.textMuted,
  );
}