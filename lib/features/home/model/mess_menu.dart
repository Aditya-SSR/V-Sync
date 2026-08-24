/// One day's mess menu, split by meal.
class MessDayMenu {
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> snacks;
  final List<String> dinner;

  const MessDayMenu({
    this.breakfast = const [],
    this.lunch = const [],
    this.snacks = const [],
    this.dinner = const [],
  });

  List<String> forMeal(int mealIndex) {
    switch (mealIndex) {
      case 0:
        return breakfast;
      case 1:
        return lunch;
      case 2:
        return snacks;
      default:
        return dinner;
    }
  }

  Map<String, dynamic> toJson() => {
        'breakfast': breakfast,
        'lunch': lunch,
        'snacks': snacks,
        'dinner': dinner,
      };

  factory MessDayMenu.fromJson(Map<String, dynamic> json) => MessDayMenu(
        breakfast:
            (json['breakfast'] as List<dynamic>?)?.cast<String>() ?? const [],
        lunch: (json['lunch'] as List<dynamic>?)?.cast<String>() ?? const [],
        snacks: (json['snacks'] as List<dynamic>?)?.cast<String>() ?? const [],
        dinner: (json['dinner'] as List<dynamic>?)?.cast<String>() ?? const [],
      );
}

/// A full month of mess menus parsed from the monthly Excel sheet.
class MessMenu {
  final String monthName;
  final int month; // 1-12
  final int year;

  /// Menu per day of month (1-based).
  final Map<int, MessDayMenu> days;

  const MessMenu({
    required this.monthName,
    required this.month,
    required this.year,
    required this.days,
  });

  MessDayMenu? menuFor(int day) => days[day];

  int? get firstDay => days.keys.isEmpty ? null : (days.keys.toList()..sort()).first;

  int? get lastDay => days.keys.isEmpty ? null : (days.keys.toList()..sort()).last;

  Map<String, dynamic> toJson() => {
        'monthName': monthName,
        'month': month,
        'year': year,
        'days': days.map((key, value) => MapEntry(key.toString(), value.toJson())),
      };

  factory MessMenu.fromJson(Map<String, dynamic> json) => MessMenu(
        monthName: json['monthName'] as String,
        month: json['month'] as int,
        year: json['year'] as int,
        days: (json['days'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            int.parse(key),
            MessDayMenu.fromJson(value as Map<String, dynamic>),
          ),
        ),
      );
}
