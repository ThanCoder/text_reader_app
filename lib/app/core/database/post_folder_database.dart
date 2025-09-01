import 'dart:io';

import 'package:text_reader/app/core/interfaces/folder_database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/other_libs/setting_v2.2.0/core/index.dart';
import 'package:than_pkg/than_pkg.dart';

class PostFolderDatabase extends FolderDatabase<Post> {
  PostFolderDatabase({required super.root, required super.fileStorage});

  @override
  Future<void> add(Post value) async {
    final title = value.title;
    final dir = Directory('$root/$title');
    if (dir.existsSync()) return;
    await dir.create(recursive: true);
    notify();
  }

  @override
  Future<void> delete(Post value) async {
    final title = value.title;
    final dir = Directory('$root/$title');
    await PathUtil.deleteDir(dir);
    notify();
  }

  @override
  Future<List<Post>> getAll() async {
    final dir = Directory(root);
    if (!dir.existsSync()) return [];
    List<Post> list = [];
    for (var file in dir.listSync()) {
      if (!file.isDirectory) continue;
      final post = Post.create(
        id: file.getName(),
        title: file.getName(),
        date: file.statSync().modified,
      );
      list.add(post);
    }
    return list;
  }

  @override
  Future<void> update(Post value) async {
    if (value.id == value.title) return;

    final oldDir = Directory('$root/${value.id}');
    final newDir = Directory('$root/${value.title}');
    if (!newDir.existsSync()) {
      await newDir.create();
    }
    // move new dir
    for (var file in oldDir.listSync(followLinks: false)) {
      await file.rename('${newDir.path}/${file.getName()}');
    }
    await oldDir.delete(recursive: true);
    // refresh
    notify();
  }

  String get getroot => root;
}
