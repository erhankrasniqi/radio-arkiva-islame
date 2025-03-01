import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radio_arkiva_islame/screens/contact_details.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('fab'),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 3,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactDetails()),
          );
        },
        child: const Icon(Icons.edit_outlined),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: 56.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              const SectionHeaderWithDescription(title: "Radio Arkiva Islame"),
              const SectionHeader(title: "Lidhuni me Ne"),
              const SocialMediaList(),
              const SectionHeader(title: "Na Kontaktoni"),
              const ContactInfoList(),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeaderWithDescription extends StatelessWidget {
  final String title;

  const SectionHeaderWithDescription({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 50,
            height: 6,
            color: const Color(0xFFF8B735),
          ),
        ),
        const DescriptionText(),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 50,
            height: 6,
            color: const Color(0xFFF8B735),
          ),
        ),
      ],
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Faleminderit që jeni duke vizituar Radio Islame! Ne jemi gjithmonë të gatshëm për të dëgjuar nga ju dhe për të ofruar mbështetje.\n\nNëse keni ndonjë pyetje, sugjerim, ose nevojë për informacion shtesë, mund të na kontaktoni përmes formës më poshtë ose përmes informacionit të dhënë.",
      style: Theme.of(context).textTheme.bodyMedium,
      softWrap: true,
    );
  }
}

class SocialMediaList extends StatelessWidget {
  const SocialMediaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: const [
        SocialMediaItem(
          icon: Icons.web,
          size: 28.0,
          text: "www.arkivaislame.com",
          url: "https://arkivaislame.com/",
        ),
        SocialMediaItem(
          icon: FontAwesomeIcons.facebook,
          size: 24.0,
          text: "Arkiva Islame",
          url: "https://www.facebook.com/arkivaislam",
        ),
        SocialMediaItem(
          icon: FontAwesomeIcons.youtube,
          size: 24.0,
          text: "@arkivaislame1675",
          url: "https://www.youtube.com/@arkivaislame1675",
        ),
        SocialMediaItem(
          icon: FontAwesomeIcons.instagram,
          size: 24.0,
          text: "arkiva_islame",
          url: "https://www.instagram.com/arkiva_islame",
        ),
      ],
    );
  }
}

class SocialMediaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String url;
  final double size;

  const SocialMediaItem({
    super.key,
    required this.icon,
    required this.text,
    required this.url,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          spacing: 12,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Center(child: FaIcon(icon, size: size)),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
              softWrap: true,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoList extends StatelessWidget {
  const ContactInfoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: const [
        ContactItem(icon: Icons.location_on, text: "Kosovë"),
        ContactItem(
          icon: Icons.phone,
          text: "+383 44 477 094",
          url: "tel:+38344477094",
        ),
        ContactItem(
          icon: Icons.email,
          text: "contact@arkivaislame.com",
          url: "mailto:contact@arkivaislame.com",
        ),
      ],
    );
  }
}

class ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? url;

  const ContactItem({
    super.key,
    required this.icon,
    required this.text,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: url != null ? () => launchUrl(Uri.parse(url!)) : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          spacing: 12,
          children: [
            Icon(icon),
            Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
