/// A single food item. [special] marks items highlighted in the Excel
/// sheet (red font), [nonVeg] marks explicit non-veg items.
class MessItem {
  final String name;
  final bool special;
  final bool nonVeg;

  const MessItem({
    required this.name,
    this.special = false,
    this.nonVeg = false,
  });

  Map<String, dynamic> toJson() => {
        'n': name,
        if (special) 's': true,
        if (nonVeg) 'v': true,
      };

  factory MessItem.fromJson(Map<String, dynamic> json) => MessItem(
        name: json['n'] as String,
        special: json['s'] as bool? ?? false,
        nonVeg: json['v'] as bool? ?? false,
      );
}

/// One day's mess menu, split by meal.
class MessDayMenu {
  final List<MessItem> breakfast;
  final List<MessItem> lunch;
  final List<MessItem> snacks;
  final List<MessItem> dinner;

  const MessDayMenu({
    this.breakfast = const [],
    this.lunch = const [],
    this.snacks = const [],
    this.dinner = const [],
  });

  List<MessItem> forMeal(int mealIndex) {
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
        'breakfast': breakfast.map((e) => e.toJson()).toList(),
        'lunch': lunch.map((e) => e.toJson()).toList(),
        'snacks': snacks.map((e) => e.toJson()).toList(),
        'dinner': dinner.map((e) => e.toJson()).toList(),
      };

  factory MessDayMenu.fromJson(Map<String, dynamic> json) => MessDayMenu(
        breakfast: (json['breakfast'] as List<dynamic>? ?? const [])
            .map((e) => MessItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        lunch: (json['lunch'] as List<dynamic>? ?? const [])
            .map((e) => MessItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        snacks: (json['snacks'] as List<dynamic>? ?? const [])
            .map((e) => MessItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        dinner: (json['dinner'] as List<dynamic>? ?? const [])
            .map((e) => MessItem.fromJson(e as Map<String, dynamic>))
            .toList(),
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
