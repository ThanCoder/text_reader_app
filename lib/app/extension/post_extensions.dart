import 'package:text_reader/app/core/models/post.dart';

extension PostExtensions on List<Post> {
  void sortDate({bool isNewest = true}) {
    sort((a, b) {
      if (isNewest) {
        if (a.date.millisecondsSinceEpoch > b.date.millisecondsSinceEpoch) {
          return -1;
        }
        if (a.date.millisecondsSinceEpoch < b.date.millisecondsSinceEpoch) {
          return 1;
        }
      } else {
        // oldest
        if (a.date.millisecondsSinceEpoch > b.date.millisecondsSinceEpoch) {
          return 1;
        }
        if (a.date.millisecondsSinceEpoch < b.date.millisecondsSinceEpoch) {
          return -1;
        }
      }
      return 0;
    });
  }
}
