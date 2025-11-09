import 'package:text_reader/app/ui/bookmark/bookmark.dart';
import 'package:text_reader/app/core/interfaces/file_storage.dart';
import 'package:text_reader/app/core/interfaces/json_database.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/core/path_util.dart';

class BookmarkDatabase extends JsonDatabase<Bookmark> {
  BookmarkDatabase()
    : super(
        root: PathUtil.getLibaryPath(name: 'bookmark.db.json'),
        storage: FileStorage(root: PathUtil.getLibaryPath()),
      );


  @override
  Bookmark from(Map<String, dynamic> map) {
    return Bookmark.fromMap(map);
  }

  @override
  Map<String, dynamic> to(Bookmark value) {
    return value.toMap();
  }

  @override
  Future<void> update(String id, Bookmark value) async {
    final list = await getAll();
    final index = list.indexWhere((e) => e.id == id);
    if (index == -1) return;
    list[index] = value;
    await save(list);
  }

  @override
  Future<void> delete(String id) async {
    final list = await getAll();
    final index = list.indexWhere((e) => e.id == id);
    if (index == -1) return;
    list.removeAt(index);
    await save(list);
  }
}
