import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_arkiva_islame/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preferencat"), centerTitle: true),
      body: const OptionPicker(),
    );
  }
}

class OptionPicker extends StatelessWidget {
  const OptionPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      children: <Widget>[
        RadioListTile<Options>(
          value: Options.automatic,
          groupValue: themeProvider.selectedOption,
          onChanged: (Options? value) {
            if (value != null) themeProvider.setTheme(value);
          },
          title: const Text('Automatik'),
        ),
        RadioListTile<Options>(
          value: Options.dark,
          groupValue: themeProvider.selectedOption,
          onChanged: (Options? value) {
            if (value != null) themeProvider.setTheme(value);
          },
          title: const Text('Errët'),
        ),
        RadioListTile<Options>(
          value: Options.light,
          groupValue: themeProvider.selectedOption,
          onChanged: (Options? value) {
            if (value != null) themeProvider.setTheme(value);
          },
          title: const Text('Ndritshëm'),
        ),
      ],
    );
  }
}
