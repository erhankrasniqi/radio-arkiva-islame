import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/data/model.dart';
import 'package:radio_arkiva_islame/screens/ad_details.dart';
import 'package:radio_arkiva_islame/utils/url_utils.dart';

class AdItem extends StatelessWidget {
  final Ad ad;
  const AdItem({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdDetails(ad: ad)),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: ad.image,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) =>
                          Image.asset(Assets.placeholder, fit: BoxFit.cover),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 8.0,
                bottom: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.0,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2.0,
                    children: [
                      Text(
                        ad.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '${ad.description}\n',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8.0,
                    children: [
                      Expanded(
                        flex: 6,
                        child: OutlinedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdDetails(ad: ad),
                              ),
                            );
                          },
                          child: Text(
                            Strings.details,
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: FilledButton(
                          onPressed:
                              () => launchValidatedUrl(ad.callToActionUrl),
                          child: Text(
                            Strings.more,
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
