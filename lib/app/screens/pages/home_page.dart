import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/bookmark/bookmark_button.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/routes_helper.dart';
import 'package:text_reader/app/services/post_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Reader App'),
        actions: [
          IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert_rounded)),
        ],
      ),
      body: CustomScrollView(slivers: [_getListWidget()]),
    );
  }

  Widget _getListWidget() {
    return FutureBuilder(
      future: PostServices.getAll(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(child: Center(child: TLoader.random()));
        }
        final list = snapshot.data ?? [];
        return SliverList.separated(
          itemCount: list.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final post = list[index];
            return ListTile(
              title: Text(post.title),
              trailing: BookmarkButton(post: post),
              onTap: () {
                goTextReader(context, post: post);
              },
            );
          },
        );
      },
    );
  }

  // main menu
  void _showMenu() {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.add),
          title: Text('New Post'),
          onTap: () {
            Navigator.pop(context);
            _newPost();
          },
        ),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('New Post From Fetcher'),
          onTap: () {
            Navigator.pop(context);
            _newPostFromFetcher();
          },
        ),
      ],
    );
  }

  void _newPost() {
    // final box = Post.getBox;
    // final post = Post.create();
    // box.put(post.id, post);
    // goRoute(
    //   context,
    //   builder: (context) => EditPostScreen(
    //     post: post,
    //     isUpdate: true,
    //     onUpdated: (updatedPost) {
    //       Post.getBox.put(updatedPost.id, updatedPost);
    //     },
    //   ),
    // );
  }

  void _newPostFromFetcher() {
    // goRoute(
    //   context,
    //   builder: (context) => FetcherScreen(
    //     onFetched: (data) {
    //       final box = Post.getBox;
    //       final post = Post.create(title: data.title, body: data.contentText);
    //       box.put(post.id, post);
    //       goRoute(
    //         context,
    //         builder: (context) => EditPostScreen(
    //           post: post,
    //           isUpdate: true,
    //           onUpdated: (updatedPost) {
    //             Post.getBox.put(updatedPost.id, updatedPost);
    //           },
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  // item menu
  void _showItemMenu(Post post) {
    showTMenuBottomSheet(
      context,
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(post.title)),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit_document),
          title: Text('Edit'),
          onTap: () {
            Navigator.pop(context);
            _editPost(post);
          },
        ),
        ListTile(
          iconColor: Colors.red,
          leading: Icon(Icons.delete),
          title: Text('Delete'),
          onTap: () {
            Navigator.pop(context);
            _deleteConfirm(post);
          },
        ),
      ],
    );
  }

  void _editPost(Post post) {
    // goRoute(
    //   context,
    //   builder: (context) => EditPostScreen(
    //     post: post,
    //     onUpdated: (updatedPost) {
    //       Post.getBox.put(updatedPost.id, updatedPost);
    //     },
    //   ),
    // );
  }

  void _deleteConfirm(Post post) {
    showTConfirmDialog(
      context,
      contentText: 'ဖျက်ချင်တာ သေချာပြီလား?',
      submitText: 'Delete',
      onSubmit: () {
        post.delete();
      },
    );
  }
}
