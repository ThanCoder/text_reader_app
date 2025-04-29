import 'package:apyar/app/scraper/types/scraper_data_types.dart';
import 'package:apyar/app/services/map_services.dart';

class ScraperContentDataModel {
  String content;
  ScraperDataTypes type;
  ScraperContentDataModel({
    required this.content,
    this.type = ScraperDataTypes.text,
  });

  factory ScraperContentDataModel.fromMap(Map<String, dynamic> map) {
    final type = MapServices.get<String>(map, ['type'], defaultValue: '');
    return ScraperContentDataModel(
      content: MapServices.get<String>(map, ['content'], defaultValue: ''),
      type: ScraperDataTypesExtension.getType(type),
    );
  }

  Map<String, dynamic> get toMap => {
        'content': content,
        'type': type.name,
      };

  @override
  String toString() {
    return 'type: ${type.name}';
  }
}
