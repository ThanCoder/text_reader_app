// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:text_reader/app/core/interfaces/file_storage.dart';
import 'package:than_pkg/than_pkg.dart';

class FolderFileStorage extends FileStorage {
  String baseDir;
  FolderFileStorage({required this.baseDir});

  @override
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) return;
    await file.delete();
  }

  @override
  Future<List<File>> getAll() async {
    final dir = Directory(baseDir);
    if (!dir.existsSync()) return [];
    List<File> files = [];
    for (var file in dir.listSync()) {
      if (!file.isFile) continue;
      files.add(File(file.path));
    }
    return files;
  }

  @override
  String getAbsPath(String name) {
    return '$baseDir/$name';
  }

  @override
  Future<Uint8List?> readFile(String name) async {
    final file = File(getAbsPath(name));
    if (!file.existsSync()) return null;
    return await file.readAsBytes();
  }

  @override
  Future<void> saveFile({
    required String oldPath,
    required String name,
    bool isMove = true,
  }) async {
    final file = File(oldPath);
    if (!file.existsSync()) return;
    if (isMove) {
      await file.rename(getAbsPath(name));
    } else {
      await file.copy(getAbsPath(name));
    }
  }

  @override
  Future<void> exportFile({
    required String outPath,
    required String name,
    bool isMove = true,
  }) {
    // TODO: implement exportFile
    throw UnimplementedError();
  }
}
