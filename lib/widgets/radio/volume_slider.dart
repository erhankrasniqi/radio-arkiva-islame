import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';
import 'dart:async';

class VolumeSliderWidget extends StatefulWidget {
  const VolumeSliderWidget({super.key});

  @override
  VolumeSliderWidgetState createState() => VolumeSliderWidgetState();
}

class VolumeSliderWidgetState extends State<VolumeSliderWidget> {
  late final VolumeController _volumeController;
  late final StreamSubscription<double> _subscription;

  double _volumeValue = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _volumeController = VolumeController.instance;

    _subscription = _volumeController.addListener((volume) {
      if (!_isDragging) {
        setState(() => _volumeValue = volume);
      }
    }, fetchInitialVolume: true);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.volume_down,
          size: 24.0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        Expanded(
          child: Slider(
            activeColor: Theme.of(context).colorScheme.secondary,
            inactiveColor: Theme.of(context).colorScheme.surfaceContainerLowest,
            min: 0,
            max: 1,
            onChanged: (double value) {
              setState(() {
                _isDragging = true;
                _volumeValue = value;
              });
            },
            onChangeEnd: (double value) async {
              setState(() => _isDragging = false);
              await _volumeController.setVolume(value);
            },
            value: _volumeValue,
          ),
        ),
        Icon(Icons.volume_up, size: 24.0),
      ],
    );
  }
}
