import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radio_arkiva_islame/constants/action_item_list_data.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/screens/contact_details.dart';
import 'package:radio_arkiva_islame/utils/url_utils.dart';

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
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).padding.bottom + 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              const SectionHeader(
                title: Strings.arkivaIslame,
                showDescription: true,
              ),
              const SectionHeader(title: Strings.connectWithUs),
              const ActionItemList(items: ActionItemListData.socialMediaItems),
              const SectionHeader(title: Strings.writeUs),
              ActionItemList(items: ActionItemListData.contactInfoItems),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  final IconData iconData;
  final String text;
  final String url;
  final double? size;
  final bool useFaIcon;
  final VoidCallback? onTap;

  const ActionItem({
    super.key,
    required this.iconData,
    required this.text,
    required this.url,
    this.size = 24.0,
    this.useFaIcon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget =
        useFaIcon ? FaIcon(iconData, size: size) : Icon(iconData, size: size);

    return InkWell(
      onTap: onTap ?? () => launchValidatedUrl(url),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            SizedBox(width: 28, height: 28, child: Center(child: iconWidget)),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionItemList extends StatelessWidget {
  final List<ActionItem> items;

  const ActionItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: items,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showDescription;
  final Widget? descriptionWidget;

  const SectionHeader({
    super.key,
    required this.title,
    this.showDescription = false,
    this.descriptionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        if (showDescription) descriptionWidget ?? const DescriptionText(),
      ],
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      Strings.description,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
      softWrap: true,
    );
  }
}
