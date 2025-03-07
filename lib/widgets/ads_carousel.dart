import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/data/model.dart';
import 'package:radio_arkiva_islame/services/firestore_service.dart';
import 'ad_item.dart';

class AdsCarousel extends StatelessWidget {
  const AdsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Ad>>(
      stream: FirestoreService().getAds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }
        if (snapshot.hasError) {
          return _buildMessageWidget(Strings.errorLoadingAds);
        }
        final ads = snapshot.data ?? [];
        if (ads.isEmpty) {
          return _buildMessageWidget(Strings.noAds);
        }
        final precacheFuture = Future.wait(
          ads
              .map(
                (ad) => precacheImage(
                  CachedNetworkImageProvider(ad.image),
                  context,
                ),
              )
              .toList(),
        );
        return FutureBuilder(
          future: precacheFuture,
          builder: (context, precacheSnapshot) {
            if (precacheSnapshot.connectionState != ConnectionState.done) {
              return _buildLoadingWidget();
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ExpandableCarousel(
                key: const ValueKey("ads_carousel"),
                options: ExpandableCarouselOptions(
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
                  enableInfiniteScroll: true,
                  padEnds: false,
                  disableCenter: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 6),
                  autoPlayCurve: Curves.ease,
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  floatingIndicator: false,
                  viewportFraction: 0.7,
                ),
                items:
                    ads.map((ad) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.only(
                              left: 8.0,
                              bottom: 16.0,
                            ),
                            width: MediaQuery.of(context).size.width,
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
