import 'package:flutter/foundation.dart';
import '../../data/source/event_repository.dart';
import '../../domain/models/event.dart';

class EventsViewModel extends ChangeNotifier {
  EventsViewModel(this._repository);

  final EventsRepository _repository;

  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEvents() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _repository.getEvents();
    } catch (e) {
      debugPrint('Failed to load events: $e');
      _error = 'Could not load events. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
