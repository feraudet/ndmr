import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../codeplug/data/models/models.dart';

/// Represents a cached codeplug with sync metadata
class CachedCodeplug {
  final String id;
  final String? cloudId;
  final String name;
  final Codeplug codeplug;
  final int version;
  final DateTime updatedAt;
  final bool pendingSync;
  final SyncAction? pendingAction;

  CachedCodeplug({
    required this.id,
    this.cloudId,
    required this.name,
    required this.codeplug,
    required this.version,
    required this.updatedAt,
    this.pendingSync = false,
    this.pendingAction,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cloud_id': cloudId,
      'name': name,
      'data': jsonEncode(codeplug.toJson()),
      'version': version,
      'updated_at': updatedAt.toIso8601String(),
      'pending_sync': pendingSync ? 1 : 0,
      'pending_action': pendingAction?.name,
    };
  }

  factory CachedCodeplug.fromMap(Map<String, dynamic> map) {
    return CachedCodeplug(
      id: map['id'] as String,
      cloudId: map['cloud_id'] as String?,
      name: map['name'] as String,
      codeplug: Codeplug.fromJson(jsonDecode(map['data'] as String)),
      version: map['version'] as int,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      pendingSync: (map['pending_sync'] as int) == 1,
      pendingAction: map['pending_action'] != null
          ? SyncAction.values.byName(map['pending_action'] as String)
          : null,
    );
  }

  CachedCodeplug copyWith({
    String? id,
    String? cloudId,
    String? name,
    Codeplug? codeplug,
    int? version,
    DateTime? updatedAt,
    bool? pendingSync,
    SyncAction? pendingAction,
  }) {
    return CachedCodeplug(
      id: id ?? this.id,
      cloudId: cloudId ?? this.cloudId,
      name: name ?? this.name,
      codeplug: codeplug ?? this.codeplug,
      version: version ?? this.version,
      updatedAt: updatedAt ?? this.updatedAt,
      pendingSync: pendingSync ?? this.pendingSync,
      pendingAction: pendingAction ?? this.pendingAction,
    );
  }
}

enum SyncAction { create, update, delete }

/// Service for caching codeplugs locally using SQLite
class LocalCacheService {
  static Database? _database;
  static const String _tableName = 'cached_codeplugs';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ndmr_cache.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            cloud_id TEXT,
            name TEXT NOT NULL,
            data TEXT NOT NULL,
            version INTEGER NOT NULL DEFAULT 0,
            updated_at TEXT NOT NULL,
            pending_sync INTEGER NOT NULL DEFAULT 0,
            pending_action TEXT
          )
        ''');

        await db.execute('''
          CREATE INDEX idx_cloud_id ON $_tableName (cloud_id)
        ''');

        await db.execute('''
          CREATE INDEX idx_pending_sync ON $_tableName (pending_sync)
        ''');
      },
    );
  }

  /// Get all cached codeplugs
  Future<List<CachedCodeplug>> getAllCached() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'updated_at DESC');
    return maps.map((map) => CachedCodeplug.fromMap(map)).toList();
  }

  /// Get a cached codeplug by local ID
  Future<CachedCodeplug?> getById(String id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return CachedCodeplug.fromMap(maps.first);
  }

  /// Get a cached codeplug by cloud ID
  Future<CachedCodeplug?> getByCloudId(String cloudId) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'cloud_id = ?',
      whereArgs: [cloudId],
    );
    if (maps.isEmpty) return null;
    return CachedCodeplug.fromMap(maps.first);
  }

  /// Save or update a cached codeplug
  Future<void> save(CachedCodeplug cached) async {
    final db = await database;
    await db.insert(
      _tableName,
      cached.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete a cached codeplug
  Future<void> delete(String id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get all codeplugs pending sync
  Future<List<CachedCodeplug>> getPendingSync() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'pending_sync = 1',
      orderBy: 'updated_at ASC',
    );
    return maps.map((map) => CachedCodeplug.fromMap(map)).toList();
  }

  /// Mark a codeplug as synced (remove pending flag)
  Future<void> markSynced(String id, {String? cloudId, int? version}) async {
    final db = await database;
    final updates = <String, dynamic>{
      'pending_sync': 0,
      'pending_action': null,
    };
    if (cloudId != null) updates['cloud_id'] = cloudId;
    if (version != null) updates['version'] = version;

    await db.update(
      _tableName,
      updates,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Mark a codeplug for sync
  Future<void> markPendingSync(String id, SyncAction action) async {
    final db = await database;
    await db.update(
      _tableName,
      {
        'pending_sync': 1,
        'pending_action': action.name,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Clear all cached data
  Future<void> clearAll() async {
    final db = await database;
    await db.delete(_tableName);
  }

  /// Get count of pending sync items
  Future<int> getPendingSyncCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName WHERE pending_sync = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
