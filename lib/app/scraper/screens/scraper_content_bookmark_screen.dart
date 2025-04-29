import 'package:apyar/app/scraper/types/scraper_content_data_model.dart';
import 'package:apyar/app/scraper/types/scraper_data_types.dart';
import 'package:apyar/app/widgets/cache_image_widget.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';

import '../../components/index.dart';

class ScraperContentBookmarkScreen extends StatefulWidget {
  String title;
  List<ScraperContentDataModel> list;
  ScraperContentBookmarkScreen({
    super.key,
    required this.title,
    required this.list,
  });

  @override
  State<ScraperContentBookmarkScreen> createState() =>
      _ScraperContentBookmarkScreenState();
}

class _ScraperContentBookmarkScreenState
    extends State<ScraperContentBookmarkScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);
    super.dispose();
  }

  bool isFullScreen = false;
  bool isLoading = false;

  Future<void> init({bool isOverride = false}) async {
    try {
      setState(() {
        isLoading = true;
      });

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showDialogMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
              title: Text(widget.title),
            ),
      body: isLoading
          ? TLoader()
          : RefreshIndicator.adaptive(
              onRefresh: init,
              child: GestureDetector(
                onDoubleTap: () {
                  try {
                    isFullScreen = !isFullScreen;
                    ThanPkg.platform
                        .toggleFullScreen(isFullScreen: isFullScreen);
                    setState(() {});
                  } catch (e) {
                    showDialogMessage(context, e.toString());
                  }
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: widget.list.length,
                  itemBuilder: (context, index) {
                    final data = widget.list[index];
                    if (data.type == ScraperDataTypes.image) {
                      return CacheImageWidget(url: data.content);
                    }
                    return Text(
                      data.content,
                      style: TextStyle(fontSize: 18),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
