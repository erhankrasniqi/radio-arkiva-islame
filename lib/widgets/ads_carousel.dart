import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/data/model.dart';
import 'package:radio_arkiva_islame/services/firestore_service.dart';
import 'package:radio_arkiva_islame/utils/debug_utils.dart'; // Import utility
import 'ad_item.dart';

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({super.key});

  @override
  AdsCarouselState createState() => AdsCarouselState();
}

class AdsCarouselState extends State<AdsCarousel> {
  late final Stream<List<Ad>> _adsStream;

  @override
  void initState() {
    super.initState();
    _adsStream = FirestoreService().getAds();
    logDebug("AdsCarousel: Initialized ads stream.");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ad>>(
      stream: _adsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          logDebug("AdsCarousel: Waiting for ads data.");
          return _buildLoadingWidget();
        }
        if (snapshot.hasError) {
          logDebug("AdsCarousel: Error loading ads: ${snapshot.error}");
          return _buildMessageWidget(Strings.errorLoadingAds);
        }
        final ads = snapshot.data ?? [];
        logDebug("AdsCarousel: Received ${ads.length} ads.");
        if (ads.isEmpty) {
          logDebug("AdsCarousel: No ads available.");
          return _buildMessageWidget(Strings.noAds);
        }

        final precacheFuture = Future.wait(
          ads.map((ad) {
            logDebug("AdsCarousel: Pre-caching image for ad: ${ad.image}");
            return precacheImage(CachedNetworkImageProvider(ad.image), context);
          }).toList(),
        );

        return FutureBuilder(
          future: precacheFuture,
          builder: (context, precacheSnapshot) {
            if (precacheSnapshot.connectionState != ConnectionState.done) {
              logDebug("AdsCarousel: Waiting for images to pre-cache.");
              return _buildLoadingWidget();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ExpandableCarousel(
                key: ValueKey("ads_carousel"),
                options: ExpandableCarouselOptions(
                  enableInfiniteScroll: false,
                  padEnds: true,
                  disableCenter: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 6),
                  autoPlayCurve: Curves.ease,
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  floatingIndicator: false,
                  viewportFraction: 0.85,
                  slideIndicator: CircularStaticIndicator(
                    slideIndicatorOptions: SlideIndicatorOptions(
                      currentIndicatorColor:
                          Theme.of(context).colorScheme.primary,
                      indicatorBackgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      indicatorRadius: 3.5,
                      itemSpacing: 12.0,
                      enableAnimation: true,
                    ),
                  ),
                ),
                items:
                    ads.map((ad) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.only(
                              right: 8.0,
                              bottom: 16.0,
                            ),
                            child: AdItem(ad: ad),
                          );
                        },
                      );
                    }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingWidget() {
    return const SizedBox(
      height: 300,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMessageWidget(String text) {
    return SizedBox(height: 300.0, child: Center(child: Text(text)));
  }
}
