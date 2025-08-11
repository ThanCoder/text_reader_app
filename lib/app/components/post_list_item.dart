import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/models/post_model.dart';
import 'package:than_pkg/than_pkg.dart';

class PostListItem extends StatelessWidget {
  PostModel post;
  void Function(PostModel post) onClicked;
  void Function(PostModel post)? onRightClicked;
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
              SizedBox(
                width: 130,
                height: 140,
                child: TImage(source: post.getCoverPath),
              ),
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
