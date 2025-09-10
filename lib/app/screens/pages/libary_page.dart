import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/bookmark/bookmark.dart';
import 'package:text_reader/app/bookmark/bookmark_services.dart';
import 'package:text_reader/app/core/interfaces/database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/routes_helper.dart';
import 'package:text_reader/app/services/post_services.dart';

class LibaryPage extends StatefulWidget {
  const LibaryPage({super.key});

  @override
  State<LibaryPage> createState() => _LibaryPageState();
}

class _LibaryPageState extends State<LibaryPage> with DatabaseListener {
  @override
  void initState() {
    BookmarkServices.getDB.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    BookmarkServices.getDB.removeListener(this);
    super.dispose();
  }

  @override
  void onDatabaseChanged() {
    if (!mounted) return;
    setState(() {});
  }

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
              onLongPress: () => _showItemMenu(book),
            );
          },
          separatorBuilder: (context, index) => Divider(),
        );
      },
    );
  }

  // item menu
  void _showItemMenu(Bookmark book) {
    showTMenuBottomSheet(
      context,
      title: Text(book.title),
      children: [
        ListTile(
          iconColor: Colors.red,
          leading: Icon(Icons.delete),
          title: Text('Remove'),
          onTap: () {
            Navigator.pop(context);
            _removeConfirm(book);
          },
        ),
      ],
    );
  }

  void _removeConfirm(Bookmark book) {
    showTConfirmDialog(
      context,
      contentText: 'ဖျက်ချင်တာ သေချာပြီလား?',
      submitText: 'Remove',
      onSubmit: () {
        BookmarkServices.getDB.delete(book.id);
      },
    );
  }
}
