abstract class TextReaderDataInterface<T> {
  String getContent();
  T getNext();
  T getPrev();
  bool isExistNext();
  bool isExistsPrev();
}
