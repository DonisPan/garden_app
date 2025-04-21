class PlantNotification {
  final int id;
  final int plantId;
  final String message;
  final DateTime startDate;
  final int? repeatEveryDays;
  final bool isActive;

  PlantNotification({
    required this.id,
    required this.plantId,
    required this.message,
    required this.startDate,
    this.repeatEveryDays,
    this.isActive = true,
  });

  String get frequencyDescription {
    if (repeatEveryDays == null) return 'One time';
    if (repeatEveryDays == 1) return 'Daily';
    return 'Every $repeatEveryDays days';
  }

  List<DateTime> getNextOccurrences(int count) {
    final occurrences = <DateTime>[];
    var current = startDate;

    for (int i = 0; i < count; i++) {
      if (current.isAfter(DateTime.now())) {
        occurrences.add(current);
      }
      if (repeatEveryDays != null) {
        current = current.add(Duration(days: repeatEveryDays!));
      } else {
        break; // No repeats
      }
    }

    return occurrences;
  }

  DateTime get nextOccurrence {
    final now = DateTime.now();
    if (startDate.isAfter(now)) return startDate;

    if (repeatEveryDays == null) return startDate;

    // Calculate next occurrence after today
    final daysSinceStart = now.difference(startDate).inDays;
    final intervals = (daysSinceStart / repeatEveryDays!).ceil();
    return startDate.add(Duration(days: intervals * repeatEveryDays!));
  }

  PlantNotification copyWith({
    String? message,
    DateTime? startDate,
    int? repeatEveryDays,
    bool? isActive,
  }) {
    return PlantNotification(
      id: id,
      plantId: plantId,
      message: message ?? this.message,
      startDate: startDate ?? this.startDate,
      repeatEveryDays: repeatEveryDays ?? this.repeatEveryDays,
      isActive: isActive ?? this.isActive,
    );
  }
}
