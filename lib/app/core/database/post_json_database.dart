import 'package:text_reader/app/core/interfaces/json_database.dart';
import 'package:text_reader/app/core/models/post.dart';

class PostJsonDatabase extends JsonDatabase<Post> {
  PostJsonDatabase({required super.dbPath, required super.fileStorage});

  @override
  Future<void> delete(Post value) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> update(Post value) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Post from(Map<String, dynamic> map) {
    return Post.fromMap(map);
  }

  @override
  Map<String, dynamic> to(Post value) {
    return value.toMap();
  }
}
