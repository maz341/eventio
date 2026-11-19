import 'package:eventio/features/events/data/source/event_repository.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/event.dart';

class EventsViewModel extends ChangeNotifier {
  EventsViewModel(this._repository);

  final EventsRepository _repository;

  List<Event> _events = [];
  bool _isLoading = false;
  bool _isStale = false;
  String? _error;

  List<Event> _bookmarkedEvents = [];
  Set<String> _bookmarkedIds = {};

  bool _isBookmarksLoading = true;
  String? _bookmarksError;

  final Set<String> _savingBookmarkIds = {};

  List<Event> get bookmarkedEvents => List.unmodifiable(_bookmarkedEvents);

  bool get isBookmarksLoading => _isBookmarksLoading;
  String? get bookmarksError => _bookmarksError;

  bool isBookmarked(String eventId) => _bookmarkedIds.contains(eventId);

  bool isBookmarkSaving(String eventId) => _savingBookmarkIds.contains(eventId);

  List<Event> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;
  bool get isStale => _isStale;
  String? get error => _error;

  Future<void> loadEvents({bool forceRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.getEvents(forceRefresh: forceRefresh);

      _events = result.events;
      _isStale = result.isStale;
    } catch (e) {
      debugPrint('Failed to load events: $e');
      _error = 'Could not load events. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBookmarks() async {
    _isBookmarksLoading = true;
    _bookmarksError = null;
    notifyListeners();

    try {
      final saved = await _repository.getBookmarkedEvents();

      _bookmarkedEvents = saved;
      _bookmarkedIds = saved.map((event) => event.id).toSet();
    } catch (error) {
      debugPrint('Failed to load bookmarks: $error');
      _bookmarksError = 'Could not load saved events.';
    } finally {
      _isBookmarksLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleBookmark(String eventId) async {
    if (_savingBookmarkIds.contains(eventId)) {
      return false;
    }

    _savingBookmarkIds.add(eventId);
    notifyListeners();

    try {
      await _repository.toggleBookmark(eventId);

      final saved = await _repository.getBookmarkedEvents();

      _bookmarkedEvents = saved;
      _bookmarkedIds = saved.map((event) => event.id).toSet();
      _bookmarksError = null;

      return true;
    } catch (error) {
      debugPrint('Failed to update bookmark: $error');
      _bookmarksError = 'Could not update bookmark.';
      return false;
    } finally {
      _savingBookmarkIds.remove(eventId);
      notifyListeners();
    }
  }
}
