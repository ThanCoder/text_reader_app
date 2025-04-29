import 'package:apyar/app/scraper/types/scraper_data_model.dart';
import 'package:apyar/app/scraper/types/scraper_query_model.dart';
import 'package:html/dom.dart' as html;

import 'html_dom_services.dart';
import 'types/scraper_query_types.dart';
import 'types/scraper_sub_query_modal.dart';

class ScraperQueryServices {
  static List<ScraperDataModel> getMainScraper(
      String html, ScraperQueryModel mainScraper) {
    final dom = HtmlDomServices.getHtmlDom(html);
    List<ScraperDataModel> list = [];

    for (var ele in dom.querySelectorAll(mainScraper.main)) {
      final title = getQuery(ele, mainScraper.title);
      final url = getQuery(ele, mainScraper.url);
      final coverUrl = getQuery(ele, mainScraper.coverUrl);
      // add
      list.add(ScraperDataModel(title: title, url: url, coverUrl: coverUrl));
    }
    return list;
  }

  static String getQuery(html.Element? ele, ScraperSubQueryModal query) {
    if (ele == null) return '';
    if (query.type == ScraperQueryTypes.attr) {
      return HtmlDomServices.getQuerySelectorAttr(ele, query.query, query.attr);
    }
    return HtmlDomServices.getQuerySelectorText(ele, query.query);
  }
}
