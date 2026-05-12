enum ParkCategory {
  attraction,
  food,
  souvenir,
  restroom,
  family,
  transport,
  show,
}

enum WaitLevel {
  low,
  medium,
  high,
  info,
}

class ParkAttraction {
  final String id;
  final String name;
  final ParkCategory category;
  final int? waitMinutes;
  final String distanceText;
  final double rating;
  final String status;
  final String description;
  final String imageUrl;
  final double mapX;
  final double mapY;

  const ParkAttraction({
    required this.id,
    required this.name,
    required this.category,
    required this.waitMinutes,
    required this.distanceText,
    required this.rating,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.mapX,
    required this.mapY,
  });

  WaitLevel get waitLevel {
    if (waitMinutes == null) {
      return WaitLevel.info;
    }
    if (waitMinutes! <= 15) {
      return WaitLevel.low;
    }
    if (waitMinutes! <= 30) {
      return WaitLevel.medium;
    }
    return WaitLevel.high;
  }

  String get waitLabel {
    return switch (waitMinutes) {
      int minutes => '$minutes 分鐘',
      null => status,
    };
  }
}

class ParkEvent {
  final String id;
  final String name;
  final String timeText;
  final String location;
  final String status;
  final String imageUrl;
  final String period;

  const ParkEvent({
    required this.id,
    required this.name,
    required this.timeText,
    required this.location,
    required this.status,
    required this.imageUrl,
    required this.period,
  });
}

class ParkUserProfile {
  final String displayName;
  final String memberLevel;
  final String checkInStatus;
  final String checkInTime;
  final String preferredRoute;
  final String reminderSetting;

  const ParkUserProfile({
    required this.displayName,
    required this.memberLevel,
    required this.checkInStatus,
    required this.checkInTime,
    required this.preferredRoute,
    required this.reminderSetting,
  });
}
