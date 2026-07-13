class DashboardData {
  final String id;
  final String userId;

  final double overallClarity;

  final String mentalStage;

  final double stressScore;

  final double focusScore;

  final double emotionScore;

  final double productivityScore;

  final int assessmentNumber;

  final DateTime assessmentDate;

  const DashboardData({
    required this.id,
    required this.userId,
    required this.overallClarity,
    required this.mentalStage,
    required this.stressScore,
    required this.focusScore,
    required this.emotionScore,
    required this.productivityScore,
    required this.assessmentNumber,
    required this.assessmentDate,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      id: json['id'],
      userId: json['user_id'],
      overallClarity: (json['overall_clarity'] as num).toDouble(),
      mentalStage: json['mental_stage'] as String,
      stressScore: (json['stress_score'] as num).toDouble(),
      focusScore: (json['focus_score'] as num).toDouble(),
      emotionScore: (json['emotion_score'] as num).toDouble(),
      productivityScore: (json['productivity_score'] as num).toDouble(),
      assessmentNumber: json['assessment_number'] as int,
      assessmentDate: DateTime.parse(json['created_at']),
    );
  }
}