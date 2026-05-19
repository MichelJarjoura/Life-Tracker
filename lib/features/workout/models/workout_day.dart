class WorkoutDay {
  final DateTime date;
  final List<String> musclesWorked;

  WorkoutDay({required this.date, required this.musclesWorked});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'musclesWorked': musclesWorked,
  };

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => WorkoutDay(
    date: DateTime.parse(json['date']),
    musclesWorked: List<String>.from(json['musclesWorked']),
  );
}
