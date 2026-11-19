import 'package:eventio/features/events/data/source/event_local_service.dart';
import 'package:eventio/features/events/data/source/events_api_service.dart';
import '../../domain/models/event.dart';

class EventsFetchResult {
  const EventsFetchResult({required this.events, required this.isStale});

  final List<Event> events;
  final bool isStale;
}

class EventsRepository {
  EventsRepository({required this.apiService, required this.localService});

  final EventsApiService apiService;
  final EventsLocalService localService;

  static const cacheDuration = Duration(minutes: 30);

  Future<EventsFetchResult> getEvents({bool forceRefresh = false}) async {
    final lastFetchedAt = await localService.getLastFetchedAt();

    final cacheAge = lastFetchedAt == null
        ? null
        : DateTime.now().difference(lastFetchedAt);

    final isCacheFresh =
        cacheAge != null && !cacheAge.isNegative && cacheAge < cacheDuration;

    if (!forceRefresh && isCacheFresh) {
      final events = await localService.getCurrentEvents();

      return EventsFetchResult(events: events, isStale: false);
    }

    late final List<Event> fetchedEvents;

    try {
      fetchedEvents = await apiService.fetchEvents();
    } catch (_) {
      if (lastFetchedAt == null) rethrow;

      final cachedEvents = await localService.getCurrentEvents();

      return EventsFetchResult(events: cachedEvents, isStale: true);
    }

    await localService.saveFetchedEvents(fetchedEvents, DateTime.now());

    final savedEvents = await localService.getCurrentEvents();

    return EventsFetchResult(events: savedEvents, isStale: false);
  }

  Future<List<Event>> getBookmarkedEvents() {
    return localService.getBookmarkedEvents();
  }

  Future<void> toggleBookmark(String eventId) {
    return localService.toggleBookmark(eventId);
  }
}
