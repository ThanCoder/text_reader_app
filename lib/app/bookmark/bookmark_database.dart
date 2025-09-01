import 'package:text_reader/app/bookmark/bookmark.dart';
import 'package:text_reader/app/core/interfaces/json_database.dart';

class BookmarkDatabase extends JsonDatabase<Bookmark> {
  BookmarkDatabase({required super.root, required super.fileStorage});

  @override
  Future<void> delete(Bookmark value) async {
    final list = await getAll();
    final index = list.indexWhere((e) => e.id == value.id);
    if (index == -1) return;
    list.removeAt(index);
    await save(list);
  }

  @override
  Bookmark from(Map<String, dynamic> map) {
    return Bookmark.fromMap(map);
  }

  @override
  Map<String, dynamic> to(Bookmark value) {
    return value.toMap();
  }

  @override
  Future<void> update(Bookmark value) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
