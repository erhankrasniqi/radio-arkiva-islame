import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/services/audio_handler.dart';
import 'package:radio_arkiva_islame/services/firebase_options.dart';
import 'package:radio_arkiva_islame/providers/youtube_provider.dart';
import 'package:radio_arkiva_islame/providers/theme_provider.dart';
import 'package:radio_arkiva_islame/providers/media_controller_provider.dart';
import 'package:radio_arkiva_islame/utils/lifecycle_observer.dart';
import 'package:radio_arkiva_islame/views/app.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  await Hive.openBox(Strings.cacheBox);
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelName: Strings.appTitle,
      androidNotificationChannelDescription:
          Strings.notificationChannelDescription,
      androidNotificationClickStartsActivity: true,
      androidResumeOnClick: true,
      androidShowNotificationBadge: true,
      androidNotificationIcon: Assets.icLauncherMonochrome,
      preloadArtwork: true,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  AppLifecycleObserver.instance.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => YoutubeProvider()..fetchVideos(),
        ),
        ChangeNotifierProvider(create: (context) => MediaControllerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
