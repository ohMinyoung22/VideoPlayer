import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset("asset/image/logo.png"),
          Row(
            children: [Text("VIDEO"), Text('Player')],
          )
        ],
      ),
    );
  }
}
