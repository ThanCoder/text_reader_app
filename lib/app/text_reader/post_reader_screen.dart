import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/core/models/post.dart';

class PostReaderScreen extends StatelessWidget {
  Post post;
  PostReaderScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return TScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text(post.title), snap: true, floating: true),
          SliverAppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: TImage(source: post.getCoverPath, width: 400),
            collapsedHeight: 200,
            expandedHeight: 250,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(post.getBody, style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
