import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onNewVideoPressed;

  const CustomVideoPlayer({
    super.key,
    required this.video,
    required this.onNewVideoPressed,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController;
  Duration currentPosition = Duration();
  bool showControls = false;

  @override
  void initState() {
    super.initState();

    videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    initializeController();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldwidget) {
    super.didUpdateWidget(oldwidget);

    if (oldwidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  initializeController() async {
    currentPosition = Duration();

    videoController = VideoPlayerController.file(
      File(
        widget.video.path,
      ),
    );

    await videoController!.initialize();

    videoController!.addListener(() {
      final currentPosition = videoController!.value.position;
    });

    setState(() {
      this.currentPosition = currentPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return CircularProgressIndicator();
    } else {
      return AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: GestureDetector(
            onTap: () {
              showControls = !showControls;
            },
            child: Stack(
              children: [
                VideoPlayer(
                  videoController!,
                ),
                //videoPlayer 위에
                if (showControls)
                  _Controls(
                    onForwardPressed: onForwardPressed,
                    onPlayPressed: onPlayPressed,
                    onReversePressed: onReversePressed,
                    isPlaying: videoController!.value.isPlaying,
                  ),
                if (showControls)
                  _NewVideo(
                    onPressed: widget.onNewVideoPressed,
                  ),
                _SliderBottom(
                    currentPosition: currentPosition,
                    maxPosition: videoController!.value.duration,
                    onSliderChanged: onSliderChanged)
              ],
            ),
          ));
    }
  }

  void onSliderChanged(double val) {
    setState(() {
      videoController!.seekTo(
        Duration(
          seconds: val.toInt(),
        ),
      );
    });
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

    videoController!.seekTo(position);
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
      height: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(
        0.5,
      ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            renderIconButton(onPressed: () {}, iconData: Icons.rotate_left),
            renderIconButton(
                onPressed: () {},
                iconData: isPlaying ? Icons.pause : Icons.play_arrow),
            renderIconButton(onPressed: () {}, iconData: Icons.rotate_right),
          ],
        ),
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

class _NewVideo extends StatelessWidget {
  final VoidCallback onPressed;

  _NewVideo({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        onPressed: onPressed,
        color: Colors.white,
        iconSize: 30.0,
        icon: Icon(
          Icons.photo_camera_back,
        ),
      ),
    );
  }
}

class _SliderBottom extends StatelessWidget {
  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onSliderChanged;

  const _SliderBottom({
    super.key,
    required this.currentPosition,
    required this.maxPosition,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: [
            Text(
              '${currentPosition.inMinutes.toString().padLeft(2, '0')} : ${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
            Expanded(
              child: Slider(
                value: currentPosition.inSeconds.toDouble(),
                min: 0.0,
                max: maxPosition.inSeconds.toDouble(),
                onChanged: onSliderChanged,
              ),
            ),
            Text(
              '${maxPosition.inMinutes.toString().padLeft(2, '0')} : ${(maxPosition.inSeconds % 60).toString().padLeft(2, '0')}',
            ),
          ],
        ),
      ),
    );
  }
}
