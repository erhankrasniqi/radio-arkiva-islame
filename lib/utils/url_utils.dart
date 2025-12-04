import 'dart:io';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/utils/debug_utils.dart';
import 'package:radio_arkiva_islame/utils/fab_loader.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchValidatedUrl(String urlString) async {
  urlString = urlString.trim();

  if (!urlString.startsWith('tel:') &&
      !urlString.startsWith('mailto:') &&
      !urlString.startsWith('http://') &&
      !urlString.startsWith('https://')) {
    urlString = 'https://$urlString';
  }

  final Uri? uri = Uri.tryParse(urlString);
  if (uri == null ||
      (uri.host.isEmpty && uri.scheme != 'tel' && uri.scheme != 'mailto')) {
    logDebug('Invalid URL: $urlString');
    return;
  }

  try {
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  } catch (e) {
    logDebug('Error launching URL: $e');
  }
}

Future<void> launchGoogleMapsSearch(String query) async {
  final String encodedQuery = Uri.encodeComponent(query);
  final Uri mapsUrl = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$encodedQuery',
  );
  if (!await launchUrl(mapsUrl)) {
    throw 'Could not launch $mapsUrl';
  }
}

Future<void> openViberChat() async {
  const phoneNumber = Strings.viberPhoneNumber;
  const message = Strings.hello;

  FabLoader.startLoading();

  try {
    final Uri? viberUri = Uri.tryParse(
      'viber://chat/?number=+$phoneNumber&draft=$message',
    );

    if (!await launchUrl(viberUri!, mode: LaunchMode.externalApplication)) {
      final Uri appStoreUri =
          Platform.isIOS
              ? Uri.parse('itms-apps://itunes.apple.com/app/id382617920')
              : Uri.parse(
                'https://play.google.com/store/apps/details?id=com.viber.voip',
              );

      if (await canLaunchUrl(appStoreUri)) {
        await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
      } else {
        logDebug('Could not open Viber or App Store/Play Store');
      }
    }
  } catch (e) {
    logDebug('Error launching Viber: $e');
  } finally {
    FabLoader.stopLoading();
  }
}
