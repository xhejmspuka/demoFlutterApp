import 'dart:io';
import 'dart:ui';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';

import 'color_filters.dart';

class VideoProcessing {
  static Future<String?> applyFilterPreview(
      File videoFile, ColorFilter color, Size videoSize) async {
    final directory = await getApplicationDocumentsDirectory();
    String previewPath =
        '${directory.path}/preview_${DateTime.now().millisecondsSinceEpoch}.mp4';
    String ffmpegCommand =
        '-y -i ${videoFile.path} ${getFFmpegCommand(color, videoSize)} -codec:a copy $previewPath';

    final session = await FFmpegKit.execute(ffmpegCommand);
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      return previewPath;
    } else {
      return null;
    }
  }

  static String getFFmpegCommand(ColorFilter color, Size videoSize) {
    int width = videoSize.width.toInt();
    int height = videoSize.height.toInt();
    String colorHex;
    double opacity = 0.15;

    switch (color) {
      case ColorFilter.red:
        colorHex = "red@$opacity";
        break;
      case ColorFilter.green:
        colorHex = "green@$opacity";
        break;
      case ColorFilter.blue:
        colorHex = "blue@$opacity";
        break;
      default:
        return '-vf "format=yuv420p"';
    }

    return '-vf "color=$colorHex:s=${width}x$height [color];'
        '[0:v][color] overlay=shortest=1:format=auto,format=yuv420p"';
  }
}
