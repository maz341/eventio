import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/models/event.dart';

class EventsLocalService {
  EventsLocalService(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<List<Event>> getCurrentEvents() async {
    final db = await _appDatabase.database;

    final rows = await db.query(
      'events',
      where: 'in_feed = ?',
      whereArgs: [1],
      orderBy: 'starts_at_ms ASC',
    );

    return rows.map(_eventFromRow).toList();
  }

  Future<void> saveFetchedEvents(List<Event> events, DateTime fetchedAt) async {
    final db = await _appDatabase.database;

    await db.transaction((txn) async {
      await txn.update('events', {'in_feed': 0});

      final batch = txn.batch();

      for (final event in events) {
        batch.rawInsert(
          '''
          INSERT INTO events (
            id, title, location, starts_at_ms,
            image_url, latitude, longitude, in_feed
          ) VALUES (?, ?, ?, ?, ?, ?, ?, 1)
          ON CONFLICT(id) DO UPDATE SET
            title = excluded.title,
            location = excluded.location,
            starts_at_ms = excluded.starts_at_ms,
            image_url = excluded.image_url,
            latitude = excluded.latitude,
            longitude = excluded.longitude,
            in_feed = 1
        ''',
          [
            event.id,
            event.title,
            event.location,
            event.startsAt.millisecondsSinceEpoch,
            event.imageUrl,
            event.latitude,
            event.longitude,
          ],
        );
      }

      batch.insert('cache_metadata', {
        'cache_key': 'events',
        'fetched_at_ms': fetchedAt.millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      await batch.commit(noResult: true);
    });
  }

  Future<DateTime?> getLastFetchedAt() async {
    final db = await _appDatabase.database;

    final rows = await db.query(
      'cache_metadata',
      columns: ['fetched_at_ms'],
      where: 'cache_key = ?',
      whereArgs: ['events'],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final timestamp = rows.first['fetched_at_ms'] as int;

    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  Future<void> toggleBookmark(String eventId) async {
    final db = await _appDatabase.database;

    await db.transaction((txn) async {
      final existing = await txn.query(
        'bookmarks',
        columns: ['event_id'],
        where: 'event_id = ?',
        whereArgs: [eventId],
        limit: 1,
      );

      if (existing.isEmpty) {
        await txn.insert('bookmarks', {'event_id': eventId});
      } else {
        await txn.delete(
          'bookmarks',
          where: 'event_id = ?',
          whereArgs: [eventId],
        );
      }
    });
  }

  Future<List<Event>> getBookmarkedEvents() async {
    final db = await _appDatabase.database;

    final rows = await db.rawQuery('''
    SELECT e.*
    FROM events AS e
    INNER JOIN bookmarks AS b
      ON b.event_id = e.id
    ORDER BY e.starts_at_ms ASC
  ''');

    return rows.map(_eventFromRow).toList();
  }

  Event _eventFromRow(Map<String, Object?> row) {
    return Event(
      id: row['id'] as String,
      title: row['title'] as String,
      location: row['location'] as String,
      startsAt: DateTime.fromMillisecondsSinceEpoch(row['starts_at_ms'] as int),
      imageUrl: row['image_url'] as String,
      latitude: (row['latitude'] as num).toDouble(),
      longitude: (row['longitude'] as num).toDouble(),
    );
  }
}
