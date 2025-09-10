import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/bookmark/bookmark_button.dart';
import 'package:text_reader/app/core/interfaces/database.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/extension/post_extensions.dart';
import 'package:text_reader/app/routes_helper.dart';
import 'package:text_reader/app/screens/forms/edit_post_screen.dart';
import 'package:text_reader/app/screens/search_screen.dart';
import 'package:text_reader/app/services/post_services.dart';
import 'package:than_pkg/than_pkg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with DatabaseListener {
  final searchController = SearchController();

  @override
  void initState() {
    PostServices.getDB.addListener(this);
    super.initState();
    init();
  }

  @override
  void onDatabaseChanged() {
    if (!mounted) return;
    init();
  }

  @override
  void dispose() {
    PostServices.getDB.removeListener(this);
    super.dispose();
  }

  bool isLoading = false;
  List<Post> postList = [];
  List<Post> searchResult = [];
  // sort
  List<TSort> sortList = [
    ...TSort.getDefaultList,
    TSort(id: 1, title: 'Random', ascTitle: 'Random', descTitle: 'No Random'),
  ];
  int sortId = TSort.getDateId;
  bool isSortIsAsc = true;

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      postList = await PostServices.getAll();

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      _onSort();
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: CustomScrollView(slivers: [_getAppBar(), _getListWidget()]),
      ),
    );
  }

  Widget _getAppBar() {
    return SliverAppBar(
      floating: true,
      snap: false,
      title: Text('Text Reader App'),
      actions: [
        !TPlatform.isDesktop
            ? SizedBox.shrink()
            : IconButton(onPressed: init, icon: Icon(Icons.refresh)),
        IconButton(onPressed: _showSearch, icon: Icon(Icons.search)),
        IconButton(onPressed: _showSort, icon: Icon(Icons.sort)),
        IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert_rounded)),
      ],
    );
  }

  Widget _getListWidget() {
    if (isLoading) {
      return SliverFillRemaining(child: Center(child: TLoader.random()));
    }
    return SliverList.separated(
      itemCount: postList.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final post = postList[index];
        return _getListItem(post);
      },
    );
  }

  Widget _getListItem(Post post) {
    return ListTile(
      title: Text(post.title),
      trailing: BookmarkButton(post: post),
      onTap: () {
        goTextReader(context, post: post);
      },
      onLongPress: () => _showItemMenu(post),
    ).animate(delay: Duration(milliseconds: 400)).slideX();
  }

  // sort
  void _showSort() {
    showTSortDialog(
      context,
      currentId: sortId,
      sortList: sortList,
      isAsc: isSortIsAsc,
      submitText: Text('Sort'),
      sortDialogCallback: (id, isAsc) {
        isSortIsAsc = isAsc;
        sortId = id;
        _onSort();
      },
    );
  }

  void _onSort() {
    if (sortId == TSort.getDateId) {
      postList.sortDate(isNewest: isSortIsAsc);
    }
    if (sortId == TSort.getTitleId) {
      postList.sortTitle(isAtoZ: isSortIsAsc);
    }
    if (sortId == 1) {
      postList.sortRandom(isRandom: isSortIsAsc);
    }
    setState(() {});
  }

  void _showSearch() {
    goRoute(context, builder: (context) => SearchScreen(list: postList));
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
    showTReanmeDialog(
      context,
      barrierDismissible: false,
      text: 'Untitled',
      submitText: 'New',
      onCheckIsError: (text) {
        final res = postList.indexWhere((e) => e.title == (text.trim()));
        return res == -1 ? null : 'post ရှိနေပါတယ်.အမည်ပြောင်းလဲပေးပါ!';
      },
      onSubmit: (text) async {
        final post = Post.create(title: text, id: text);
        await PostServices.getDB.add(post);
        if (!mounted) return;
        goRoute(
          context,
          builder: (context) => EditPostScreen(
            post: post,
            isUpdate: true,
            onUpdated: (updatedPost) {
              PostServices.getDB.update(post.id, updatedPost);
            },
          ),
        );
      },
    );
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
    goRoute(
      context,
      builder: (context) => EditPostScreen(
        post: post,
        isUpdate: true,
        onUpdated: (updatedPost) {
          PostServices.getDB.update(post.id, updatedPost);
        },
      ),
    );
  }

  void _deleteConfirm(Post post) {
    showTConfirmDialog(
      context,
      contentText: 'ဖျက်ချင်တာ သေချာပြီလား?',
      submitText: 'Delete',
      onSubmit: () {
        PostServices.getDB.delete(post.id);
      },
    );
  }
}
