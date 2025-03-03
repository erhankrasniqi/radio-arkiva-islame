import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,
    baseTextTheme,
  );
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: baseTextTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
    bodyMedium: baseTextTheme.bodyMedium!.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodySmall: baseTextTheme.bodySmall!.copyWith(fontSize: 14),
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
    headlineSmall: baseTextTheme.headlineSmall!.copyWith(
      fontWeight: FontWeight.w900,
    ),
    titleLarge: baseTextTheme.titleLarge!.copyWith(fontWeight: FontWeight.w700),
  );
  return textTheme;
}
