import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/data/model.dart';
import 'package:radio_arkiva_islame/screens/contact.dart';
import 'package:radio_arkiva_islame/utils/url_utils.dart';

class AdDetails extends StatelessWidget {
  final Ad ad;
  const AdDetails({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final bool hasFacebook =
        ad.facebook.name.trim().isNotEmpty && ad.facebook.url.trim().isNotEmpty;
    final bool hasInstagram =
        ad.instagram.name.trim().isNotEmpty &&
        ad.instagram.url.trim().isNotEmpty;
    final bool showSocialMediaSection = hasFacebook || hasInstagram;
    return Scaffold(
      appBar: AppBar(
        title: Text(ad.title, softWrap: true, overflow: TextOverflow.visible),
        toolbarHeight: 64.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 12.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: ad.image,
              errorWidget:
                  (context, url, error) =>
                      Image.asset(Assets.placeholder, fit: BoxFit.cover),
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  Column(
                    spacing: 8.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.description,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed:
                              () => launchValidatedUrl(ad.callToActionUrl),
                          child: Text(Strings.more),
                        ),
                      ),
                    ],
                  ),
                  SectionHeader(title: Strings.contact),
                  Column(
                    spacing: 12.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ActionItem(
                        iconData: Icons.phone,
                        text: ad.phone,
                        url: "tel:${ad.phone}",
                      ),
                      ActionItem(
                        iconData: Icons.location_on,
                        text: ad.address,
                        url: ad.address,
                        onTap: () => launchGoogleMapsSearch(ad.address),
                      ),
                    ],
                  ),
                  if (showSocialMediaSection) ...[
                    SectionHeader(title: Strings.connectWithUs),
                    Column(
                      spacing: 12.0,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasFacebook)
                          ActionItem(
                            iconData: FontAwesomeIcons.facebook,
                            text: ad.facebook.name,
                            url: ad.facebook.url,
                            size: 24.0,
                          ),
                        if (hasInstagram)
                          ActionItem(
                            iconData: FontAwesomeIcons.instagram,
                            text: ad.instagram.name,
                            url: ad.instagram.url,
                            size: 24.0,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
