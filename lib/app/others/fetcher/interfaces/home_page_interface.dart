import 'package:text_reader/app/others/fetcher/types/movie.dart';

abstract class HomePageInterface {
  Future<List<Movie>> getMovieList();
  Future<List<Movie>> getSeriesList();
}

abstract class MovieSeeAllInterface {
  Future<List<Movie>> getList(String url);
  String? get getNextUrl;
}
