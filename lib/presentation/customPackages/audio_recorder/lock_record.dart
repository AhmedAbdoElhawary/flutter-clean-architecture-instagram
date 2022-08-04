import 'package:flutter/material.dart';
import 'sound_recorder_notifier.dart';

/// This Class Represent Icons To swap top to lock recording
class LockRecord extends StatefulWidget {
  /// Object From Provider Notifier
  final SoundRecordNotifier soundRecorderState;
  // ignore: sort_constructors_first
  const LockRecord({
    required this.soundRecorderState,
    Key? key,
  }) : super(key: key);
  @override
  LockRecordState createState() => LockRecordState();
}

class LockRecordState extends State<LockRecord> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    /// If click the Button Then send show lock and un lock icon
    if (!widget.soundRecorderState.buttonPressed) return Container();
    return AnimatedPadding(
      duration: const Duration(seconds: 1),
      padding: EdgeInsetsDirectional.all(
          widget.soundRecorderState.second % 2 == 0 ? 0 : 8),
      child: Transform.translate(
        offset: const Offset(0, -70),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
            opacity: widget.soundRecorderState.edge >= 50 ? 0 : 1,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(8.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        opacity:
                            widget.soundRecorderState.second % 2 != 0 ? 0 : 1,
                        child: Icon(
                          Icons.lock_outline_rounded,
                          color: Theme.of(context).focusColor,
                        )),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        opacity:
                            widget.soundRecorderState.second % 2 == 0 ? 0 : 1,
                        child: Icon(Icons.lock_open_rounded,
                            color: Theme.of(context).focusColor)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
