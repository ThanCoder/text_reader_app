import 'package:text_reader/app/bookmark/bookmark.dart';
import 'package:text_reader/app/bookmark/bookmark_database.dart';

class BookmarkServices {
  static BookmarkDatabase? _cacheDB;

  static Future<List<Bookmark>> getAll() async {
    final db = getDB;
    return db.getAll();
  }

  static BookmarkDatabase get getDB {
    _cacheDB ??= BookmarkDatabase();
    return _cacheDB!;
  }

  static void clearDB() {
    _cacheDB = null;
  }

  static Future<bool> isExists(String id) async {
    final list = await getAll();
    final index = list.indexWhere((e) => e.id == id);
    return index != -1;
  }
}
