import 'package:text_reader/app/core/database/post_folder_database.dart';
import 'package:text_reader/app/core/database/post_json_database.dart';
import 'package:text_reader/app/core/file_storage/folder_file_storage.dart';
import 'package:text_reader/app/core/interfaces/database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/core/types/database_types.dart';

class DatabaseFactory {
  static Database<T> create<T>({
    required DatabaseTypes type,
    required String baseDir,
    required String dbPath,
  }) {
    if (T == Post) {
      if (type == DatabaseTypes.folder) {
        final db = PostFolderDatabase(
          root: baseDir,
          fileStorage: FolderFileStorage(baseDir: baseDir),
        );
        return db as Database<T>;
      }
      if (type == DatabaseTypes.json) {
        final db = PostJsonDatabase(
          root: dbPath,
          fileStorage: FolderFileStorage(baseDir: baseDir),
        );
        return db as Database<T>;
      }
    }
    throw UnsupportedError('[$T] Database Unsupported!');
  }
}
