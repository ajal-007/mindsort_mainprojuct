class ProgressPoint {
  final int assessmentNumber;
  final double overallClarity;
  final DateTime assessmentDate;

  const ProgressPoint({
    required this.assessmentNumber,
    required this.overallClarity,
    required this.assessmentDate,
  });

  factory ProgressPoint.fromMap(Map<String, dynamic> map) {
    return ProgressPoint(
      assessmentNumber: map['assessment_number'] as int,
      overallClarity: (map['overall_clarity'] as num).toDouble(),
      assessmentDate: DateTime.parse(map['created_at']),
    );
  }
}