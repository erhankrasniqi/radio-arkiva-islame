import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class VolumeSliderWidget extends StatefulWidget {
  const VolumeSliderWidget({super.key});

  @override
  VolumeSliderWidgetState createState() => VolumeSliderWidgetState();
}

class VolumeSliderWidgetState extends State<VolumeSliderWidget> {
  double setVolumeValue = 0;

  @override
  void initState() {
    super.initState();

    FlutterVolumeController.updateShowSystemUI(true);

    FlutterVolumeController.getVolume().then((volume) {
      if (mounted) {
        setState(() {
          setVolumeValue = volume ?? 0.0;
        });
      }
    });

    FlutterVolumeController.addListener((volume) {
      if (mounted && volume != setVolumeValue) {
        setState(() {
          setVolumeValue = volume;
        });
      }
    });
  }

  @override
  void dispose() {
    FlutterVolumeController.removeListener();
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
                setVolumeValue = value;
              });
            },
            onChangeEnd: (double value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                FlutterVolumeController.setVolume(value);
              });
            },
            value: setVolumeValue,
          ),
        ),
        Icon(Icons.volume_up, size: 24.0),
      ],
    );
  }
}
