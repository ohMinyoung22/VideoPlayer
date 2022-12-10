import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({super.key, required this.video});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();

    videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    initializeController();
  }

  initializeController() async {
    await videoController!.initialize();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return CircularProgressIndicator();
    } else {
      return AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(
                videoController!,
              ),
              //videoPlayer 위에
              _Controls(
                onForwardPressed: onForwardPressed,
                onPlayPressed: onPlayPressed,
                onReversePressed: onReversePressed,
                isPlaying: videoController!.value.isPlaying,
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  onPressed: () {},
                  color: Colors.white,
                  iconSize: 30.0,
                  icon: Icon(
                    Icons.photo_camera_back,
                  ),
                ),
              ),
            ],
          ));
    }
  }

  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    Duration position = Duration();
    if (currentPosition.inSeconds > 3) {
      currentPosition - const Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    Duration position = maxPosition;
    if (maxPosition - currentPosition > const Duration(seconds: 3)) {
      position = currentPosition + const Duration(seconds: 3);
    }
  }

  void onPlayPressed() {
    //실행 중 -> 중지 || 정지 중 -> 실행

    setState(() {
      if (videoController!.value.isPlaying) {
        videoController!.pause();
      } else {
        videoController!.play();
      }
    });
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _Controls({
    super.key,
    required this.onForwardPressed,
    required this.onPlayPressed,
    required this.onReversePressed,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(
        0.5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(onPressed: () {}, iconData: Icons.rotate_left),
          renderIconButton(
              onPressed: () {},
              iconData: isPlaying ? Icons.pause : Icons.play_arrow),
          renderIconButton(onPressed: () {}, iconData: Icons.rotate_right),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData,
      ),
    );
  }
}
