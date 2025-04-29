class ScraperDataModel {
  String title;
  String url;
  String coverUrl;
  ScraperDataModel({
    required this.title,
    required this.url,
    required this.coverUrl,
  });

  @override
  String toString() {
    return title;
  }
}
