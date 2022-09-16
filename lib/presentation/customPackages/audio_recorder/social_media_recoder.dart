import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'lock_record.dart';
import 'show_counter.dart';
import 'show_mic_and_counter.dart';
import 'sound_recorder_notifier.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'sound_recorder_when_locked_design.dart';

class SocialMediaRecorder extends StatefulWidget {
  /// function reture the recording sound file
  final Function(File soundFile, int lengthOfRecord) sendRequestFunction;

  /// text to know user should drag in the left to cancel record
  final String? slideToCancelText;

  /// this text show when lock record and to tell user should press in this text to cancel recod
  final String? cancelText;
  final ValueChanged<bool> showIcons;

  // ignore: sort_constructors_first
  const SocialMediaRecorder({
    required this.sendRequestFunction,
    required this.showIcons,
    this.slideToCancelText = " Slide to Cancel >",
    this.cancelText = "Cancel",
    Key? key,
  }) : super(key: key);

  @override
  SocialMediaRecorderS createState() => SocialMediaRecorderS();
}

class SocialMediaRecorderS extends State<SocialMediaRecorder> {
  late SoundRecordNotifier soundRecordNotifier;

  @override
  void initState() {
    soundRecordNotifier = SoundRecordNotifier();
    soundRecordNotifier.initialStorePathRecord = "";
    soundRecordNotifier.isShow = false;
    soundRecordNotifier.voidInitialSound();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => soundRecordNotifier),
      ],
      child: Consumer<SoundRecordNotifier>(
        builder: (context, value, _) {
          return Directionality(
              textDirection: TextDirection.rtl, child: makeBody(value));
        },
      ),
    );
  }

  Widget makeBody(SoundRecordNotifier state) {
    return GestureDetector(
      onHorizontalDragUpdate: (scrollEnd) {
        state.updateScrollValue(scrollEnd.globalPosition, context);
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: recordVoice(state),
      ),
    );
  }

  Widget recordVoice(SoundRecordNotifier state) {
    if (state.lockScreenRecord == true) {
      return SoundRecorderWhenLockedDesign(
        cancelText: widget.cancelText,
        showIcons: widget.showIcons,
        recordIconWhenLockBackGroundColor: Colors.blue,
        sendRequestFunction: widget.sendRequestFunction,
        soundRecordNotifier: state,
      );
    }

    return Listener(
      onPointerDown: (details) async {
        state.setNewInitialDraggableHeight(details.position.dy);
        state.resetEdgePadding();
        widget.showIcons(false);
        soundRecordNotifier.isShow = true;
        state.record();
      },
      onPointerUp: (details) async {
        if (!state.isLocked) {
          if (state.buttonPressed) {
            if (state.second > 1 || state.minute > 0) {
              String path = state.mPath;

              widget.sendRequestFunction(
                  File.fromUri(Uri(path: path)), state.second);
            }
            widget.showIcons(true);
          }
          state.resetEdgePadding();
        }
      },
      child: AnimatedContainer(
          duration:
              Duration(milliseconds: soundRecordNotifier.isShow ? 0 : 300),
          height: 50,
          width: (soundRecordNotifier.isShow)
              ? MediaQuery.of(context).size.width * .8
              : 40,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: state.edge),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: soundRecordNotifier.isShow
                        ? BorderRadius.circular(12)
                        : BorderRadius.circular(0),
                    color: ColorManager.transparent,
                  ),
                  child: Stack(
                    children: [
                      ShowMicWithText(
                        shouldShowText: soundRecordNotifier.isShow,
                        soundRecorderState: state,
                        slideToCancelText: widget.slideToCancelText,
                      ),
                      if (soundRecordNotifier.isShow)
                        ShowCounter(soundRecorderState: state),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 60, child: LockRecord(soundRecorderState: state))
            ],
          )),
    );
  }
}
