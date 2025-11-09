// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:text_reader/app/others/fetcher/types/query.dart';

class Website {
  final String title;
  final String url;
  final HomeQuery homeQuery;
  final ContentQuery contentQuery;
  Website({
    required this.title,
    required this.url,
    required this.homeQuery,
    required this.contentQuery,
  });
}

class WebsiteItem {
  final String title;
  final String url;
  final List<WebsiteItem> subItem;
  WebsiteItem({required this.title, required this.url, required this.subItem});
}
