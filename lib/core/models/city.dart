class City {
  const City({
    required this.id,
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) => other is City && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
