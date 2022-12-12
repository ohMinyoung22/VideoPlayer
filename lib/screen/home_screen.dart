import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderVideo() {
    return CustomVideoPlayer(
      video: video!,
      onNewVideoPressed: onLogoTap,
    );
  }

  Widget renderEmpty() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Logo(
              onTap: onLogoTap,
            ),
            _AppName(),
          ],
        ),
      ),
    );
  }

  void onLogoTap() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          "asset/image/logo.png",
        ),
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 128.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "VIDEO",
            style: textStyle,
          ),
          Text(
            'Player',
            style: textStyle.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
