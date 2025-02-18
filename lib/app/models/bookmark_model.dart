// ignore_for_file: public_member_api_docs, sort_constructors_first
class BookmarkModel {
  String title;
  BookmarkModel({
    required this.title,
  });

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    final title = map['title'] ?? map['name'];
    return BookmarkModel(
      title: title,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
      };

  @override
  String toString() {
    return '\ntitle => $title\n';
  }
}
