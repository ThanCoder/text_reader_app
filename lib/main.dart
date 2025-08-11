import 'package:than_pkg/than_pkg.dart';
import 'app/my_app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.windowManagerensureInitialized();

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
