import 'package:apyar/app/scraper/scraper_bookmark_services.dart';
import 'package:flutter/material.dart';

import 'types/scraper_content_data_model.dart';

class ScraperBookmarkButton extends StatefulWidget {
  String title;
  String filename;
  List<ScraperContentDataModel> list;
  ScraperBookmarkButton({
    super.key,
    required this.title,
    required this.filename,
    required this.list,
  });

  @override
  State<ScraperBookmarkButton> createState() => _ScraperBookmarkButtonState();
}

class _ScraperBookmarkButtonState extends State<ScraperBookmarkButton> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isExists = false;

  void init() async {
    final res = await ScraperBookmarkServices.getDataList(
      title: widget.title,
    );
    if (res.isNotEmpty) {
      isExists = true;
    } else {
      isExists = false;
    }
    setState(() {});
  }

  void _toggle() async {
    if (isExists) {
      await ScraperBookmarkServices.removeTitle(widget.title);
    } else {
      await ScraperBookmarkServices.addDataList(
        widget.title,
        list: widget.list,
      );
      //copy image
      // final file = File('${PathUtil.getCachePath()}/${widget.title}');
      // if(!file.existsSync()){
      //   file.copySync(newPath)
      // }
    }

    isExists = !isExists;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggle,
      color: isExists ? Colors.red : Colors.green,
      icon: Icon(isExists ? Icons.bookmark_remove : Icons.bookmark_add),
    );
  }
}
