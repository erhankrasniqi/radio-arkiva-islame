import 'package:flutter/material.dart';

TextTheme createTextTheme(BuildContext context) {
  final TextTheme textTheme = Theme.of(context).textTheme.copyWith(
    bodyLarge: Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    bodyMedium: Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
    bodySmall: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
    headlineSmall: Theme.of(
      context,
    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
    titleLarge: Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
  );
  return textTheme;
}
