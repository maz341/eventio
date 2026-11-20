import 'package:eventio/features/events/data/source/event_repository.dart';
import 'package:eventio/features/events/data/source/events_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:eventio/features/events/domain/models/event.dart';

import 'helpers/fake_events_local_service.dart';

void main() {
  final event = Event(
    id: '101',
    title: 'Coffee & Bites at Harbourfront',
    location: 'Harbourfront Centre, Toronto',
    startsAt: DateTime(2026, 11, 24, 12),
    imageUrl: 'https://example.com/event.jpg',
    latitude: 43.6388,
    longitude: -79.3817,
  );

  group('EventsRepository', () {
    test('get saved events if cache is not expired', () async {
      var apiCalls = 0;

      final client = MockClient((request) async {
        apiCalls++;
        return http.Response('[]', 200);
      });
      addTearDown(client.close);

      final local = FakeEventsLocalService(
        events: [event],
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );

      final repository = EventsRepository(
        apiService: EventsApiService(
          client: client,
          baseUrl: 'http://localhost:3000',
        ),
        localService: local,
      );

      final result = await repository.getEvents();

      expect(result.events.single.id, event.id);
      expect(result.isStale, false);
      expect(apiCalls, 0);
    });

    test('use saved events if API is not working', () async {
      var apiCalls = 0;

      final client = MockClient((request) async {
        apiCalls++;
        return http.Response('Service unavailable', 503);
      });
      addTearDown(client.close);

      final local = FakeEventsLocalService(
        events: [event],
        fetchedAt: DateTime.now().subtract(const Duration(hours: 1)),
      );

      final repository = EventsRepository(
        apiService: EventsApiService(
          client: client,
          baseUrl: 'http://localhost:3000',
        ),
        localService: local,
      );

      final result = await repository.getEvents();

      expect(apiCalls, 1);
      expect(result.events.single.id, event.id);
      expect(result.isStale, true);
    });

    test('save and remove event bookmarks', () async {
      final client = MockClient((request) async => http.Response('[]', 200));
      addTearDown(client.close);

      final local = FakeEventsLocalService(events: [event]);

      final repository = EventsRepository(
        apiService: EventsApiService(
          client: client,
          baseUrl: 'http://localhost:3000',
        ),
        localService: local,
      );

      expect(await repository.getBookmarkedEvents(), isEmpty);

      await repository.toggleBookmark(event.id);

      final saved = await repository.getBookmarkedEvents();

      expect(saved.length, 1);
      expect(saved.first.id, event.id);

      await repository.toggleBookmark(event.id);

      expect(await repository.getBookmarkedEvents(), isEmpty);
    });
  });
}
