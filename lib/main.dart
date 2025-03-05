import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/services/firebase_options.dart';
import 'package:radio_arkiva_islame/providers/youtube_provider.dart';
import 'package:radio_arkiva_islame/providers/theme_provider.dart';
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
  await JustAudioBackground.init(
    androidNotificationChannelName: Strings.appTitle,
    androidNotificationChannelDescription:
        Strings.notificationChannelDescription,
    androidNotificationClickStartsActivity: true,
    androidNotificationOngoing: true,
    androidResumeOnClick: true,
    androidShowNotificationBadge: false,
    preloadArtwork: true,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => YoutubeProvider()..fetchVideos(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
