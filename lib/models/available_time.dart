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
}
