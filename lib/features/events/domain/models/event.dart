

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




factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      startsAt: DateTime.parse(json['startsAt'] as String),
      imageUrl: json['imageUrl'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

}
