// ignore_for_file: public_member_api_docs, sort_constructors_first
class FetcherData {
  String url;
  String title;
  String coverUrl;
  String contentText;
  FetcherData({
    required this.url,
    required this.title,
    required this.coverUrl,
    required this.contentText,
  });
  factory FetcherData.create(
    String url, {
    String title = 'Untitled',
    String coverUrl = '',
    String contentText = '',
  }) {
    return FetcherData(
        url: url, title: title, coverUrl: coverUrl, contentText: contentText);
  }
}
