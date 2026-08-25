enum ActivityType { steps, workout, calories }

extension ActivityTypeLabel on ActivityType {
  String get label {
    switch (this) {
      case ActivityType.steps:
        return "Steps";
      case ActivityType.workout:
        return "Workout";
      case ActivityType.calories:
        return "Calories Burned";
    }
  }

  String get unit {
    switch (this) {
      case ActivityType.steps:
        return "steps";
      case ActivityType.workout:
        return "min";
      case ActivityType.calories:
        return "kcal";
    }
  }
}

class FitnessEntry {
  final ActivityType type;
  final double value;
  final DateTime date;

  FitnessEntry({required this.type, required this.value, required this.date});

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'value': value,
    'date': date.toIso8601String(),
  };

  factory FitnessEntry.fromJson(Map<String, dynamic> json) => FitnessEntry(
    type: ActivityType.values.firstWhere((e) => e.name == json['type']),
    value: (json['value'] as num).toDouble(),
    date: DateTime.parse(json['date']),
  );
}

class UserProfile {
  final String name;
  final DateTime? dob;

  UserProfile({required this.name, this.dob});

  int? get age {
    if (dob == null) return null;
    final now = DateTime.now();
    int years = now.year - dob!.year;
    if (now.month < dob!.month ||
        (now.month == dob!.month && now.day < dob!.day)) {
      years--;
    }
    return years;
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'dob': dob?.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] ?? '',
    dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
  );
}
