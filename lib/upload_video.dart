import 'dart:io';

import 'package:demo_flutter_project/video_editor_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  UploadVideoScreenState createState() => UploadVideoScreenState();
}

class UploadVideoScreenState extends State<UploadVideoScreen> {
  bool _isLoading = false;

  Future<void> _pickVideo() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _isLoading = true;
      });
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoEditorScreen(videoFile: File(result.files.single.path!)),
          ),
        ).then((_) => setState(() {
              _isLoading = false;
            }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202a30),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _pickVideo,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xff28363d),
                shadowColor: const Color(0xff151d21),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              child: const Text('Upload Video',
                  style: TextStyle(color: Colors.white)),
            ),
            if (_isLoading)
              Container(
                margin: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
