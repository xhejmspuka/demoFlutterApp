import 'package:demo_flutter_project/upload_video.dart';
import 'package:flutter/material.dart';

void main() => runApp(const VideoEditorApp());

class VideoEditorApp extends StatelessWidget {
  const VideoEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      title: 'Video Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const UploadVideoScreen(),
    );
  }
}
