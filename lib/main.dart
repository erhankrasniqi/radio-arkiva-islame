import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
  await Hive.openBox('youtube_cache');
  await JustAudioBackground.init(
    androidNotificationChannelName: 'Radio Arkiva Islame',
    androidNotificationChannelDescription:
        'Ne synojmë të sjellim më pranë jush mesazhin e pastër islam, duke ndihmuar në forcimin e besimit dhe njohurive fetare.',
    androidNotificationClickStartsActivity: true,
    androidNotificationOngoing: true,
    androidResumeOnClick: true,
    androidShowNotificationBadge: false,
    preloadArtwork: true,
  );
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
