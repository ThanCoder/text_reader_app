import 'package:apyar/app/components/index.dart';
import 'package:apyar/app/scraper/types/scraper_data_model.dart';
import 'package:apyar/app/scraper/types/scraper_model.dart';
import 'package:apyar/app/scraper/scraper_services.dart';
import 'package:apyar/app/scraper/screens/scraper_content_screen.dart';
import 'package:apyar/app/utils/index.dart';
import 'package:apyar/app/widgets/cache_image_widget.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';

class ScraperHomeScreen extends StatefulWidget {
  ScraperModel scraper;
  ScraperHomeScreen({super.key, required this.scraper});

  @override
  State<ScraperHomeScreen> createState() => _ScraperHomeScreenState();
}

class _ScraperHomeScreenState extends State<ScraperHomeScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(_onScroll);
    super.initState();
    init();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  List<ScraperDataModel> list = [];
  String nextUrl = '';
  bool isLoading = false;
  bool isNextLoading = false;
  double lastScroll = 0;

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });

      final res = await ScraperServices.getList(
        widget.scraper.url,
        scraper: widget.scraper.mainQuery,
      );
      list = res.list;
      nextUrl = res.nextUrl;

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

  void _onScroll() {
    final pos = scrollController.position.pixels;
    final max = scrollController.position.maxScrollExtent;
    if (!isNextLoading && lastScroll != max && pos == max) {
      lastScroll = max;
      _loadPage();
    }
  }

  void _loadPage() async {
    try {
      setState(() {
        isNextLoading = true;
      });

      final res = await ScraperServices.getList(nextUrl,
          scraper: widget.scraper.mainQuery);
      list.addAll(res.list);
      nextUrl = res.nextUrl;

      if (!mounted) return;
      setState(() {
        isNextLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isNextLoading = false;
      });
      showDialogMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Dr Mg Nyo [အပြာစာပေ]'),
      ),
      body: isLoading
          ? TLoader()
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverGrid.builder(
                  itemCount: list.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 180,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final data = list[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScraperContentScreen(
                              title: data.title,
                              url: data.url,
                              scraper: widget.scraper,
                            ),
                          ),
                        );
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                    child: CacheImageWidget(
                                  url: data.coverUrl,
                                  savedPath:
                                      '${PathUtil.getCachePath()}/${data.title}',
                                )),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(174, 37, 37, 37),
                                ),
                                child: Text(
                                  list[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                    child: isNextLoading ? TLoader() : SizedBox.shrink()),
              ],
            ),
    );
  }
}
