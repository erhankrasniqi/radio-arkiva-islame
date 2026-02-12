import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radio_arkiva_islame/screens/contact.dart';
import 'package:radio_arkiva_islame/utils/url_utils.dart';

class ActionItemListData {
  static const socialMediaItems = [
    ActionItem(
      iconData: FontAwesomeIcons.facebook,
      text: "Arkiva Islame",
      url: "https://www.facebook.com/arkivaislam",
      useFaIcon: true,
    ),
    ActionItem(
      iconData: FontAwesomeIcons.youtube,
      text: "@arkivaislame1675",
      url: "https://www.youtube.com/@arkivaislame1675",
      useFaIcon: true,
    ),
    ActionItem(
      iconData: FontAwesomeIcons.instagram,
      text: "arkiva_islame",
      url: "https://www.instagram.com/arkiva_islame",
      useFaIcon: true,
    ),
  ];

  static final contactInfoItems = [
    ActionItem(
      iconData: Icons.location_on,
      text: "Kosovë",
      url: "Kosovë",
      onTap: () => launchGoogleMapsSearch("Kosovë"),
    ),
    const ActionItem(
      iconData: Icons.email,
      text: "arkivaislame@hotmail.com",
      url:
          "mailto:arkivaislame@hotmail.com?subject=Pyetje rreth shërbimeve tuaja",
    ),
    ActionItem(
      iconData: FontAwesomeIcons.viber,
      text: "+383 44 477 094",
      url: "+383 44 477 094",
      useFaIcon: true,
      onTap: () => openViberChat(),
    ),
  ];
}
