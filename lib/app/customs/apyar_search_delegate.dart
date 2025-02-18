import 'package:apyar/app/models/apyar_model.dart';
import 'package:apyar/app/notifiers/apyar_notifier.dart';
import 'package:apyar/app/screens/text_reader_screen.dart';
import 'package:flutter/material.dart';

class ApyarSearchDelegate extends SearchDelegate {
  List<ApyarModel> list = [];
  ApyarSearchDelegate({required this.list});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return _onChanged();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _onChanged();
  }

  Widget _onChanged() {
    if (query.isEmpty) {
      return Center(child: Text('တစ်ခုခုရေးပါ....'));
    }
    final resultList =
        list.where((ap) => ap.title.toLowerCase().contains(query)).toList();

    if (resultList.isEmpty) {
      return Center(child: Text('မတွေ့ပါ....'));
    }
    return ListView.separated(
      itemBuilder: (context, index) {
        final apyar = resultList[index];
        return ListTile(
          onTap: () {
            currentApyarNotifier.value = apyar;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TextReaderScreen(),
              ),
            );
          },
          title: Text(apyar.title),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: resultList.length,
    );
  }
}
