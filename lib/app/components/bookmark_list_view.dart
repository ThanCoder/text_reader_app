import 'package:apyar/app/models/index.dart';
import 'package:apyar/app/notifiers/app_notifier.dart';
import 'package:flutter/material.dart';

import '../widgets/index.dart';

class BookmarkListView extends StatelessWidget {
  List<BookmarkModel> list;
  void Function(BookmarkModel book) onClick;
  BookmarkListView({
    super.key,
    required this.list,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 220,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        final apyar = list[index];
        return GestureDetector(
          onTap: () => onClick(apyar),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: MyImageFile(
                        path: '',
                        borderRadius: 5,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkThemeNotifier.value
                          ? const Color.fromARGB(197, 12, 12, 12)
                          : const Color.fromARGB(197, 156, 156, 156),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      apyar.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
