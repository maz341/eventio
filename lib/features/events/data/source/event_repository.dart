import 'package:eventio/features/events/data/source/events_api_service.dart';
import '../../domain/models/event.dart';

class EventsRepository {
  const EventsRepository({required this.apiService});

  final EventsApiService apiService;

  Future<List<Event>> getEvents() {
    return apiService.fetchEvents();
  }
}
