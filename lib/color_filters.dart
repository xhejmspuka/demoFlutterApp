import 'dart:ffi';

enum ColorFilter { red, green, blue, none }

String getFFmpegCommand(ColorFilter color, Size videoSize) {
  switch (color) {
    case ColorFilter.red:
      return '-vf "colorchannelmixer=1:0:0:0:0:0.3:0:0:0:0:0.3"';
    case ColorFilter.green:
      return '-vf "colorchannelmixer=0:1:0:0:0:0:0.3:0:0:0:0:0.3"';
    case ColorFilter.blue:
      return '-vf "colorchannelmixer=0:0:1:0:0:0:0:0:0.3:0:0:0:0.3"';
    default:
      return '-vf "colorchannelmixer=0:0:0:0:0:0:0:0:0:0:0:1"';
  }
}
