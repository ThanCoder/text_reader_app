import 'package:apyar/app/scraper/types/scraper_data_types.dart';
import 'package:apyar/app/scraper/types/scraper_query_model.dart';
import 'package:apyar/app/scraper/types/scraper_sub_query_modal.dart';
import 'package:apyar/app/scraper/screens/scraper_home_screen.dart';
import 'package:apyar/app/widgets/index.dart';
import 'package:flutter/material.dart';

import '../scraper/types/scraper_model.dart';
import '../scraper/types/scraper_query_types.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<ScraperModel> list = [
    ScraperModel(
      title: 'Dr Mg Nyo [အပြာစာပေ]',
      url: 'https://drmgnyo.com/',
      desc: '',
      minVersion: '1.0.0',
      date: 1745889733017,
      mainQuery: ScraperQueryModel(
        main: '.clean-grid-grid-post',
        title: ScraperSubQueryModal(query: '.clean-grid-grid-post-title a'),
        url: ScraperSubQueryModal(
          query: '.clean-grid-grid-post-title a',
          attr: 'href',
          type: ScraperQueryTypes.attr,
        ),
        coverUrl: ScraperSubQueryModal(
          query: '.clean-grid-grid-post-thumbnail img',
          attr: 'src',
          type: ScraperQueryTypes.attr,
        ),
        nextUrl: ScraperSubQueryModal(
          query: '.wp-pagenavi .nextpostslink',
          attr: 'href',
          type: ScraperQueryTypes.attr,
        ),
      ),
      contentQueryList: [
        ScraperSubQueryModal(
          query: '.clean-grid-post-thumbnail-single',
          type: ScraperQueryTypes.attr,
          attr: 'src',
          dataType: ScraperDataTypes.image,
        ),
        ScraperSubQueryModal(query: '.entry-content'),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            DrawerHeader(
              child: MyImageFile(path: ''),
            ),
            Text('Website များ'),
            ListTile(
              title: Text('Dr Mg Nyo [အပြာစာပေ]'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScraperHomeScreen(
                      scraper: list[0],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
