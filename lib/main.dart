import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book_model.dart';
import 'package:logosophy/database/search_history/history_provider.dart';
import 'package:logosophy/database/settings/settings_provider.dart';
import 'package:logosophy/firebase_options.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/settings_tab/utils.dart';
import 'package:logosophy/pages/splash_pages/animated_logo.dart';
import 'package:logosophy/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late Supabase supabase;

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

  supabase = await Supabase.initialize(url: dotenv.env['SUPABASE_URL']!, anonKey: dotenv.env['SUPABASE_SERVICE_KEY']!);
  await Hive.initFlutter();
  runApp(ProviderScope(child: TranslationProvider(child: App())));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = initApp(ref);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Material(child: Center(child: BreathingLogo())),
          );
        }
        return MaterialApp.router(
          title: 'Logosofia',
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(scheme: FlexScheme.amber),
          darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
          themeMode: SettingsUtils.getThemeMode(ref),
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
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    if (record.level == Level.SEVERE || record.level == Level.SHOUT) {
      FirebaseCrashlytics.instance.log('${record.loggerName}: ${record.message}');
    }
  });
}

Future<void> initApp(WidgetRef ref) async {
  Hive.registerAdapter(BookDataAdapter());
  await initProviders(ref);
  await getLocale(ref);
}

Future<void> initProviders(WidgetRef ref) async {
  await ref.read(settingsProvider.notifier).init();
  await ref.read(historyProvider.notifier).init();
}

Future<void> getLocale(WidgetRef ref) async {
  final locale = ref.read(settingsProvider).language;
  await LocaleSettings.setLocaleRaw(locale, listenToDeviceLocale: true);
}
