import 'package:apyar/app/providers/apyar_provider.dart';
import 'package:apyar/app/providers/bookmark_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/my_app.dart';
import 'app/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init config
  await initAppConfigService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApyarProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
