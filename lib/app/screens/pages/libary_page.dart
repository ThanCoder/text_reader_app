import 'package:flutter/material.dart';
import 'package:t_widgets/widgets/t_loader.dart';
import 'package:text_reader/app/bookmark/bookmark_services.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/routes_helper.dart';
import 'package:text_reader/app/services/post_services.dart';

class LibaryPage extends StatefulWidget {
  const LibaryPage({super.key});

  @override
  State<LibaryPage> createState() => _LibaryPageState();
}

class _LibaryPageState extends State<LibaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text('Libary')),
          _getBookmarkList(),
        ],
      ),
    );
  }

  Widget _getBookmarkList() {
    return FutureBuilder(
      future: BookmarkServices.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(child: TLoader.random());
        }
        final list = snapshot.data ?? [];
        return SliverList.separated(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final book = list[index];
            return ListTile(
              title: Text(book.title),
              onTap: () async {
                final path = await PostServices.getAbsPath(book.id);
                final post = Post.fromPath(path);
                if (!context.mounted) return;
                goTextReader(context, post: post);
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
        );
      },
    );
  }
}
