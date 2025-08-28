import 'dart:io';
import 'dart:typed_data';

abstract class FileStorage {
  Future<void> saveFile({
    required String oldPath,
    required String name,
    bool isMove = true,
  });
  Future<void> exportFile({
    required String outPath,
    required String name,
    bool isMove = true,
  });
  Future<void> deleteFile(String path);
  Future<Uint8List?> readFile(String name);
  String getAbsPath(String name);
  Future<List<File>> getAll();
}
