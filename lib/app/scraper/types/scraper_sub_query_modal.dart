import 'package:apyar/app/scraper/types/scraper_data_types.dart';
import 'package:apyar/app/services/map_services.dart';

import 'scraper_query_types.dart';

class ScraperSubQueryModal {
  String query;
  String attr;
  ScraperQueryTypes type;
  ScraperDataTypes dataType;

  ScraperSubQueryModal({
    required this.query,
    this.type = ScraperQueryTypes.text,
    this.attr = '',
    this.dataType = ScraperDataTypes.text,
  });

  factory ScraperSubQueryModal.fromMap(Map<String, dynamic> map) {
    final type = MapServices.get<String>(map, ['type'], defaultValue: '');
    final dataType =
        MapServices.get<String>(map, ['dataType'], defaultValue: '');

    return ScraperSubQueryModal(
      query: MapServices.get<String>(map, ['query'], defaultValue: ''),
      attr: MapServices.get<String>(map, ['attr'], defaultValue: ''),
      type: ScraperQueryTypesExtension.getType(type),
      dataType: ScraperDataTypesExtension.getType(dataType),
    );
  }

  Map<String, dynamic> get toMap => {
        'query': query,
        'attr': attr,
        'type': type.name,
        'dataType': dataType.name,
      };
}
