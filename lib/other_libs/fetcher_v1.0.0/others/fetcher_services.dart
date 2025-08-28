import 'package:t_html_parser/t_html_parser.dart';
import 'package:text_reader/other_libs/fetcher_v1.0.0/fetcher.dart';

class FetcherServices {
  static Future<FetcherData?> getDataFromUrl(
      String url, SupportedSite site) async {
    final data = FetcherData.create(url);

    final content = await Fetcher.instance.onGetHttpContent!(url);

    final ele = THtmlParser.getHtmlElement(content);
    if (ele == null) return null;

    final title = ele.getQuerySelectorText(selector: '.post-title');
    data.title = title;

    // cover url
    final coverUrl =
        ele.getQuerySelectorAttr(selector: '.ws-post-image', attr: 'src');
    data.coverUrl = coverUrl;

    // content text
    final body = ele.getQuerySelectorText(selector: '.entry-content');
    data.contentText = body.cleanScriptTag;

    return data;
  }

  static List<SupportedSite> get getSupportedSites {
    return [
      SupportedSite(title: 'Drmgnyo', hostUrl: 'https://drmgnyo.com'),
    ];
  }
}
