class AIInsight {
  final String summary;

  final String motivation;

  const AIInsight({
    required this.summary,
    required this.motivation,
  });

  factory AIInsight.fromJson(Map<String, dynamic> json) {
    return AIInsight(
      summary: json['summary'] ?? '',
      motivation: json['motivation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'motivation': motivation,
    };
  }
}