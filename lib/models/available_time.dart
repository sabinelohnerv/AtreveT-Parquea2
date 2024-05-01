class AvailableTimeInDay {
  String day;
  List<AvailableTime> availableTime;

  AvailableTimeInDay({
    required this.day,
    required this.availableTime,
  });
}

class AvailableTime {
  String startTime;
  String endTime;

  AvailableTime({
    required this.startTime,
    required this.endTime,
  });
}
