import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Future<Database>? _databaseFuture;
  Future<Database> get database => _databaseFuture ??= _open();
  Future<Database> _open() async {
    final directory = await getDatabasesPath();
    final filePath = join(directory, 'eventio.db');
    return openDatabase(
      filePath,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id TEXT PRIMARY KEY, -- Unique event identifier
            title TEXT NOT NULL, -- Event name
            location TEXT NOT NULL, -- Event address
            starts_at_ms INTEGER NOT NULL, -- Event date as milliseconds
            image_url TEXT NOT NULL, -- Remote event image URL
            latitude REAL NOT NULL, -- Event latitude
            longitude REAL NOT NULL, -- Event longitude
            in_feed INTEGER NOT NULL DEFAULT 1 -- 1 if in latest API list
          )
        ''');
        await db.execute('''
          CREATE TABLE bookmarks (
            event_id TEXT PRIMARY KEY, -- One bookmark per event
            FOREIGN KEY (event_id)
              REFERENCES events(id) ON DELETE RESTRICT
              -- Prevent deleting an event that is bookmarked
          )
        ''');
        await db.execute('''
          CREATE TABLE cache_metadata (
            cache_key TEXT PRIMARY KEY, -- Identifies cached data
            fetched_at_ms INTEGER NOT NULL -- Last successful fetch time
          )
        ''');
      },
    );
  }
}
