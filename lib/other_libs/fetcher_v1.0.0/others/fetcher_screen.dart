import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import '../fetcher.dart';

class FetcherScreen extends StatefulWidget {
  void Function(FetcherData data) onFetched;
  FetcherScreen({
    super.key,
    required this.onFetched,
  });

  @override
  State<FetcherScreen> createState() => _FetcherScreenState();
}

class _FetcherScreenState extends State<FetcherScreen> {
  final urlController = TextEditingController();
  final urlFocusNode = FocusNode();
  SupportedSite? supportedSite;
  List<SupportedSite> siteList = FetcherServices.getSupportedSites;
  late FetcherData data;
  bool isLoading = false;
  bool isFetched = false;
  String? urlControllerError;

  @override
  void initState() {
    data = FetcherData.create('');
    if (siteList.isNotEmpty) {
      supportedSite = siteList.first;
    }
    super.initState();
    init();
  }

  @override
  void dispose() {
    urlController.dispose();
    urlFocusNode.dispose();
    super.dispose();
  }

  void init() {
    _onUrlChecked('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetcher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              TTextField(
                label: Text('Fetch Url'),
                maxLines: 1,
                isSelectedAll: true,
                controller: urlController,
                autofocus: true,
                focusNode: urlFocusNode,
                onChanged: _onUrlChecked,
                errorText: urlControllerError,
              ),
              // supported Site
              Text('ထောက်ပံ့ပေးနိုင်သော WebSite များ'),
              _getSupportSiteWidget(),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Text('Result'),
                  Expanded(child: Divider()),
                ],
              ),
              // result
              ..._getResultWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: _getActions(),
    );
  }

  Widget? _getActions() {
    if (isLoading) return null;
    if (urlControllerError != null) return null;

    return Column(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'fetch',
          onPressed: _onFetch,
          child: Icon(Icons.cloud_download),
        ),
        isFetched
            ? FloatingActionButton(
                heroTag: 'update',
                onPressed: _onUpdate,
                child: Icon(Icons.save_as_rounded),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _getSupportSiteWidget() {
    return DropdownButton<SupportedSite>(
      padding: EdgeInsets.all(4),
      borderRadius: BorderRadius.circular(4),
      value: supportedSite,
      items: siteList
          .map(
            (e) => DropdownMenuItem<SupportedSite>(
              value: e,
              child: Text(
                e.title.toCaptalize(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        supportedSite = value!;
        setState(() {});
      },
    );
  }

  List<Widget> _getResultWidget() {
    if (isLoading) {
      return [Center(child: TLoaderRandom())];
    }
    if (!isFetched) {
      return [];
    }
    return [
      Text('Cover:'),
      TImage(
        source: data.coverUrl,
        size: 100,
      ),
      Divider(),
      Text('Title:'),
      Text(data.title),
      Divider(),
      Text('Content Text:'),
      Text(data.contentText),
    ];
  }

  void _onUrlChecked(String value) {
    if (value.isEmpty) {
      urlControllerError = 'url is empty!';
      setState(() {});
      return;
    }
    if (!value.startsWith('http')) {
      urlControllerError = 'url is start http***!';
      setState(() {});
      return;
    }
    if (urlControllerError != null) {
      setState(() {
        urlControllerError = null;
      });
    }
  }

  void _onUpdate() {
    Navigator.pop(context);

    widget.onFetched(data);
  }

  void _onFetch() async {
    try {
      urlFocusNode.unfocus();
      if (Fetcher.instance.onGetHttpContent == null) {
        throw Exception(Fetcher.getErrorLog);
      }
      if (supportedSite == null) return;

      setState(() {
        isLoading = true;
        isFetched = false;
      });
      final res = await FetcherServices.getDataFromUrl(
          urlController.text, supportedSite!);
      if (res != null) {
        data = res;
      }
      // set

      if (!mounted) return;
      setState(() {
        isLoading = false;
        isFetched = true;
      });
    } catch (e) {
      Fetcher.showDebugLog(e.toString(), tag: 'FetcherScreen:_onFetch');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Fetcher.instance.showMessage(context, e.toString());
    }
  }
}
