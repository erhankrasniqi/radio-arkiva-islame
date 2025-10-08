import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';

class LiveTvScreen extends StatelessWidget {
  const LiveTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4.0,
          children: [const Text(Strings.liveTvComingSoon)],
        ),
      ),
    );
  }
}
