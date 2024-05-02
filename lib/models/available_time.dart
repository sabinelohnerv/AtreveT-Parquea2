class AvailableTimeInDay {
  String day;
  List<AvailableTime>? availableTime;

  AvailableTimeInDay({
    required this.day,
    this.availableTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'availableTime': availableTime != []
          ? availableTime!.map((x) => x.toJson()).toList()
          : [],
    };
  }

  factory AvailableTimeInDay.fromJson(Map<String, dynamic> json) {
    return AvailableTimeInDay(
      day: json['day'] as String,
      availableTime: json['availableTime'] != null
          ? (json['availableTime'] as List)
              .map((x) => AvailableTime.fromJson(x as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class AvailableTime {
  String startTime;
  String endTime;

  AvailableTime({
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory AvailableTime.fromJson(Map<String, dynamic> json) => AvailableTime(
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
      );
}
