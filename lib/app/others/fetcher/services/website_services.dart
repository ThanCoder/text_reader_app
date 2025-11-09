import 'package:t_html_parser/core/index.dart';
import 'package:text_reader/app/others/fetcher/types/query.dart';
import 'package:text_reader/app/others/fetcher/types/website.dart';

class WebsiteServices {
  static Future<List<Website>> getAll() async {
    return [
      Website(
        title: 'Drmgnyo',
        url: 'https://drmgnyo.com/all/',
        homeQuery: HomeQuery(
          querySelectorAll: '.entry-content p',
          titleQuery: FQuery(selector: ''),
          urlQuery: FQuery(selector: 'a', attr: 'href'),
        ),
        contentQuery: ContentQuery(
          titleQuery: FQuery(selector: '.post-title a'),
          coverUrlQuery: FQuery(selector: '.wp-post-image', attr: 'src'),
          contentQuery: FQuery(selector: '.entry-content'),
        ),
      ),
    ];
  }
}
