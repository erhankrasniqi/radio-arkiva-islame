import 'package:radio_arkiva_islame/utils/debug_utils.dart';
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
