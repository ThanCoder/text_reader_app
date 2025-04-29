import 'package:apyar/app/scraper/html_dom_services.dart';
import 'package:apyar/app/scraper/scraper_query_services.dart';
import 'package:apyar/app/scraper/types/scraper_content_data_model.dart';
import 'package:apyar/app/scraper/types/scraper_data_model.dart';
import 'package:apyar/app/scraper/types/scraper_sub_query_modal.dart';
import 'package:apyar/app/services/index.dart';

import 'types/scraper_query_model.dart';

class ScraperServices {
  static Future<ScraperServicesResponse> getList(String url,
      {required ScraperQueryModel scraper}) async {
    final res = await DioServices.instance.getDio.get(url);
    // main
    final list = ScraperQueryServices.getMainScraper(
      res.data.toString(),
      scraper,
    );

    return ScraperServicesResponse(
      html: res.data.toString(),
      list: list,
      nextUrl: getNextUrl(
        res.data.toString(),
        scraper,
      ),
    );
  }

  static Future<ScraperContentDataModel> getContent(
    String url,
    ScraperSubQueryModal scraper, {
    required String cacheName,
    bool isOverride = false,
  }) async {
    final res = await DioServices.instance.getCacheHtml(
      url: url,
      cacheName: cacheName,
      isOverride: isOverride,
    );
    final ele = HtmlDomServices.getHtmlEle(res);
    final content = ScraperQueryServices.getQuery(ele, scraper);
    return ScraperContentDataModel(
      content: content,
      type: scraper.dataType,
    );
  }

  static String getNextUrl(
    String html,
    ScraperQueryModel query,
  ) {
    if (html.isEmpty) return '';
    return ScraperQueryServices.getQuery(
      HtmlDomServices.getHtmlEle(html)!,
      query.nextUrl,
    );
  }
}

class ScraperServicesResponse {
  String html;
  List<ScraperDataModel> list;
  String nextUrl;
  ScraperServicesResponse({
    required this.html,
    required this.list,
    required this.nextUrl,
  });
}
