enum ScraperQueryTypes {
  attr,
  text;
}

extension ScraperQueryTypesExtension on ScraperQueryTypes {
  static ScraperQueryTypes getType(String type) {
    if (type == ScraperQueryTypes.attr.name) {
      return ScraperQueryTypes.attr;
    }
    return ScraperQueryTypes.text;
  }
}
