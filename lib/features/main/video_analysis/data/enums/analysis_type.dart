import 'package:sports_in/core/constants/assets_manager.dart';

enum AnalysisType {
  goalkeeper,
  passing,
  dribbling,
  match;

  String get label {
    switch (this) {
      case AnalysisType.goalkeeper:
        return 'drilling';
      case AnalysisType.passing:
        return 'Passing';
      case AnalysisType.dribbling:
        return 'Dribbling';
      case AnalysisType.match:
        return 'Match';
    }
  }

  String get endpoint {
    switch (this) {
      case AnalysisType.goalkeeper:
        return '/api/Analysis/analyze-drill';
      case AnalysisType.passing:
        return '/api/Analysis/analyze-player';
      case AnalysisType.dribbling:
        return '/api/Analysis/analyze-dribbling';
      case AnalysisType.match:
        return '/api/Analysis/analyze-match';
    }
  }

  String get description {
    switch (this) {
      case AnalysisType.goalkeeper:
        return 'Analyze goalkeeper reflexes, diving range, knee angles, reaction time, and maximum extension during a drill.';
      case AnalysisType.passing:
        return 'Evaluate passing accuracy, ball speed, player movement, and knee biomechanics during a passing drill.';
      case AnalysisType.dribbling:
        return 'Assess dribbling technique, cone navigation, ball distance control, head-up awareness, and hip movement.';
      case AnalysisType.match:
        return 'Analyze team possession, distance covered, top sprint speeds, and overall match performance metrics.';
    }
  }

  String get videoInstructions {
    switch (this) {
      case AnalysisType.goalkeeper:
        return '• Film the goalkeeper from the front or slight angle\n'
            '• Ensure the full body is visible from head to toe\n'
            '• Capture at least one complete save attempt\n'
            '• Minimum 5 seconds, well-lit environment\n'
            '• Avoid shaky footage — use a tripod if possible';
      case AnalysisType.passing:
        return '• Film from the side showing the full player body\n'
            '• Keep the ball visible throughout the clip\n'
            '• Include at least 3–5 passes in the drill\n'
            '• Stable camera at waist-to-head height\n'
            '• Minimum 5 seconds of active play';
      case AnalysisType.dribbling:
        return '• Film from slightly above ground level, side angle\n'
            '• Ensure all cones are visible in the frame\n'
            '• Capture the full dribbling course run\n'
            '• Keep the ball and player in frame at all times\n'
            '• Minimum 5 seconds, avoid zooming in/out';
      case AnalysisType.match:
        return '• Film from an elevated position (stands or tripod)\n'
            '• Both teams should be partially or fully visible\n'
            '• Keep the ball in frame as much as possible\n'
            '• Avoid switching to portrait orientation\n'
            '• Minimum 5 seconds of active match play';
    }
  }

  String get exampleImageAsset {
    switch (this) {
      case AnalysisType.goalkeeper:
        return ImageAssets.analyzeDrill;
      case AnalysisType.passing:
        return ImageAssets.analyzePlayer;
      case AnalysisType.dribbling:
        return ImageAssets.analyzeDribbling;
      case AnalysisType.match:
        return ImageAssets.analyzeMatch;
    }
  }
}