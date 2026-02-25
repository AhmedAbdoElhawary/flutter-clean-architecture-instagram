import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:instagram/core/resources/color_manager.dart';
import 'package:instagram/core/resources/styles_manager.dart';
import 'package:instagram/core/utility/constant.dart';
import 'package:instagram/core/utility/private_keys.dart';
import 'package:instagram/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instagram/presentation/cubit/callingRooms/calling_rooms_cubit.dart';
import 'package:instagram/presentation/cubit/firestoreUserInfoCubit/user_info_cubit.dart';
import 'package:instagram/presentation/widgets/global/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:permission_handler/permission_handler.dart';

enum UserCallingType { sender, receiver }

class CallPage extends StatefulWidget {
  final String channelName;
  final String userCallingId;

  final List<UserPersonalInfo>? usersInfo;
  final UserCallingType userCallingType;
  final ClientRoleType role;

  const CallPage({
    super.key,
    required this.channelName,
    this.userCallingId = "",
    required this.userCallingType,
    required this.role,
    this.usersInfo,
  });

  @override
  CallPageState createState() => CallPageState();
}

class CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool moreThanOne = false;

  late RtcEngine _engine;
  late UserPersonalInfo myPersonalInfo;
  @override
  void dispose() {
    _users.clear();
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  void initState() {
    super.initState();
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async => await onJoin());

    initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await onJoin());
  }

  Future<void> onJoin() async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
  }

  Future<void> _handleCameraAndMic(Permission permission) async =>
      await permission.request();

  /// Create your own app id with agora with "testing mode"
  /// it's very simple, just go to https://www.agora.io/en/ and create your own project and get your own app id in [agoraAppId]
  /// Again, don't make it with secure mode ,You will lose the creation of several channels.
  /// Make it with "testing mode"
  Future<void> initialize() async {
    if (agoraAppId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    const VideoEncoderConfiguration configuration = VideoEncoderConfiguration(
      dimensions: VideoDimensions(width: 1920, height: 1080),
    );

    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.startPreview();
    await _engine.joinChannel(
      token: agoraToken,
      channelId: widget.channelName,
      uid: 0,
      options: ChannelMediaOptions(
        clientRoleType: widget.role,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: agoraAppId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );
    await _engine.enableVideo();
    await _engine.setClientRole(role: widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            final info =
                'onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
            _infoStrings.add(info);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          setState(() {
            _infoStrings.add('onLeaveChannel');
            _users.clear();
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            final info = 'userJoined: $remoteUid';
            _infoStrings.add(info);
            _users.add(remoteUid);
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          setState(() {
            final info = 'userOffline: $remoteUid';
            _infoStrings.add(info);
            _users.remove(remoteUid);
          });
        },
        // onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        //   debugPrint(
        //       '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        // },
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<Widget> list = [];
    if (widget.role == ClientRoleType.clientRoleBroadcaster) {
      list.add(
        AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
          ),
        ),
      );
    }
    for (var uid in _users) {
      list.add(
        AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: uid),
            connection: RtcConnection(channelId: widget.channelName),
          ),
        ),
      );
    }
    return list;
  }

  /// Video view wrapper
  Widget _videoView(Widget view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(children: wrappedViews),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    if (views.length > 1) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setState(() => moreThanOne = true));
    }
    if (widget.userCallingType == UserCallingType.receiver &&
        views.length == 1 &&
        moreThanOne) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await CallingRoomsCubit.get(context)
            .deleteTheRoom(channelId: widget.channelName);
        setState(() => amICalling = false);
      });
      Navigator.of(context).maybePop();
    }

    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        );
      default:
    }
    return const SizedBox();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRoleType.clientRoleAudience) {
      return Container();
    }
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    setState(() => amICalling = false);
    CallingRoomsCubit.get(context).leaveTheRoom(
      userId: myPersonalInfo.userId,
      channelId: widget.channelName,
      isThatAfterJoining: true,
    );
    Navigator.of(context).maybePop();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    final views = _getRenderViews();
    final int? numOfUsers = widget.usersInfo?.length;
    return Material(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _viewRows(),
            if (views.length == 1) ...[
              Positioned(
                top: 30,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.video_camera_back_rounded,
                          color: ColorManager.white, size: 33),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _onToggleMute,
                        child: Icon(
                          muted
                              ? Icons.mic_off_rounded
                              : Icons.mic_none_rounded,
                          color: Colors.white,
                          size: 33.0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.volume_up_rounded,
                          color: ColorManager.white, size: 33),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _onCallEnd(context),
                        child: const Icon(Icons.close_rounded,
                            color: ColorManager.white, size: 33),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.usersInfo != null) ...[
                      if (numOfUsers == 1) ...[
                        buildCircleAvatar(0, 1000),
                      ] else if (numOfUsers != 0) ...[
                        Align(
                          alignment: Alignment.bottomRight,
                          child: buildCircleAvatar(0, 700),
                        ),
                        Positioned(
                            height: -15,
                            left: -10,
                            child: buildCircleAvatar(1, 700)),
                      ],
                      const SizedBox(height: 30),
                      ...List.generate(numOfUsers!, (index) {
                        return Text(widget.usersInfo![index].name,
                            style: getNormalStyle(
                                color: ColorManager.white, fontSize: 25));
                      }),
                    ],
                    const SizedBox(height: 10),
                    Text('Connecting...',
                        style: getNormalStyle(
                            color: ColorManager.white, fontSize: 16.5)),
                  ],
                ),
              ),
            ] else ...[
              _toolbar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildCircleAvatar(int index, double bodyHeight) {
    return CircleAvatarOfProfileImage(
      bodyHeight: bodyHeight,
      userInfo: widget.usersInfo![index],
      disablePressed: true,
      showColorfulCircle: false,
    );
  }
}
