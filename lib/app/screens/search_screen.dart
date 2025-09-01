import 'package:flutter/material.dart';
import 'package:text_reader/app/bookmark/bookmark_button.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/routes_helper.dart';

class SearchScreen extends StatelessWidget {
  final List<Post> list;
  const SearchScreen({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: Text('Search Post')),
          _getSearchBar(),
        ],
      ),
    );
  }

  Widget _getSearchBar() {
    return SliverAppBar(
      snap: true,
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      title: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchAnchor.bar(
            isFullScreen: true,
            barHintText: 'Search...',
            barShape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
            ),
            suggestionsBuilder: (context, controller) {
              final text = controller.text.toUpperCase();
              // if (text.isEmpty) return;
              final res = list
                  .where((e) => e.title.toUpperCase().contains(text))
                  .toList();
              return res.map(
                (post) => ListTile(
                  title: Text(post.title),
                  trailing: BookmarkButton(post: post),
                  onTap: () {
                    goTextReader(context, post: post);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
