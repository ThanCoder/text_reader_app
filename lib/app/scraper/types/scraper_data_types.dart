enum ScraperDataTypes {
  text,
  image,
}

extension ScraperDataTypesExtension on ScraperDataTypes {
  static ScraperDataTypes getType(String type) {
    if (type == ScraperDataTypes.image.name) {
      return ScraperDataTypes.image;
    }
    return ScraperDataTypes.text;
  }
}
