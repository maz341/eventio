import 'package:eventio/core/database/app_database.dart';
import 'package:eventio/features/events/data/source/event_local_service.dart';
import 'package:eventio/features/events/domain/models/event.dart';

class FakeEventsLocalService extends EventsLocalService {
  FakeEventsLocalService({required List<Event> events, this.fetchedAt})
    : _events = List.of(events),
      super(AppDatabase());

  List<Event> _events;
  DateTime? fetchedAt;

  final Set<String> _bookmarkedIds = {};

  @override
  Future<DateTime?> getLastFetchedAt() async => fetchedAt;

  @override
  Future<List<Event>> getCurrentEvents() async {
    return List.of(_events);
  }

  @override
  Future<void> saveFetchedEvents(List<Event> events, DateTime timestamp) async {
    _events = List.of(events);
    fetchedAt = timestamp;
  }

  @override
  Future<List<Event>> getBookmarkedEvents() async {
    return _events.where((event) => _bookmarkedIds.contains(event.id)).toList();
  }

  @override
  Future<void> toggleBookmark(String eventId) async {
    if (!_bookmarkedIds.add(eventId)) {
      _bookmarkedIds.remove(eventId);
    }
  }
}
