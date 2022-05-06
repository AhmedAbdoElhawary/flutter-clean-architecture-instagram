import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:instegram/core/resources/color_manager.dart';
import 'package:instegram/core/resources/strings_manager.dart';

class RecordView extends StatefulWidget {
  final String record;
  const RecordView({
    Key? key,
    required this.record,
  }) : super(key: key);

  @override
  _RecordViewState createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  int? _totalDuration;
  int? _currentDuration;
  int _reverseDuration = 0;

  double _completedPercentage = 0.0;

  bool _isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return widget.record.isEmpty
        ?  Center(child: Text(StringsManager.noRecordsYet,style: Theme.of(context).textTheme.bodyText1,))
        : Row(
            children: [
              GestureDetector(
                child: _isPlaying
                    ? buildIcon(Icons.pause_sharp)
                    : buildIcon(Icons.play_arrow_rounded),
                onTap: () => _onPlay(filePath: widget.record),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ProgressBar(
                  timeLabelLocation: TimeLabelLocation.none,
                  thumbColor: ColorManager.white,
                  total: Duration(microseconds: _totalDuration ?? 0),
                  barHeight: 3,
                  thumbRadius: 6.0,
                  baseBarColor: const Color.fromARGB(79, 255, 255, 255),
                  progressBarColor: ColorManager.white,
                  progress: Duration(microseconds: _currentDuration ?? 0),
                ),
              ),
              const SizedBox(width: 15),
              if (_totalDuration != null && _currentDuration != null)
                Text(getReformatDate(),
                    style:Theme.of(context).textTheme.bodyText1),
            ],
          );
  }

  String getReformatDate() {
    List<String> datesSeparated;
    if (_completedPercentage < 0.9) {
      datesSeparated = (((_reverseDuration * 0.000001) / 60).toStringAsFixed(2))
          .toString()
          .split(".");
    } else {
      datesSeparated = ((_totalDuration! * 0.000001) / 60)
          .toStringAsFixed(2)
          .toString()
          .split(".");
    }
    return "${datesSeparated[0]}:${datesSeparated[1]}";
  }

  Icon buildIcon(IconData icon) => Icon(icon, color: ColorManager.white, size: 30);

  Future<void> _onPlay({required String filePath}) async {
    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
          _currentDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration!.toDouble() / _totalDuration!.toDouble();
          _reverseDuration = _totalDuration! - _currentDuration!;
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
