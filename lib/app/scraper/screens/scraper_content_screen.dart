import 'package:apyar/app/extensions/index.dart';
import 'package:apyar/app/scraper/scraper_bookmark_button.dart';
import 'package:apyar/app/scraper/types/scraper_content_data_model.dart';
import 'package:apyar/app/scraper/types/scraper_data_types.dart';
import 'package:apyar/app/widgets/cache_image_widget.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';

import '../../components/index.dart';
import '../scraper_services.dart';
import '../types/scraper_model.dart';

class ScraperContentScreen extends StatefulWidget {
  String url;
  String title;
  ScraperModel scraper;
  ScraperContentScreen({
    super.key,
    required this.url,
    required this.title,
    required this.scraper,
  });

  @override
  State<ScraperContentScreen> createState() => _ScraperContentScreenState();
}

class _ScraperContentScreenState extends State<ScraperContentScreen> {
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

  bool isLoading = false;
  bool isFullScreen = false;

  double lastScroll = 0;
  List<ScraperContentDataModel> list = [];

  Future<void> init({bool isOverride = false}) async {
    try {
      setState(() {
        isLoading = true;
      });
      list.clear();

      for (var query in widget.scraper.contentQueryList) {
        final res = await ScraperServices.getContent(
          widget.url,
          query,
          cacheName: '${widget.scraper.title}-${widget.title}',
          isOverride: isOverride,
        );
        list.add(res);
      }

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
              actions: isLoading
                  ? []
                  : [
                      PlatformExtension.isDesktop()
                          ? IconButton(
                              onPressed: () => init(isOverride: true),
                              icon: Icon(Icons.refresh),
                            )
                          : SizedBox.shrink(),
                      ScraperBookmarkButton(
                        title: widget.title,
                        filename: '${widget.scraper.title}-${widget.title}',
                        list: list,
                      ),
                    ],
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
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final data = list[index];
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
