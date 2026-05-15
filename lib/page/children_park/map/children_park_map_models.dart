enum ChildrenParkMapContentType { facility, restaurant, shop }

enum ChildrenParkMapPointType { facility, restaurant }

class ChildrenParkMapPoint {
  final String id;
  final String name;
  final int? floor;
  final String category;
  final double lat;
  final double lng;
  final ChildrenParkMapPointType pointType;

  const ChildrenParkMapPoint({
    required this.id,
    required this.name,
    required this.floor,
    required this.category,
    required this.lat,
    required this.lng,
    required this.pointType,
  });
}

class ChildrenParkPlaceDetail {
  final String name;
  final List<String> aliases;
  final String category;
  final String description;
  final ChildrenParkPlaceFilters? filters;

  const ChildrenParkPlaceDetail({
    required this.name,
    this.aliases = const [],
    required this.category,
    required this.description,
    this.filters,
  });
}

class ChildrenParkPlaceFilters {
  final String? height;
  final String? thrill;
  final List<String> environment;
  final String? price;
  final List<String> special;

  const ChildrenParkPlaceFilters({
    this.height,
    this.thrill,
    this.environment = const [],
    this.price,
    this.special = const [],
  });
}

class ChildrenParkRideFilters {
  final List<String> height;
  final List<String> thrill;
  final List<String> environment;
  final List<String> price;
  final List<String> special;

  const ChildrenParkRideFilters({
    this.height = const [],
    this.thrill = const [],
    this.environment = const [],
    this.price = const [],
    this.special = const [],
  });

  ChildrenParkRideFilters copyWith({
    List<String>? height,
    List<String>? thrill,
    List<String>? environment,
    List<String>? price,
    List<String>? special,
  }) {
    return ChildrenParkRideFilters(
      height: height ?? this.height,
      thrill: thrill ?? this.thrill,
      environment: environment ?? this.environment,
      price: price ?? this.price,
      special: special ?? this.special,
    );
  }

  int get activeCount {
    return height.length +
        thrill.length +
        environment.length +
        price.length +
        special.length;
  }
}
