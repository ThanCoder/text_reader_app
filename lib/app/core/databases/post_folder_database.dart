import 'dart:io';

import 'package:text_reader/app/core/interfaces/file_storage.dart';
import 'package:text_reader/app/core/interfaces/folder_database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/other_libs/setting_v2.3.0/core/path_util.dart';
import 'package:than_pkg/extensions/index.dart';

class PostFolderDatabase extends FolderDatabase<Post> {
  PostFolderDatabase()
    : super(
        root: PathUtil.getSourcePath(),
        storage: FileStorage(root: PathUtil.getSourcePath()),
      );
  @override
  Future<void> update(String id, Post value) async {
    final oldDir = Directory('$root/$id');
    final newDir = Directory('$root/${value.id}');
    await PathUtil.renameDir(oldDir: oldDir, newDir: newDir);
  }

  @override
  Future<void> add(Post value) async {
    final dir = Directory('$root/${value.id}');
    await dir.create();
  }

  @override
  Post? from(FileSystemEntity file) {
    if (file.isDirectory) {
      return Post.fromPath(file.path);
    }
    return null;
  }
}
