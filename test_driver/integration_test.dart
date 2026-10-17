import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart' as image;

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    final directory = Directory('artifacts/screenshots');
    await directory.create(recursive: true);
    await File('${directory.path}/$name.png').writeAsBytes(bytes);
    final frame = image.decodePng(Uint8List.fromList(bytes));
    if (frame == null) return false;
    var sampled = 0;
    var visible = 0;
    // Inspect the video center, excluding header, controls and progress UI.
    for (var y = (frame.height * .3).round(); y < frame.height * .7; y += 12) {
      for (
        var x = (frame.width * .25).round();
        x < frame.width * .75;
        x += 12
      ) {
        final pixel = frame.getPixel(x, y);
        sampled++;
        if (pixel.r + pixel.g + pixel.b > 30) visible++;
      }
    }
    final ratio = sampled == 0 ? 0.0 : visible / sampled;
    await File('${directory.path}/$name.json').writeAsString(
      jsonEncode({
        'width': frame.width,
        'height': frame.height,
        'visibleVideoFraction': ratio,
      }),
    );
    return ratio > .1;
  },
);
