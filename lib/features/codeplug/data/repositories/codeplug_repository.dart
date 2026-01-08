import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/models.dart';

part 'codeplug_repository.g.dart';

@riverpod
CodeplugRepository codeplugRepository(CodeplugRepositoryRef ref) =>
    CodeplugRepository();

class CodeplugRepository {
  Future<Codeplug?> loadFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'ndmr'],
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    String content;

    if (file.bytes != null) {
      // Web platform
      content = utf8.decode(file.bytes!);
    } else if (file.path != null) {
      // Desktop/mobile platforms
      content = await File(file.path!).readAsString();
    } else {
      return null;
    }

    final json = jsonDecode(content) as Map<String, dynamic>;
    return Codeplug.fromJson(json);
  }

  Future<bool> saveToFile(Codeplug codeplug) async {
    final json = codeplug.toJson();
    final content = const JsonEncoder.withIndent('  ').convert(json);

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Codeplug',
      fileName: '${codeplug.name}.ndmr',
      type: FileType.custom,
      allowedExtensions: ['ndmr', 'json'],
    );

    if (result == null) return false;

    final file = File(result);
    await file.writeAsString(content);
    return true;
  }

  Future<String> getDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
