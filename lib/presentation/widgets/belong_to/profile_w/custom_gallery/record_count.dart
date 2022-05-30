import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class RecordCount extends StatefulWidget {
  final ValueNotifier<bool> startVideoCount;
  final ValueNotifier<bool> makeProgressRed;
  final ValueNotifier<bool> clearVideoRecord;

  const RecordCount({
    Key? key,
    required this.startVideoCount,
    required this.makeProgressRed,
    required this.clearVideoRecord,
  }) : super(key: key);

  @override
  RecordCountState createState() => RecordCountState();
}

class RecordCountState extends State<RecordCount>
    with TickerProviderStateMixin {
  late AnimationController controller;
  double opacityLevel = 1.0;
  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration! * controller.value;
    if (controller.isDismissed) {
      return '0:00';
    } else {
      return '${(count.inMinutes % 60).toString().padLeft(1, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  double progress = 0;

  void notify() {
    if (countText == '0:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 0;
          isPlaying = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(RecordCount oldWidget) {
    if (widget.startVideoCount.value) {
      controller.forward(from: controller.value == 1.0 ? 0 : controller.value);
      setState(() {
        isPlaying = true;
        opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
      });
    } else {
      if (widget.clearVideoRecord.value) {
        widget.clearVideoRecord.value = false;
        controller.reset();
        setState(() {
          isPlaying = false;
        });
      } else {
        controller.stop();
        setState(() {
          isPlaying = false;
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          color: widget.makeProgressRed.value ? Colors.red : Theme.of(context).focusColor,
          backgroundColor: Colors.transparent,
          value: progress,
          minHeight: 3,
        ),
        Visibility(
          visible: widget.startVideoCount.value,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  opacity: opacityLevel,
                  duration: const Duration(seconds: 1),
                  child: const Icon(Icons.fiber_manual_record_rounded,
                      color: Colors.red, size: 10),
                  onEnd: () {
                    if (isPlaying) {
                      setState(
                          () => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
                    }
                  },
                ),
                const SizedBox(width: 5),
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => Text(
                    countText,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
