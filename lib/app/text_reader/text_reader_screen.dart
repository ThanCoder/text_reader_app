import 'package:apyar/app/models/apyar_model.dart';
import 'package:flutter/material.dart';

import '../components/index.dart';
import '../widgets/core/index.dart';
import 'text_reader_config_model.dart';

class TextReaderScreen extends StatefulWidget {
  ApyarModel data;
  TextReaderConfigModel config;
  bool? bookmarkValue;
  void Function(bool bookmarkValue)? onBookmarkChanged;
  TextReaderScreen({
    super.key,
    required this.data,
    required this.config,
    this.bookmarkValue,
    this.onBookmarkChanged,
  });

  @override
  State<TextReaderScreen> createState() => _TextReaderScreenState();
}

class _TextReaderScreenState extends State<TextReaderScreen> {
  final ScrollController _controller = ScrollController();

  List<ApyarModel> list = [];
  bool isLoading = false;
  late TextReaderConfigModel config;
  late ApyarModel currentData;
  bool isGetTopData = false;
  bool? bookmarkValue;

  @override
  void initState() {
    _controller.addListener(_onScroll);
    config = widget.config;
    currentData = widget.data;
    bookmarkValue = widget.bookmarkValue;
    super.initState();
    init();
  }

  void init() async {
    list.add(widget.data);
    setState(() {});
  }

  double maxScroll = 0;

  void _onScroll() {
    if (isGetTopData && _controller.position.pixels == 0) {
      if (isLoading) return;
      _loadTopItem();
    }
    if (maxScroll != _controller.position.maxScrollExtent &&
        _controller.position.pixels == _controller.position.maxScrollExtent) {
      maxScroll = _controller.position.maxScrollExtent;
      if (isLoading) return;
      _loadDownItem();
    }
  }

  void _loadTopItem() {
    isLoading = true;
    if (currentData.isExistsPrev()) {
      currentData = currentData.getPrev();
      list.insert(0, currentData);
    } else {
      showMessage(context, '`${currentData.number + 1}` Chapter မရှိပါ ');
    }
    isLoading = false;
    setState(() {});
  }

  void _loadDownItem() {
    isLoading = true;
    if (currentData.isExistNext()) {
      currentData = currentData.getNext();
      list.add(currentData);
    } else {
      showMessage(context, '`${currentData.number + 1}` Chapter မရှိပါ ');
    }
    isLoading = false;
    setState(() {});
  }

  void _toggleBookMark() {
    bookmarkValue = !bookmarkValue!;
    if (widget.onBookmarkChanged != null) {
      widget.onBookmarkChanged!(bookmarkValue!);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            title: Text(currentData.title),
            snap: true,
            floating: true,
            actions: [
              bookmarkValue == null
                  ? SizedBox.shrink()
                  : IconButton(
                      color: bookmarkValue! ? Colors.red : Colors.teal,
                      onPressed: _toggleBookMark,
                      icon: Icon(bookmarkValue!
                          ? Icons.bookmark_remove_rounded
                          : Icons.bookmark_add_rounded),
                    ),
            ],
          ),
          // list
          SliverList.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final ch = list[index];
              return Padding(
                padding: EdgeInsets.all(config.padding),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3,
                  children: [
                    const Divider(),
                    Column(
                      children: [
                        Text('Chapter: ${ch.number}'),
                      ],
                    ),
                    const Divider(),
                    Text(
                      ch.getContent(),
                      style: TextStyle(
                        fontSize: config.fontSize,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
