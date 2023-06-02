import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'sound_recorder_notifier.dart';

/// used to show mic and show dragg text when
/// press into record icon
class ShowMicWithText extends StatelessWidget {
  final bool shouldShowText;
  final String? slideToCancelText;
  final SoundRecordNotifier soundRecorderState;
  // ignore: sort_constructors_first
  const ShowMicWithText({
    Key? key,
    required this.shouldShowText,
    required this.soundRecorderState,
    required this.slideToCancelText,
  }) : super(key: key);
  final colorizeTextStyle = const TextStyle(
    fontSize: 14.0,
    fontFamily: 'Horizon',
  );
  @override
  Widget build(BuildContext context) {
    bool isButtonPressed = soundRecorderState.buttonPressed;
    return Row(
      mainAxisAlignment:
          !isButtonPressed ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Center(
          child: Transform.scale(
            key: soundRecorderState.key,
            scale: isButtonPressed ? 1.2 : 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(600),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                width: isButtonPressed ? 40 : 24,
                height: isButtonPressed ? 40 : 24,
                child: Container(
                  color: (isButtonPressed)
                      ? ColorManager.blue
                      : ColorManager.transparent,
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.all(isButtonPressed ? 8.0 : 0),
                    child: SvgPicture.asset(
                      "assets/icons/microphone.svg",
                      colorFilter: ColorFilter.mode(
                          (isButtonPressed)
                              ? ColorManager.white
                              : Theme.of(context).focusColor , BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (shouldShowText)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DefaultTextStyle(
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      slideToCancelText ?? "",
                      textStyle: colorizeTextStyle,
                      colors: [
                        ColorManager.black,
                        Colors.grey.shade200,
                        Theme.of(context).focusColor,
                      ],
                    ),
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {},
                ),
              ),
            ),
          ),
      ],
    );
  }
}
