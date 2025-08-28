class Bookmark {
  String title;
  String id;
  Bookmark({required this.title, required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'id': id};
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(title: map['title'] as String, id: map['id'] as String);
  }
}
