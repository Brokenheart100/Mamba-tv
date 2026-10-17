import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isAndroidEmulator() async =>
    Platform.isAndroid &&
    !(await DeviceInfoPlugin().androidInfo).isPhysicalDevice;
