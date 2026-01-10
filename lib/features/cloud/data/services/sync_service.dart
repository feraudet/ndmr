import 'api_service.dart';
import '../../../codeplug/data/models/models.dart';

class CloudCodeplug {
  final String id;
  final String userId;
  final String name;
  final Map<String, dynamic> data;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;

  CloudCodeplug({
    required this.id,
    required this.userId,
    required this.name,
    required this.data,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CloudCodeplug.fromJson(Map<String, dynamic> json) {
    return CloudCodeplug(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      data: json['data'] as Map<String, dynamic>,
      version: json['version'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Codeplug toCodeplug() {
    return Codeplug.fromJson(data);
  }
}

class CloudCodeplugListItem {
  final String id;
  final String name;
  final int version;
  final DateTime updatedAt;

  CloudCodeplugListItem({
    required this.id,
    required this.name,
    required this.version,
    required this.updatedAt,
  });

  factory CloudCodeplugListItem.fromJson(Map<String, dynamic> json) {
    return CloudCodeplugListItem(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class SyncService {
  final ApiService _api;

  SyncService({ApiService? api}) : _api = api ?? ApiService();

  /// List all codeplugs for the current user
  Future<List<CloudCodeplugListItem>> listCodeplugs() async {
    final response = await _api.get('/codeplugs');
    final items = response['items'] as List? ?? [];
    return items
        .map((e) => CloudCodeplugListItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get a specific codeplug by ID
  Future<CloudCodeplug> getCodeplug(String id) async {
    final response = await _api.get('/codeplugs/$id');
    return CloudCodeplug.fromJson(response);
  }

  /// Create a new codeplug
  Future<CloudCodeplug> createCodeplug({
    required String name,
    required Codeplug codeplug,
  }) async {
    final response = await _api.post('/codeplugs', body: {
      'name': name,
      'data': codeplug.toJson(),
    });
    return CloudCodeplug.fromJson(response);
  }

  /// Update an existing codeplug
  Future<CloudCodeplug> updateCodeplug({
    required String id,
    String? name,
    Codeplug? codeplug,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (codeplug != null) body['data'] = codeplug.toJson();

    final response = await _api.put('/codeplugs/$id', body: body);
    return CloudCodeplug.fromJson(response);
  }

  /// Delete a codeplug
  Future<void> deleteCodeplug(String id) async {
    await _api.delete('/codeplugs/$id');
  }

  /// Sync a codeplug (create or update based on version)
  Future<CloudCodeplug> syncCodeplug({
    String? id,
    required String name,
    required Codeplug codeplug,
    int version = 0,
  }) async {
    final response = await _api.post('/codeplugs/sync', body: {
      if (id != null) 'id': id,
      'name': name,
      'data': codeplug.toJson(),
      'version': version,
    });
    return CloudCodeplug.fromJson(response);
  }
}
