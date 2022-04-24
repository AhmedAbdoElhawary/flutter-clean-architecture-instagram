import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'dart:io';

class RecorderView extends StatefulWidget {
  final Function onSaved;

  const RecorderView({Key? key, required this.onSaved}) : super(key: key);
  @override
  _RecorderViewState createState() => _RecorderViewState();
}

enum RecordingState {
  nSet,
  set,
  recording,
  stopped,
}
  SvgPicture microphoneIcon() => SvgPicture.asset("assets/icons/microphone.svg", height: 25);

class _RecorderViewState extends State<RecorderView> {
  Widget _recordIcon = microphoneIcon();
  RecordingState _recordingState = RecordingState.nSet;

  late FlutterAudioRecorder2 audioRecorder;

  @override
  void initState() {
    super.initState();

    FlutterAudioRecorder2.hasPermissions.then((hasPermission) {
      if (hasPermission!) {
        _recordingState = RecordingState.set;
        _recordIcon = microphoneIcon();
      }
    });
  }


  @override
  void dispose() {
    _recordingState = RecordingState.nSet;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (e) async {
        await _onRecordButtonPressed();
        setState(() {});
      },
      onLongPressEnd: (e) async {
        await _onRecordButtonPressed();
        setState(() {});
      },
      child:_recordIcon ,
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.set:
        await _recordVoice();
        break;

      case RecordingState.recording:
        await _stopRecording();
        _recordingState = RecordingState.stopped;
        _recordIcon = SvgPicture.asset("assets/icons/microphone.svg", height: 25);
        break;

      case RecordingState.stopped:
        await _recordVoice();
        break;

      case RecordingState.nSet:
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';

    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
  }

  _stopRecording() async {
    await audioRecorder.stop();

    widget.onSaved();
  }

  Future<void> _recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();

      await _startRecording();
      _recordingState = RecordingState.recording;
      _recordIcon = SvgPicture.asset("assets/icons/microphone_black.svg", height: 25);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please allow recording from settings.'),
      ));
    }
  }
}
