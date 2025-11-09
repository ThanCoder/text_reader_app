import 'package:text_reader/app/ui/bookmark/bookmark_services.dart';
import 'package:text_reader/app/core/factory/database_factory.dart';
import 'package:text_reader/app/core/interfaces/database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/setting.dart';

class PostServices {
  static final Map<String, Database<Post>> _cacheDB = {};

  static Future<List<Post>> getAll() async {
    final list = await getDB.getAll();
    // sort
    list.sort((a, b) {
      if (a.date.millisecondsSinceEpoch > b.date.millisecondsSinceEpoch) {
        return -1;
      }
      if (a.date.millisecondsSinceEpoch < b.date.millisecondsSinceEpoch) {
        return 1;
      }
      return 0;
    });
    return list;
  }

  static void clearDBCache() {
    _cacheDB.clear();
    BookmarkServices.clearDB();
  }

  static Future<bool> isExists(String title) async {
    final db = await getDB.getAll();
    final index = db.indexWhere((e) => e.title.trim() == title.trim());
    return index != -1;
  }

  static Database<Post> get getDB {
    final dbType = Setting.getAppConfig.databaseType;
    final db = _cacheDB[dbType.name];
    if (db == null) {
      _cacheDB[dbType.name] = DatabaseFactory.create<Post>(type: dbType);
    }

    return _cacheDB[dbType.name]!;
  }
}
