import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.settings), centerTitle: true),
      body: const OptionPicker(),
    );
  }
}

class OptionPicker extends StatelessWidget {
  const OptionPicker({super.key});

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text(Strings.developedBy),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(Strings.developers),
                SizedBox(height: 8),
                Text(Strings.contactDevelopers),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(Strings.close),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ListView(
      children: <Widget>[
        RadioListTile<Options>(
          value: Options.automatic,
          groupValue: themeProvider.selectedOption,
          onChanged: (Options? value) {
            if (value != null) themeProvider.setTheme(value);
          },
          title: const Text(Strings.automatic),
        ),
        RadioListTile<Options>(
          value: Options.dark,
          groupValue: themeProvider.selectedOption,
          onChanged: (Options? value) {
            if (value != null) themeProvider.setTheme(value);
          },
          title: const Text(Strings.dark),
        ),
        RadioListTile<Options>(
          value: Options.light,
          groupValue: themeProvider.selectedOption,
          onChanged: (Options? value) {
            if (value != null) themeProvider.setTheme(value);
          },
          title: const Text(Strings.light),
        ),
        Divider(),
        const AboutListTile(
          applicationName: Strings.arkivaIslame,
          applicationVersion: "1.0.0",
          applicationIcon: Icon(Icons.info_outline),
          icon: Icon(Icons.article),
          aboutBoxChildren: <Widget>[Text(Strings.aboutBox)],
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: const Text(Strings.developmentTeam),
          onTap: () => _showInfoDialog(context),
        ),
      ],
    );
  }
}
