import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/screens/live_tv.dart';
import 'package:radio_arkiva_islame/theme/text_theme.dart';
import 'package:radio_arkiva_islame/theme/theme.dart';
import 'package:radio_arkiva_islame/providers/theme_provider.dart';
import 'package:radio_arkiva_islame/screens/contact.dart';
import 'package:radio_arkiva_islame/screens/radio.dart';
import 'package:radio_arkiva_islame/screens/settings.dart';
import 'package:radio_arkiva_islame/screens/youtube.dart';
import 'package:radio_arkiva_islame/utils/fab_loader.dart';
import 'package:radio_arkiva_islame/utils/url_utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    MaterialTheme theme = MaterialTheme(createTextTheme(context));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appTitle,
      themeMode: themeProvider.themeMode,
      darkTheme: theme.dark(),
      theme: theme.light(),
      home: const AppContent(),
    );
  }
}

class AppContent extends StatelessWidget {
  const AppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: FabLoader.isLoading,
          builder: (context, isLoading, child) {
            return FloatingActionButton(
              onPressed: isLoading ? null : () => openViberChat(),
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              foregroundColor: Theme.of(context).colorScheme.onTertiary,
              child:
                  isLoading
                      ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onTertiary,
                          strokeWidth: 2.5,
                        ),
                      )
                      : const FaIcon(FontAwesomeIcons.viber, size: 32),
            );
          },
        ),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SizedBox(
              child: Image.asset(Assets.logo, fit: BoxFit.contain),
            ),
          ),
          leadingWidth: 100,
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactScreen()),
                );
              },
              icon: Icon(Icons.info),
            ),
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              icon: Icon(Icons.settings),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: Strings.radio, icon: Icon(Icons.radio_outlined)),
              Tab(
                text: Strings.youtube,
                icon: FaIcon(FontAwesomeIcons.youtube),
              ),
              Tab(text: Strings.liveTv, icon: Icon(Icons.live_tv)),
            ],
          ),
        ),
        body: TabBarView(
          children: [RadioScreen(), YoutubeScreen(), LiveTvScreen()],
        ),
      ),
    );
  }
}
