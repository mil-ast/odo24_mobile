import 'dart:io';

import 'package:flutter/services.dart';
import 'package:odo24_mobile/core/updater/data/models/abis_model.dart';
import 'package:path_provider/path_provider.dart';

class APKUpdater {
  static const f = 'app-x86_64-release.apk';
  final methodChannel = const MethodChannel('odo24/channel');
  final List<SupportedABIs> _supportedAbis = [];

  Future<List<SupportedABIs>> getSupportedAbis() async {
    if (_supportedAbis.isNotEmpty) {
      return _supportedAbis;
    }
    final message = await methodChannel.invokeMethod<List<dynamic>>('getSupportedAbis');
    if (message == null) {
      return [];
    }
    final list = message.where((item) => item != null);
    final abis = List<String>.from(list).map(SupportedABIs.fromString);
    _supportedAbis.addAll(abis);
    return abis.toList();
  }

  Future<int?> installAppFromFile(File file) async {
    if (!file.existsSync()) {
      throw FileSystemException('file not found', file.path);
    }
    Process.runSync('chmod', ['u+x', file.path]);
    return methodChannel.invokeMethod<int>('installAppFromFile', <String, String>{
      'filePath': file.path,
    });
  }

  Future<String> getLocalAPKFilePath() async {
    final tempDir = await getApplicationCacheDirectory();
    return '${tempDir.absolute.path}/odo24.apk';
  }
}
