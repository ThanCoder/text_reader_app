import 'package:text_reader/app/bookmark/bookmark.dart';
import 'package:text_reader/app/bookmark/bookmark_database.dart';
import 'package:text_reader/app/core/file_storage/folder_file_storage.dart';
import 'package:text_reader/other_libs/setting_v2.2.0/core/path_util.dart';

class BookmarkServices {
  static BookmarkDatabase? _cacheDB;

  static Future<List<Bookmark>> getAll() async {
    final db = await getDB();
    return db.getAll();
  }

  static Future<BookmarkDatabase> getDB() async {
    _cacheDB ??= BookmarkDatabase(
      dbPath: '${PathUtil.getLibaryPath()}/bookmark.db.json',
      fileStorage: FolderFileStorage(baseDir: PathUtil.getSourcePath()),
    );
    return _cacheDB!;
  }

  static Future<bool> isExists(String id) async {
    final list = await getAll();
    final index = list.indexWhere((e) => e.id == id);
    return index != -1;
  }
}
