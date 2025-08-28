import 'package:text_reader/app/core/factory/database_factory.dart';
import 'package:text_reader/app/core/interfaces/database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/core/types/database_types.dart';
import 'package:text_reader/other_libs/setting_v2.2.0/core/path_util.dart';

class PostServices {
  static final Map<String, Database<Post>> _cacheDB = {};
  static Future<List<Post>> getAll() async {
    final db = await getDB();
    final list = await db.getAll();
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
    final db = await PostServices.getDB();
    return db.fileStorage.getAbsPath(name);
  }

  static Future<Database<Post>> getDB() async {
    final dbType = DatabaseTypes.folder;
    final db = _cacheDB[dbType.name];
    if (db == null) {
      _cacheDB[dbType.name] = DatabaseFactory.create<Post>(
        baseDir: PathUtil.getSourcePath(),
        dbPath: '${PathUtil.getDatabasePath()}/main.db.json',
        type: dbType,
      );
    }

    return _cacheDB[dbType.name]!;
  }
}
