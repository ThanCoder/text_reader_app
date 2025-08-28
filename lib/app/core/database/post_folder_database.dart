import 'dart:io';

import 'package:text_reader/app/core/interfaces/folder_database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:than_pkg/than_pkg.dart';

class PostFolderDatabase extends FolderDatabase<Post> {
  PostFolderDatabase({required super.baseDir, required super.fileStorage});

  @override
  Future<void> add(Post value) async {
    final title = value.title;
    final dir = Directory('$baseDir/$title');
    if (dir.existsSync()) return;
    await dir.create(recursive: true);
  }

  @override
  Future<void> delete(Post value) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getAll() async {
    final dir = Directory(baseDir);
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
  Future<void> update(Post value) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
