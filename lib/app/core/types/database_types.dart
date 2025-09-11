enum DatabaseTypes {
  folder,
  json;

  static DatabaseTypes getType(String name) {
    if (folder.name == name) {
      return folder;
    }
    if (json.name == name) {
      return json;
    }
    return folder;
  }
}
