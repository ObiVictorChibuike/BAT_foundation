import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreen extends StatefulWidget {
  final CachedVideoPlayerController playerController;
  const FullScreen({Key? key, required this.playerController})
      : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future landscapeMode() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  }

  Future setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }



  @override
  void initState() {
    super.initState();
    landscapeMode();
  }

  @override
  void dispose() {
    setAllOrientation();
    super.dispose();
  }

  String getPosition1() {
    final duration = Duration(
        milliseconds:
            widget.playerController.value.position.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          AspectRatio(
              aspectRatio:
                  // 16 / 19,
                  widget.playerController.value.aspectRatio,
              child: CachedVideoPlayer(widget.playerController)),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                widget.playerController.value.isPlaying
                    ? widget.playerController.pause()
                    : widget.playerController.play();
              },
              child: Container(
                color: Colors.transparent,
                // height: double.maxFinite,
                child: widget.playerController.value.isPlaying
                    ? const SizedBox.expand()
                    : Icon(
                        Icons.play_arrow,
                        color: Colors.white70,
                        size: 60,
                      ),
              ),
            ),
          ),
          //video progress timer
          Positioned(
              bottom: 18,
              left: 8,
              child: Text(
                getPosition1(),
                style: TextStyle(color: Colors.white),
              )),
          // video progress bar and full screen mode button
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 15,
                      child: VideoProgressIndicator(widget.playerController,
                          allowScrubbing: true),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.fullscreen_exit,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )),
        ],
      ),
    );
    //  CachedVideoPlayer(widget.playerController);
  }
}
