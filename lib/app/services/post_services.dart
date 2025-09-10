import 'package:text_reader/app/bookmark/bookmark_services.dart';
import 'package:text_reader/app/core/factory/database_factory.dart';
import 'package:text_reader/app/core/interfaces/database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/core/types/database_types.dart';

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

  static Future<String> getAbsPath(String name) async {
    final db = PostServices.getDB;
    return db.storage.root;
  }

  static void clearDBCache() {
    _cacheDB.clear();
    BookmarkServices.clearDB();
  }

  static Database<Post> get getDB {
    final dbType = DatabaseTypes.folder;
    final db = _cacheDB[dbType.name];
    if (db == null) {
      _cacheDB[dbType.name] = DatabaseFactory.create<Post>(type: dbType);
    }

    return _cacheDB[dbType.name]!;
  }
}
