import 'package:apyar/app/components/apyar_list_item.dart';
import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/route_helper.dart';
import 'package:flutter/material.dart';

class ApyarSearch extends SearchDelegate {
  List<ApyarModel> list;

  ApyarSearch({required this.list});

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return [
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear_all_rounded),
        ),
      ];
    }
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _getResult();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _getResult();
  }

  Widget _getResult() {
    if (query.isEmpty) {
      return Center(child: Text('တစ်ခုခုရေးပါ...'));
    }
    //search
    final res = list
        .where((ap) => ap.title.toUpperCase().contains(query.toUpperCase()))
        .toList();
    if (res.isEmpty) {
      return Center(child: Text('မရှိပါ...'));
    }
    return ListView.separated(
      itemBuilder: (context, index) => ApyarListItem(
        apyar: res[index],
        onClicked: (apyar) {
          goTextReaderScreen(context, apyar);
        },
      ),
      separatorBuilder: (context, index) => Divider(),
      itemCount: res.length,
    );
  }
}
