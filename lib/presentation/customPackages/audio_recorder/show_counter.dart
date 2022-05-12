import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/presentation/customPackages/audio_recorder/sound_recorder_notifier.dart';

/// Used this class to show counter and mic Icon
class ShowCounter extends StatelessWidget {
  final SoundRecordNotifier soundRecorderState;
  const ShowCounter({
    required this.soundRecorderState,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.2,
        color: ColorManager.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  soundRecorderState.second.toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(width: 3),
                Text(" : ", style: Theme.of(context).textTheme.bodyText1),
                Text(
                  soundRecorderState.minute.toString().padLeft(2, '0'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: soundRecorderState.second % 2 == 0 ? 1 : 0,
              child: const Icon(
                Icons.mic,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
