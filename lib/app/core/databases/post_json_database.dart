import 'dart:io';

import 'package:text_reader/app/core/interfaces/file_storage.dart';
import 'package:text_reader/app/core/interfaces/json_database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/core/index.dart';
import 'package:uuid/uuid.dart';

class PostJsonDatabase extends JsonDatabase<Post> {
  PostJsonDatabase()
    : super(
        root: PathUtil.getDatabasePath(name: 'post.db.json'),
        storage: FileStorage(root: PathUtil.getDatabaseSourcePath()),
      );
  @override
  Future<Post> add(Post value) async {
    value.id = Uuid().v4();
    final list = await getAll();
    list.add(value);
    await save(list);
    return value;
  }

  @override
  Future<void> delete(String id) async {
    final list = await getAll();
    final index = list.indexWhere((e) => e.id == id);
    if (index == -1) return;
    // remove storage
    final dir = Directory('${await storage.getPath(id)}');
    if (dir.existsSync()) {
      await PathUtil.deleteDir(dir);
    }
    // remove db
    list.removeAt(index);
    await save(list);
  }

  @override
  Post from(Map<String, dynamic> map) {
    return Post.fromMap(map);
  }

  @override
  Map<String, dynamic> to(Post value) {
    return value.toMap();
  }

  @override
  Future<void> update(String id, Post value) async {
    final list = await getAll();
    final index = list.indexWhere((e) => e.id == id);
    if (index == -1) return;
    value.id = id;
    list[index] = value;
    await save(list);
  }
}
