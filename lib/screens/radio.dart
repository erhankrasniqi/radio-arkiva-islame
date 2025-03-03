import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:radio_arkiva_islame/widgets/ad_item.dart';
import 'package:radio_arkiva_islame/widgets/radio_player.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  RadioScreenState createState() => RadioScreenState();
}

class RadioScreenState extends State<RadioScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RadioPlayerWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.0,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Marketing',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: ExpandableCarousel(
                  options: ExpandableCarouselOptions(
                    slideIndicator: CircularStaticIndicator(
                      slideIndicatorOptions: SlideIndicatorOptions(
                        currentIndicatorColor:
                            Theme.of(context).colorScheme.primary,
                        indicatorBackgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        indicatorRadius: 3.5,
                        itemSpacing: 12.0,
                        enableAnimation: true,
                      ),
                    ),
                    enableInfiniteScroll: true,
                    padEnds: false,
                    disableCenter: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 6),
                    autoPlayCurve: Curves.ease,
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    floatingIndicator: false,
                    viewportFraction: 0.7,
                  ),
                  items:
                      [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              margin: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 16.0,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: AdItem(),
                            );
                          },
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
