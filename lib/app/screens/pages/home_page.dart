import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/components/post_list_item.dart';
import 'package:text_reader/app/extension/post_extensions.dart';
import 'package:text_reader/app/models/post_model.dart';
import 'package:text_reader/app/routes_helper.dart';
import 'package:text_reader/app/screens/forms/edit_post_screen.dart';
import 'package:text_reader/other_libs/fetcher_v1.0.0/fetcher.dart';
import 'package:text_reader/other_libs/fetcher_v1.0.0/others/fetcher_screen.dart';

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
          IconButton(
            onPressed: _showMenu,
            icon: Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: PostModel.getBox.listenable(),
          builder: (context, box, child) {
            final list = box.values.toList();
            list.sortDate();
            return ListView.separated(
                itemBuilder: (context, index) => PostListItem(
                      post: list[index],
                      onRightClicked: _showItemMenu,
                      onClicked: (post) {
                        goRoute(
                          context,
                          builder: (context) => EditPostScreen(
                            post: post,
                            isUpdate: true,
                            onUpdated: (updatedPost) {
                              PostModel.getBox.put(updatedPost.id, updatedPost);
                            },
                          ),
                        );
                      },
                    ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: list.length);
          }),
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
    final box = PostModel.getBox;
    final post = PostModel.create();
    box.put(post.id, post);
    goRoute(
      context,
      builder: (context) => EditPostScreen(
        post: post,
        isUpdate: true,
        onUpdated: (updatedPost) {
          PostModel.getBox.put(updatedPost.id, updatedPost);
        },
      ),
    );
  }

  void _newPostFromFetcher() {
    goRoute(
      context,
      builder: (context) => FetcherScreen(
        onFetched: (data) {
          final box = PostModel.getBox;
          final post = PostModel.create(
            title: data.title,
            body: data.contentText,
          );
          box.put(post.id, post);
          goRoute(
            context,
            builder: (context) => EditPostScreen(
              post: post,
              isUpdate: true,
              onUpdated: (updatedPost) {
                PostModel.getBox.put(updatedPost.id, updatedPost);
              },
            ),
          );
        },
      ),
    );
  }

  // item menu
  void _showItemMenu(PostModel post) {
    showTMenuBottomSheet(context, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(post.title),
      ),
      Divider(),
      ListTile(
        iconColor: Colors.red,
        leading: Icon(Icons.delete),
        title: Text('Delete'),
        onTap: () {
          Navigator.pop(context);
          _deleteConfirm(post);
        },
      )
    ]);
  }

  void _deleteConfirm(PostModel post) {
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
