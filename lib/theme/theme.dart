import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff28638a),
      surfaceTint: Color(0xff28638a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcae6ff),
      onPrimaryContainer: Color(0xff004b70),
      secondary: Color(0xff50606f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd3e5f6),
      onSecondaryContainer: Color(0xff384956),
      tertiary: Color(0xff65587b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffebdcff),
      onTertiaryContainer: Color(0xff4d4162),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff181c20),
      onSurfaceVariant: Color(0xff41474d),
      outline: Color(0xff72787e),
      outlineVariant: Color(0xffc1c7ce),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff96ccf8),
      primaryFixed: Color(0xffcae6ff),
      onPrimaryFixed: Color(0xff001e30),
      primaryFixedDim: Color(0xff96ccf8),
      onPrimaryFixedVariant: Color(0xff004b70),
      secondaryFixed: Color(0xffd3e5f6),
      onSecondaryFixed: Color(0xff0c1d29),
      secondaryFixedDim: Color(0xffb7c9d9),
      onSecondaryFixedVariant: Color(0xff384956),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff201634),
      tertiaryFixedDim: Color(0xffcfc0e8),
      onTertiaryFixedVariant: Color(0xff4d4162),
      surfaceDim: Color(0xffd7dadf),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f4f9),
      surfaceContainer: Color(0xffebeef3),
      surfaceContainerHigh: Color(0xffe5e8ed),
      surfaceContainerHighest: Color(0xffe0e3e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003a57),
      surfaceTint: Color(0xff28638a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff3a7299),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff283845),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5f6f7e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3c3051),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff74678b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff0e1215),
      onSurfaceVariant: Color(0xff31373d),
      outline: Color(0xff4d5359),
      outlineVariant: Color(0xff686e74),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff96ccf8),
      primaryFixed: Color(0xff3a7299),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff1b5a7f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5f6f7e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff465765),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff74678b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5b4f71),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c7cc),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f4f9),
      surfaceContainer: Color(0xffe5e8ed),
      surfaceContainerHigh: Color(0xffdadde2),
      surfaceContainerHighest: Color(0xffcfd2d7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002f49),
      surfaceTint: Color(0xff28638a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff044e73),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1e2e3b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3b4b59),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff322646),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4f4365),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272d32),
      outlineVariant: Color(0xff444a50),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff96ccf8),
      primaryFixed: Color(0xff044e73),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003652),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3b4b59),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff243441),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4f4365),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff382d4d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb6b9be),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeef1f6),
      surfaceContainer: Color(0xffe0e3e8),
      surfaceContainerHigh: Color(0xffd1d5da),
      surfaceContainerHighest: Color(0xffc3c7cc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96ccf8),
      surfaceTint: Color(0xff96ccf8),
      onPrimary: Color(0xff00344f),
      primaryContainer: Color(0xff004b70),
      onPrimaryContainer: Color(0xffcae6ff),
      secondary: Color(0xffb7c9d9),
      onSecondary: Color(0xff22323f),
      secondaryContainer: Color(0xff384956),
      onSecondaryContainer: Color(0xffd3e5f6),
      tertiary: Color(0xffcfc0e8),
      onTertiary: Color(0xff362b4a),
      tertiaryContainer: Color(0xff4d4162),
      onTertiaryContainer: Color(0xffebdcff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101417),
      onSurface: Color(0xffe0e3e8),
      onSurfaceVariant: Color(0xffc1c7ce),
      outline: Color(0xff8b9198),
      outlineVariant: Color(0xff41474d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e8),
      inversePrimary: Color(0xff28638a),
      primaryFixed: Color(0xffcae6ff),
      onPrimaryFixed: Color(0xff001e30),
      primaryFixedDim: Color(0xff96ccf8),
      onPrimaryFixedVariant: Color(0xff004b70),
      secondaryFixed: Color(0xffd3e5f6),
      onSecondaryFixed: Color(0xff0c1d29),
      secondaryFixedDim: Color(0xffb7c9d9),
      onSecondaryFixedVariant: Color(0xff384956),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff201634),
      tertiaryFixedDim: Color(0xffcfc0e8),
      onTertiaryFixedVariant: Color(0xff4d4162),
      surfaceDim: Color(0xff101417),
      surfaceBright: Color(0xff363a3e),
      surfaceContainerLowest: Color(0xff0b0f12),
      surfaceContainerLow: Color(0xff181c20),
      surfaceContainer: Color(0xff1c2024),
      surfaceContainerHigh: Color(0xff262a2e),
      surfaceContainerHighest: Color(0xff313539),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbee0ff),
      surfaceTint: Color(0xff96ccf8),
      onPrimary: Color(0xff00283f),
      primaryContainer: Color(0xff6096bf),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcddeef),
      onSecondary: Color(0xff172734),
      secondaryContainer: Color(0xff8293a2),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe6d5fe),
      onTertiary: Color(0xff2b203f),
      tertiaryContainer: Color(0xff998ab0),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd7dde4),
      outline: Color(0xffadb2b9),
      outlineVariant: Color(0xff8b9198),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e8),
      inversePrimary: Color(0xff014c72),
      primaryFixed: Color(0xffcae6ff),
      onPrimaryFixed: Color(0xff001320),
      primaryFixedDim: Color(0xff96ccf8),
      onPrimaryFixedVariant: Color(0xff003a57),
      secondaryFixed: Color(0xffd3e5f6),
      onSecondaryFixed: Color(0xff02131e),
      secondaryFixedDim: Color(0xffb7c9d9),
      onSecondaryFixedVariant: Color(0xff283845),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff160b29),
      tertiaryFixedDim: Color(0xffcfc0e8),
      onTertiaryFixedVariant: Color(0xff3c3051),
      surfaceDim: Color(0xff101417),
      surfaceBright: Color(0xff414549),
      surfaceContainerLowest: Color(0xff05080b),
      surfaceContainerLow: Color(0xff1a1e22),
      surfaceContainer: Color(0xff24282c),
      surfaceContainerHigh: Color(0xff2f3337),
      surfaceContainerHighest: Color(0xff3a3e42),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe5f1ff),
      surfaceTint: Color(0xff96ccf8),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff92c9f4),
      onPrimaryContainer: Color(0xff000d17),
      secondary: Color(0xffe5f1ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb4c5d5),
      onSecondaryContainer: Color(0xff000d17),
      tertiary: Color(0xfff6ecff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffccbce4),
      onTertiaryContainer: Color(0xff100523),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff101417),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffebf0f8),
      outlineVariant: Color(0xffbdc3ca),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e3e8),
      inversePrimary: Color(0xff014c72),
      primaryFixed: Color(0xffcae6ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff96ccf8),
      onPrimaryFixedVariant: Color(0xff001320),
      secondaryFixed: Color(0xffd3e5f6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb7c9d9),
      onSecondaryFixedVariant: Color(0xff02131e),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcfc0e8),
      onTertiaryFixedVariant: Color(0xff160b29),
      surfaceDim: Color(0xff101417),
      surfaceBright: Color(0xff4d5055),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c2024),
      surfaceContainer: Color(0xff2d3135),
      surfaceContainerHigh: Color(0xff383c40),
      surfaceContainerHighest: Color(0xff43474b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xfff8b735),
    value: Color(0xfff8b735),
    light: ColorFamily(
      color: Color(0xff7b580d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdeaa),
      onColorContainer: Color(0xff5f4100),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff7b580d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdeaa),
      onColorContainer: Color(0xff5f4100),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff7b580d),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffdeaa),
      onColorContainer: Color(0xff5f4100),
    ),
    dark: ColorFamily(
      color: Color(0xffefbf6d),
      onColor: Color(0xff422c00),
      colorContainer: Color(0xff5f4100),
      onColorContainer: Color(0xffffdeaa),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffefbf6d),
      onColor: Color(0xff422c00),
      colorContainer: Color(0xff5f4100),
      onColorContainer: Color(0xffffdeaa),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffefbf6d),
      onColor: Color(0xff422c00),
      colorContainer: Color(0xff5f4100),
      onColorContainer: Color(0xffffdeaa),
    ),
  );

  List<ExtendedColor> get extendedColors => [customColor1];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
