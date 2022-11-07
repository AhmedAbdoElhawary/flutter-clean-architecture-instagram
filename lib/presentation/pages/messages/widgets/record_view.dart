import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';

class RecordView extends StatefulWidget {
  final String urlRecord;
  final bool isThatMe;
  final bool isThatLocalRecorded;
  final int lengthOfRecord;

  const RecordView({
    Key? key,
    required this.urlRecord,
    required this.isThatMe,
    required this.isThatLocalRecorded,
    required this.lengthOfRecord,
  }) : super(key: key);

  @override
  RecordViewState createState() => RecordViewState();
}

class RecordViewState extends State<RecordView> {
  late int _totalDuration;
  int? _currentDuration;
  int _reverseDuration = 0;

  double _completedPercentage = 1.0;

  bool _isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    _totalDuration = widget.lengthOfRecord - 500000;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color theColor = widget.isThatMe
        ? (isThatMobile ? ColorManager.white : Theme.of(context).focusColor)
        : Theme.of(context).focusColor;
    return Row(
      children: [
        GestureDetector(
          child: _isPlaying
              ? buildIcon(Icons.pause_sharp, theColor)
              : buildIcon(Icons.play_arrow_rounded, theColor),
          onTap: () => _onPlay(urlRecord: widget.urlRecord),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ProgressBar(
            timeLabelLocation: TimeLabelLocation.none,
            thumbColor: theColor,
            total: Duration(microseconds: _totalDuration),
            barHeight: 3,
            thumbRadius: 6.0,
            baseBarColor: widget.isThatMe
                ? (isThatMobile
                    ? ColorManager.darkWhite
                    : ColorManager.veryLowOpacityGrey)
                : ColorManager.veryLowOpacityGrey,
            progressBarColor: theColor,
            progress: Duration(microseconds: _currentDuration ?? 0),
          ),
        ),
        const SizedBox(width: 15),
        // if (_totalDuration != null && _currentDuration != null)
        Text(getReformatDate(), style: getNormalStyle(color: theColor)),
      ],
    );
  }

  String getReformatDate() {
    List<String> datesSeparated;
    if (_completedPercentage < 0.9) {
      double i = ((_reverseDuration * 0.000001) / 60) - 0.02;
      datesSeparated =
          ((i < 0 ? 0 : i).toStringAsFixed(2)).toString().split(".");
    } else {
      double i = ((_totalDuration * 0.000001) / 60) - 0.02;
      datesSeparated = (i < 0 ? 0 : i).toStringAsFixed(2).toString().split(".");
    }
    return "${datesSeparated[0]}:${datesSeparated[1]}";
  }

  Icon buildIcon(IconData icon, Color theColor) =>
      Icon(icon, color: theColor, size: 30);

  Future<void> _onPlay({required String urlRecord}) async {
    if (!_isPlaying) {
      Source url = widget.isThatLocalRecorded
          ? DeviceFileSource(urlRecord)
          : UrlSource(urlRecord);
      audioPlayer.play(url);
      setState(() {
        _isPlaying = true;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _currentDuration = 0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
          _currentDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration!.toDouble() / _totalDuration.toDouble();
          _reverseDuration = _totalDuration - _currentDuration!;
        });
      });
    } else {
      audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }
}
