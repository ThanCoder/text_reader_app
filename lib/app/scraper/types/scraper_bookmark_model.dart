import 'package:apyar/app/scraper/types/scraper_content_data_model.dart';

class ScraperBookmarkModel {
  String cacheName;
  List<ScraperContentDataModel> contentList;
  ScraperBookmarkModel({
    required this.cacheName,
    required this.contentList,
  });

  Map<String, dynamic> get toMap => {
        'cacheName': cacheName,
        'contentList': contentList.map((cd) => cd.toMap).toList(),
      };
}
