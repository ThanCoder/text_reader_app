import 'dart:convert';
import 'dart:io';

import 'package:apyar/app/scraper/types/scraper_query_model.dart';
import 'package:apyar/app/scraper/types/scraper_sub_query_modal.dart';
import 'package:apyar/app/services/map_services.dart';

class ScraperModel {
  String title;
  String url;
  String desc;
  String minVersion;
  int date;
  ScraperQueryModel mainQuery;
  List<ScraperSubQueryModal> contentQueryList;
  ScraperModel({
    required this.title,
    required this.url,
    required this.desc,
    required this.minVersion,
    required this.date,
    required this.mainQuery,
    required this.contentQueryList,
  });

  void save(String savedPath) {
    final file = File(savedPath);
    file.writeAsStringSync(JsonEncoder.withIndent(' ').convert(toMap));
  }

  factory ScraperModel.fromMap(Map<String, dynamic> map) {
    final title = MapServices.get<String>(map, ['title'], defaultValue: '');
    final url = MapServices.get<String>(map, ['url'], defaultValue: '');
    final desc = MapServices.get<String>(map, ['desc'], defaultValue: '');
    final minVersion =
        MapServices.get<String>(map, ['minVersion'], defaultValue: '');
    final date = MapServices.get<int>(map, ['date'], defaultValue: 0);

    final mainQuery = MapServices.get<Map<String, dynamic>>(map, ['mainQuery'],
        defaultValue: {});
    final contentQueryList = MapServices.get<List<Map<String, dynamic>>>(
      map,
      ['contentQueryList'],
      defaultValue: [],
    );

    return ScraperModel(
      title: title,
      url: url,
      desc: desc,
      minVersion: minVersion,
      date: date,
      mainQuery: ScraperQueryModel.fromMap(mainQuery),
      contentQueryList: contentQueryList
          .map((map) => ScraperSubQueryModal.fromMap(map))
          .toList(),
    );
  }

  Map<String, dynamic> get toMap => {
        'title': title,
        'url': url,
        'desc': desc,
        'minVersion': minVersion,
        'date': date,
        'mainQuery': mainQuery.toMap,
        'contentQueryList': contentQueryList.map((cq) => cq.toMap).toList(),
      };
}
