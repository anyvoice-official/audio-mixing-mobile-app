import 'package:audio_mixing_mobile_app/audio_mixing/view/audio_mixing_view.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Audio Mixing",
      home: AudioMixingView(),
    );
  }
}