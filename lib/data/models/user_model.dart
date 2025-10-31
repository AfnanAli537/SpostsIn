// File: lib/blocs/auth/signup/user_type.dart

enum UserType {
  player,
  coach,
  scout,
  club,
  institute,
  other;

  String get displayName {
    switch (this) {
      case UserType.player:
        return 'Player';
      case UserType.coach:
        return 'Coach';
      case UserType.scout:
        return 'Scout';
      case UserType.club:
        return 'Club';
      case UserType.institute:
        return 'Institute';
      case UserType.other:
        return 'Other';
    }
  }

  static UserType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'player':
        return UserType.player;
      case 'coach':
        return UserType.coach;
      case 'scout':
        return UserType.scout;
      case 'club':
        return UserType.club;
      case 'institute':
        return UserType.institute;
      case 'other':
        return UserType.other;
      default:
        throw ArgumentError('Invalid user type: $type');
    }
  }
}