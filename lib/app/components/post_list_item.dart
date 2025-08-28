import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:than_pkg/than_pkg.dart';

class PostListItem extends StatelessWidget {
  Post post;
  void Function(Post post) onClicked;
  void Function(Post post)? onRightClicked;
  PostListItem({
    super.key,
    required this.post,
    required this.onClicked,
    this.onRightClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClicked(post),
      onSecondaryTap: () {
        if (onRightClicked == null) return;
        onRightClicked!(post);
      },
      onLongPress: () {
        if (onRightClicked == null) return;
        onRightClicked!(post);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Card(
          child: Row(
            spacing: 5,
            children: [
              SizedBox(width: 130, height: 140, child: TImage(source: '')),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                    Text('ရက်စွဲ: ${post.date.toParseTime()}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
