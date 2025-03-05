import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/theme/text_theme.dart';
import 'package:radio_arkiva_islame/theme/theme.dart';
import 'package:radio_arkiva_islame/providers/theme_provider.dart';
import 'package:radio_arkiva_islame/screens/contact.dart';
import 'package:radio_arkiva_islame/screens/radio.dart';
import 'package:radio_arkiva_islame/screens/settings.dart';
import 'package:radio_arkiva_islame/screens/youtube.dart';

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
              Tab(text: Strings.contact, icon: Icon(Icons.info_outline)),
            ],
          ),
        ),
        body: TabBarView(
          children: [RadioScreen(), YoutubeScreen(), ContactScreen()],
        ),
      ),
    );
  }
}
