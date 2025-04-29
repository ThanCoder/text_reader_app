import 'package:apyar/app/scraper/types/scraper_sub_query_modal.dart';
import 'package:apyar/app/services/map_services.dart';

class ScraperQueryModel {
  String main;
  // sub query
  ScraperSubQueryModal title;
  ScraperSubQueryModal url;
  ScraperSubQueryModal coverUrl;
  ScraperSubQueryModal nextUrl;

  ScraperQueryModel({
    required this.main,
    required this.title,
    required this.url,
    required this.coverUrl,
    required this.nextUrl,
  });

  factory ScraperQueryModel.fromMap(Map<String, dynamic> map) {
    final main = MapServices.get<String>(map, ['main'], defaultValue: '');
    final title =
        MapServices.get<Map<String, dynamic>>(map, ['title'], defaultValue: {});
    final url =
        MapServices.get<Map<String, dynamic>>(map, ['url'], defaultValue: {});
    final coverUrl = MapServices.get<Map<String, dynamic>>(map, ['coverUrl'],
        defaultValue: {});
    final nextUrl = MapServices.get<Map<String, dynamic>>(map, ['nextUrl'],
        defaultValue: {});
    return ScraperQueryModel(
      main: main,
      title: ScraperSubQueryModal.fromMap(title),
      url: ScraperSubQueryModal.fromMap(url),
      coverUrl: ScraperSubQueryModal.fromMap(coverUrl),
      nextUrl: ScraperSubQueryModal.fromMap(nextUrl),
    );
  }

  Map<String, dynamic> get toMap => {
        'title': title.toMap,
        'url': url.toMap,
        'coverUrl': coverUrl.toMap,
        'nextUrl': nextUrl.toMap,
      };
}
