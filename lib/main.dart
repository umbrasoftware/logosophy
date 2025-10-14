import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/cache/annotations_cache.dart';
import 'package:logosophy/database/cache/book_cache.dart';
import 'package:logosophy/database/cache/notes_cache.dart';
import 'package:logosophy/database/cache/settings_cache.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  setupLogging();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_SERVICE_KEY']!,
  );

  runApp(ProviderScope(child: TranslationProvider(child: App())));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initApp(),
      builder: (context, asyncSnapshot) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(scheme: FlexScheme.amber),
          darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
          themeMode: ThemeMode.system,
          locale: TranslationProvider.of(context).flutterLocale,
          supportedLocales: AppLocaleUtils.supportedLocales,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          routerConfig: router,
        );
      },
    );
  }
}

void setupLogging() {
  // The 'logging' package requires a listener to be set up to actually
  // print the logs to the console.
  Logger.root.level = Level.INFO; // Log all INFO and above messages
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.loggerName}: ${record.message}');

    if (record.level == Level.SHOUT) {
      FirebaseCrashlytics.instance.log(
        '${record.loggerName}: ${record.message}',
      );
    }
  });
}

Future<void> initApp() async {
  await initCaches();
  await getLocale();
}

Future<void> initCaches() async {
  await AnnotationsCache().init();
  await BookCache().init();
  await NotesCache().init();
  await SettingsCache().init();
}

Future<void> getLocale() async {
  final locale = SettingsCache().getLocale();
  await LocaleSettings.setLocaleRaw(locale, listenToDeviceLocale: true);
}
