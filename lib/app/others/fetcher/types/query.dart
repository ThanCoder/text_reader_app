// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:t_html_parser/t_html_parser.dart';

class HomeQuery {
  final String querySelectorAll;
  final FQuery titleQuery;
  final FQuery urlQuery;
  HomeQuery({
    required this.querySelectorAll,
    required this.titleQuery,
    required this.urlQuery,
  });
}

class ContentQuery {
  final FQuery titleQuery;
  final FQuery coverUrlQuery;
  final FQuery contentQuery;
  ContentQuery({
    required this.titleQuery,
    required this.coverUrlQuery,
    required this.contentQuery,
  });
}
