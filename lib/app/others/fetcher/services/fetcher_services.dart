import 'package:t_client/t_client.dart';
import 'package:t_html_parser/t_html_parser.dart';
import 'package:text_reader/app/others/fetcher/types/website.dart';

class FetcherServices {
  static Future<List<WebsiteItem>> getHomeList({
    required Website website,
  }) async {
    List<WebsiteItem> list = [];
    final client = TClient();
    final url = website.url;
    final res = await client.get(url);
    final dom = res.data.toString().toHtmlDocument;
    for (var ele in dom.querySelectorAll(website.homeQuery.querySelectorAll)) {
      final title = website.homeQuery.titleQuery.getResult(ele);
      final url = website.homeQuery.urlQuery.getResult(ele);
      if (title.isEmpty) continue;
      list.add(WebsiteItem(title: title, url: url, subItem: []));
    }
    return list;
  }
}
