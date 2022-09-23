import 'dart:io';
import 'dart:async';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:flutter/material.dart';

import 'show_counter.dart';
import 'sound_recorder_notifier.dart';

class SoundRecorderWhenLockedDesign extends StatelessWidget {
  final SoundRecordNotifier soundRecordNotifier;
  final String? cancelText;
  final ValueChanged<bool> showIcons;
  final Function(File soundFile, int lengthOfRecord) sendRequestFunction;
  final Color recordIconWhenLockBackGroundColor;
  const SoundRecorderWhenLockedDesign({
    Key? key,
    required this.soundRecordNotifier,
    required this.showIcons,
    required this.cancelText,
    required this.sendRequestFunction,
    required this.recordIconWhenLockBackGroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      color: ColorManager.transparent,
      child: InkWell(
        onTap: () {
          soundRecordNotifier.isShow = false;
          soundRecordNotifier.resetEdgePadding();
        },
        child: Row(
          children: [
            InkWell(
              onTap: () async {
                soundRecordNotifier.isShow = false;
                if (soundRecordNotifier.second > 1 ||
                    soundRecordNotifier.minute > 0) {
                  String path = soundRecordNotifier.mPath;
                  await Future.delayed(const Duration(milliseconds: 500));
                  sendRequestFunction(File.fromUri(Uri(path: path)),
                      soundRecordNotifier.second);
                }
                soundRecordNotifier.resetEdgePadding();
                showIcons(true);
              },
              child: Transform.scale(
                scale: 1.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(600),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    width: 40,
                    height: 40,
                    child: Container(
                      color: recordIconWhenLockBackGroundColor,
                      child: const Padding(
                        padding: EdgeInsetsDirectional.all(4.0),
                        child: Icon(
                          Icons.send,
                          textDirection: TextDirection.ltr,
                          size: 25,
                          color: ColorManager.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    soundRecordNotifier.isShow = false;
                    soundRecordNotifier.resetEdgePadding();
                    showIcons(true);
                  },
                  child: Padding(
                    padding: const EdgeInsetsDirectional.all(8.0),
                    child: Text(
                      cancelText ?? "",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                  )),
            ),
            ShowCounter(
              soundRecorderState: soundRecordNotifier,
            ),
          ],
        ),
      ),
    );
  }
}
