// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_html_parser/core/t_html_extensions.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:text_reader/app/others/fetcher/components/website_chooser.dart';
import 'package:text_reader/app/others/fetcher/services/website_services.dart';
import 'package:text_reader/app/others/fetcher/types/website.dart';

class FetcherPostResult {
  final String? url;
  final String? title;
  final String? coverUrl;
  final String? contentText;
  FetcherPostResult({this.url, this.title, this.coverUrl, this.contentText});
}

typedef FetcherPostResultCallback = void Function(FetcherPostResult result);

class FetcherPostHomeScreen extends StatefulWidget {
  final String? url;
  final FetcherPostResultCallback? onSave;
  const FetcherPostHomeScreen({super.key, this.url, this.onSave});

  @override
  State<FetcherPostHomeScreen> createState() => _FetcherPostHomeScreenState();
}

class _FetcherPostHomeScreenState extends State<FetcherPostHomeScreen> {
  List<Website> websiteList = [];
  Website? currentWebsite;
  bool isLoading = false;
  final client = TClient();
  final urlController = TextEditingController();
  final titleController = TextEditingController();
  final coverUrlController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    urlController.text = widget.url ?? '';
    super.initState();
    init();
  }

  void init() async {
    websiteList = await WebsiteServices.getAll();
    if (!mounted) return;
    setState(() {});
    _onAutoChooseWebsite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetcher Content')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            _getWebsiteChooser(),
            SliverToBoxAdapter(child: _getForms()),
          ],
        ),
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

  Widget _getForms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        TTextField(
          label: Text('Url'),
          maxLines: 1,
          isSelectedAll: true,
          controller: urlController,
        ),

        TTextField(
          label: Text('Cover Url'),
          maxLines: 1,
          isSelectedAll: true,
          controller: coverUrlController,
        ),
        TTextField(
          label: Text('Title'),
          maxLines: 1,
          isSelectedAll: true,
          controller: titleController,
        ),
        TTextField(
          label: Text('Content Text'),
          maxLines: null,
          controller: contentController,
        ),
      ],
    );
  }

  Widget _getFloatingAction() {
    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'fetch',
          onPressed: _onFetch,
          child: Icon(Icons.download),
        ),
        FloatingActionButton(
          heroTag: 'save',
          onPressed: _onSave,
          child: Icon(Icons.save_as_outlined),
        ),
      ],
    );
  }

  void _onAutoChooseWebsite() {
    if (urlController.text.isEmpty) return;
    final urlOrigin = Uri.parse(urlController.text).origin;

    for (var website in websiteList) {
      if (urlOrigin == Uri.parse(website.url).origin) {
        currentWebsite = website;
        break;
      }
    }
    setState(() {});
    _onFetch();
  }

  void _onFetch() async {
    try {
      if (currentWebsite == null) return;
      isLoading = true;
      setState(() {});
      final res = await client.get(urlController.text);
      final dom = res.data.toString().toHtmlDocument;
      final ele = dom.body!;
      final title = currentWebsite!.contentQuery.titleQuery.getResult(ele);
      final coverUrl = currentWebsite!.contentQuery.coverUrlQuery.getResult(
        ele,
      );
      final content = currentWebsite!.contentQuery.contentQuery.getResult(ele);
      titleController.text = title;
      coverUrlController.text = coverUrl;
      contentController.text = content.cleanHtmlTag();

      if (!mounted) return;
      isLoading = false;
      setState(() {});
    } catch (e) {
      showTMessageDialogError(context, e.toString());
    }
  }

  void _onSave() {
    Navigator.pop(context);
    widget.onSave?.call(
      FetcherPostResult(
        title: titleController.text,
        url: urlController.text,
        coverUrl: coverUrlController.text,
        contentText: contentController.text,
      ),
    );
  }
}
