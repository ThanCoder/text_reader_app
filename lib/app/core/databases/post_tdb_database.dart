import 'package:t_db/t_db.dart';
import 'package:text_reader/app/core/models/post.dart';

class PostTDBDatabase extends TDB<Post> {
  @override
  Post fromMap(Map<String, dynamic> map) {
    return Post.fromMap(map);
  }

  @override
  int getId(Post value) {
    return value.indexId;
  }

  @override
  void setId(Post value, int id) {
    value.indexId = id;
  }

  @override
  Map<String, dynamic> toMap(Post value) {
    return value.toMap();
  }
}
