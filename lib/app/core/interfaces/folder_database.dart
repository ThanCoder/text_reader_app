import 'package:text_reader/app/core/interfaces/database.dart';

abstract class FolderDatabase<T> extends Database<T> {
  String baseDir;

  FolderDatabase({required this.baseDir, required super.fileStorage});
}
