import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

import 'color_filters.dart';
import 'video_processing.dart';

class VideoEditorScreen extends StatefulWidget {
  final File videoFile;

  const VideoEditorScreen({super.key, required this.videoFile});

  @override
  VideoEditorScreenState createState() =>
      VideoEditorScreenState(); // Now public
}

class VideoEditorScreenState extends State<VideoEditorScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = false;
  String? _outputVideoPath;
  File? _videoFile;

  @override
  void initState() {
    super.initState();
    _videoFile = widget.videoFile;
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.file(_videoFile!)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  Future<void> _applyFilterPreview(ColorFilter filter) async {
    setState(() => _isLoading = true);

    String? filteredVideoPath = await VideoProcessing.applyFilterPreview(
        widget.videoFile, filter, _controller.value.size);
    if (filteredVideoPath != null) {
      _outputVideoPath = filteredVideoPath;
      _controller = VideoPlayerController.file(File(filteredVideoPath))
        ..initialize().then((_) {
          setState(() => _isLoading = false);
          _controller.play();
        }).catchError((error) {
          setState(() => _isLoading = false);
        });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _saveVideo() async {
    if (_outputVideoPath == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No video to save!")));
      return;
    }

    final bool? isSaved = await GallerySaver.saveVideo(_outputVideoPath!);
    if (isSaved != null && isSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Video saved successfully!")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to save video!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff202a30),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width ?? 0,
                height: _controller.value.size.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          _buildFloatingActionButtons(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Positioned(
      top: 20,
      right: 20,
      child: SafeArea(
        child: Column(
          children: [
            _createActionButton(ColorFilter.red, Icons.stop,
                Colors.red.withOpacity(0.3), "filterRed"),
            const SizedBox(height: 10),
            _createActionButton(ColorFilter.green, Icons.stop,
                Colors.green.withOpacity(0.3), "filterGreen"),
            const SizedBox(height: 10),
            _createActionButton(ColorFilter.blue, Icons.stop,
                Colors.blue.withOpacity(0.3), "filterBlue"),
            const SizedBox(height: 20),
            _createActionButton(null, Icons.save, Colors.blueGrey, "saveVideo",
                isSaveButton: true),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _createActionButton(
      ColorFilter? filter, IconData icon, Color bgColor, String heroTag,
      {bool isSaveButton = false}) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: isSaveButton ? _saveVideo : () => _applyFilterPreview(filter!),
      backgroundColor: bgColor,
      child: Icon(icon),
    );
  }
}
