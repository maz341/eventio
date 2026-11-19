

class Event {
  const Event({
    required this.id,
    required this.title,
    required this.location,
    required this.startsAt,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String title;
  final String location;
  final DateTime startsAt;
  final String imageUrl;
  final double latitude;
  final double longitude;
}
