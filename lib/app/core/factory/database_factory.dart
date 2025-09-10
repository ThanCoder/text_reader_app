import 'package:text_reader/app/core/databases/post_folder_database.dart';
import 'package:text_reader/app/core/interfaces/index.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/core/types/database_types.dart';

class DatabaseFactory {
  static Database<T> create<T>({required DatabaseTypes type}) {
    if (type == DatabaseTypes.folder) {
      if (T == Post) {
        return PostFolderDatabase() as Database<T>;
      }
    }
    if (type == DatabaseTypes.json) {}
    throw UnsupportedError('T Not Supported');
  }
}
