import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:text_reader/app/core/models/post.dart';
import 'package:text_reader/app/others/fetcher/components/website_chooser.dart';
import 'package:text_reader/app/others/fetcher/screens/fetcher_post_home_screen.dart';
import 'package:text_reader/app/others/fetcher/services/fetcher_services.dart';
import 'package:text_reader/app/others/fetcher/types/website.dart';
import 'package:text_reader/app/others/fetcher/services/website_services.dart';
import 'package:text_reader/app/routes_helper.dart';
import 'package:text_reader/app/services/post_services.dart';

class FetcherHomeScreen extends StatefulWidget {
  const FetcherHomeScreen({super.key});

  @override
  State<FetcherHomeScreen> createState() => _FetcherHomeScreenState();
}

class _FetcherHomeScreenState extends State<FetcherHomeScreen> {
  List<Website> websiteList = [];
  List<WebsiteItem> websiteItems = [];
  Website? currentWebsite;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    websiteList = await WebsiteServices.getAll();
    if (websiteList.isNotEmpty) {
      currentWebsite = websiteList.first;
      _onFetch();
    }
    if (!mounted) return;
    setState(() {});
    _onFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetcher Home')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(slivers: [_getWebsiteChooser(), _getList()]),
      ),
      floatingActionButton: isLoading ? TLoader.random() : _getFloatingAction(),
    );
  }

  Widget _getWebsiteChooser() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Websites'),
          WebsiteChooser(
            list: websiteList,
            value: currentWebsite,
            onChanged: (value) {
              currentWebsite = value;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _getList() {
    return SliverList.separated(
      itemCount: websiteItems.length,
      itemBuilder: (context, index) => _getListItem(websiteItems[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _getListItem(WebsiteItem item) {
    return GestureDetector(
      onTap: () => _goFetcherPost(item),
      child: Row(
        children: [
          Expanded(child: Text(item.title)),
          _getDownloadWidget(item),
        ],
      ),
    );
  }

  Widget _getDownloadWidget(WebsiteItem item) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withValues(alpha: 0.1),
      ),
      child: Icon(color: Colors.amber, Icons.download),
    );
  }

  Widget _getFloatingAction() {
    return FloatingActionButton(
      onPressed: _onFetch,
      child: Icon(Icons.download),
    );
  }

  void _goFetcherPost(WebsiteItem item) {
    goRoute(
      context,
      builder: (context) => FetcherPostHomeScreen(
        url: item.url,
        onSave: (result) async {
          try {
            if (result.title == null) return;
            await PostServices.getDB.add(
              Post.create(title: result.title!, body: result.contentText ?? '',indexId: 0),
            );
            if (!context.mounted) return;
            setState(() {});
          } catch (e) {
            if (!context.mounted) return;

            showTMessageDialogError(context, e.toString());
          }
        },
      ),
    );
  }

  void _onFetch() async {
    try {
      if (currentWebsite == null) return;
      isLoading = true;
      setState(() {});

      websiteItems = await FetcherServices.getHomeList(
        website: currentWebsite!,
      );

      if (!mounted) return;
      isLoading = false;
      setState(() {});
    } catch (e) {
      showTMessageDialogError(context, e.toString());
    }
  }
}
