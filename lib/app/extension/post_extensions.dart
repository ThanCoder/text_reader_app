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

  void sortTitle({bool isAtoZ = true}) {
    sort((a, b) {
      if (isAtoZ) {
        return a.title.compareTo(b.title);
      } else {
        return b.title.compareTo(a.title);
      }
    });
  }

  void sortRandom({bool isRandom = true}) {
    if (isRandom) {
      return shuffle();
    } else {
      sortTitle();
    }
  }
}
