import 'package:text_reader/app/ui/bookmark/bookmark.dart';
import 'package:text_reader/app/ui/bookmark/bookmark_database.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/setting.dart';

class BookmarkServices {
  static BookmarkDatabase? _cacheDB;

  static Future<List<Bookmark>> getAll() async {
    final db = getDB;
    final list = await db.getAll();
    final dbList = list
        .where((e) => e.databaseType == Setting.getAppConfig.databaseType)
        .toList();
    return dbList;
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
    final dbList = list
        .where((e) => e.databaseType == Setting.getAppConfig.databaseType)
        .toList();
    final index = dbList.indexWhere((e) => e.id == id);
    return index != -1;
  }
}
