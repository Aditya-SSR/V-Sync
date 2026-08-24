class Milestone {
  final String id;
  final String title;
  final String? info;
  final DateTime targetDate;

  const Milestone({
    required this.id,
    required this.title,
    this.info,
    required this.targetDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'info': info,
        'targetDate': targetDate.toIso8601String(),
      };

  factory Milestone.fromJson(Map<String, dynamic> json) => Milestone(
        id: json['id'] as String,
        title: json['title'] as String,
        info: json['info'] as String?,
        targetDate: DateTime.parse(json['targetDate'] as String),
      );

  /// Whole days between today and the target date (negative once passed).
  int daysLeft() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
        targetDate.year, targetDate.month, targetDate.day);
    return target.difference(today).inDays;
  }

  /// Whole hours between now and the target moment (negative once passed).
  int hoursLeft() => targetDate.difference(DateTime.now()).inHours;

  /// True once the target moment is in the past.
  bool isPassed() => targetDate.isBefore(DateTime.now());
}
