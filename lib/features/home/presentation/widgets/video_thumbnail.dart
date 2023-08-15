import 'package:batnf/features/home/presentation/widgets/video_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wakelock/wakelock.dart';

class Videos extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;
  const Videos({Key? key, required this.videoUrl, required this.thumbnailUrl})
      : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  bool playVideo = false;
  late CachedVideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    initializePlayer(widget.videoUrl);
  }

  void initializePlayer(String url) async {
    _playerController =
        CachedVideoPlayerController.network('https://www.batnf.net/$url');
    await _playerController.initialize();
    _playerController.addListener(listener);
    _playerController.setLooping(true);
    await Wakelock.enable();
  }

  void listener() async {
    await Future.delayed(const Duration(milliseconds: 1));
    setState(() {});
  }

  @override
  void dispose() {
    _playerController.removeListener(listener);
    _playerController.dispose();
    super.dispose();
  }

  String getPosition() {
    final duration = Duration(
        milliseconds: _playerController.value.position.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

String getDuration() {
    final duration =
        Duration(milliseconds: _playerController.value.duration.inMilliseconds.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }


  @override
  Widget build(BuildContext context) {
    if (!playVideo) {
      return Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          CachedNetworkImage(
            // height: double.maxFinite,
            errorWidget: (context, url, error) => Center(
              child: Text('Error Loading Images'),
            ),
            // ignore: prefer_const_constructors
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
              ),
            imageUrl: 'https://www.batnf.net/${widget.thumbnailUrl}',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (_playerController.value.isInitialized) {
                  setState(() {
                    playVideo = true;
                  });
                  _playerController.play();
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Icon(
                  FontAwesomeIcons.playCircle,
                  color: Colors.blue,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        final isPortrait = orientation == Orientation.portrait;
        return Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            AspectRatio(
                aspectRatio:
                    // 16 / 19,
                    _playerController.value.aspectRatio,
                child: CachedVideoPlayer(_playerController)),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _playerController.value.isPlaying
                      ? _playerController.pause()
                      : _playerController.play();
                },
                child: Container(
                  color: Colors.transparent,
                  // height: double.maxFinite,
                  child: _playerController.value.isPlaying
                      ? const SizedBox.expand()
                      : Icon(
                          FontAwesomeIcons.playCircle,
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
                child: Row(
                  children: [
                    Text(
                      getPosition(),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      ' / ',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      getDuration(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
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
                        child: VideoProgressIndicator(_playerController,
                            allowScrubbing: true),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.fullscreen,
                        size: 30,
                        color: Colors.white,
                      ),
                      onPressed: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreen(playerController: _playerController,)));
                        // if (isPortrait) {
                        //   AutoOrientation.landscapeRightMode();
                        // } else {
                        //   AutoOrientation.portraitUpMode();
                        // }
                      },
                    )
                  ],
                )),
          ],
        );
      },
    );
  }
}
