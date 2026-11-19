import '../domain/models/event.dart';

final sampleEvents = [
  Event(
    id: '1',
    title: 'Toronto Music Festival',
    location: 'Nathan Phillips Square, Toronto',
    startsAt: DateTime.now().add(const Duration(days: 3)),
    imageUrl:
        'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=900',
    latitude: 43.6525,
    longitude: -79.3835,
  ),
  Event(
    id: '2',
    title: 'Food & Culture Festival',
    location: 'Harbourfront Centre, Toronto',
    startsAt: DateTime.now().add(const Duration(days: 5)),
    imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=900',
    latitude: 43.6388,
    longitude: -79.3817,
  ),
  Event(
    id: '3',
    title: 'Community Meetup',
    location: 'Toronto, Ontario',
    startsAt: DateTime.now().add(const Duration(days: 7)),
    imageUrl:
        'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=900',
    latitude: 43.6532,
    longitude: -79.3832,
  ),
];
