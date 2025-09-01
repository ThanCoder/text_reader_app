import 'package:text_reader/app/core/interfaces/database.dart';

abstract class FolderDatabase<T> extends Database<T> {
  FolderDatabase({required super.root, required super.fileStorage});
}
