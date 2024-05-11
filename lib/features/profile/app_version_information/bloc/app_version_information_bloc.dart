import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/file_loader/file_loader.dart';
import 'package:odo24_mobile/core/http/http_api.dart';
import 'package:odo24_mobile/core/updater/apk_updater.dart';
import 'package:odo24_mobile/core/updater/data/models/abis_model.dart';
import 'package:odo24_mobile/core/updater/data/models/apk_version.dart';
import 'package:odo24_mobile/core/updater/data/updater_repository.dart';
import 'package:odo24_mobile/features/profile/app_version_information/bloc/app_version_information_states.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionInformationBloc extends Cubit<AppVersionState> {
  AppVersionInformationBloc({
    required APKUpdater apkUpdater,
    required IUpdaterRepository updaterRepository,
  })  : _apkUpdater = apkUpdater,
        _updaterRepository = updaterRepository,
        super(AppVersionState.idle());

  final APKUpdater _apkUpdater;
  final IUpdaterRepository _updaterRepository;

  void checkVersion() async {
    emit(AppVersionState.idle());

    final platform = await PackageInfo.fromPlatform();
    final versionMeta = await _updaterRepository.getVersionMetadata();

    final currentVersion = APKVersionModel(
      versionCode: int.parse(platform.buildNumber),
      versionName: platform.version,
    );

    if (kIsWeb || versionMeta.elements.isEmpty) {
      emit(AppVersionState.appVersionIsActual(currentVersion: currentVersion));
      return;
    }

    final availableVersion = versionMeta.elements.first;
    if (availableVersion.versionCode > currentVersion.versionCode) {
      emit(AppVersionState.appVersionIsAvailableNew(
        currentVersion: currentVersion,
        availableVersion: APKVersionModel(
          versionCode: availableVersion.versionCode,
          versionName: availableVersion.versionName,
        ),
      ));
      return;
    }

    emit(AppVersionState.appVersionIsActual(currentVersion: currentVersion));
  }

  void clickInstallNewVersion({
    required APKVersionModel currentVersion,
    required APKVersionModel availableVrsion,
  }) async {
    try {
      final abis = await _apkUpdater.getSupportedAbis();
      final fileUrl = _getFileUrlByABIs(abis);
      final saveToPath = await _apkUpdater.getLocalAPKFilePath();

      final fileLoader = FileLoader(
        fileURL: '${HttpAPI.staticBaseURLHost}/apk/$fileUrl',
        saveToPath: saveToPath,
      );
      emit(AppVersionState.appVersionDownload(
        currentVersion: currentVersion,
        downloadableVersion: availableVrsion,
        fileLoader: fileLoader,
      ));
      await fileLoader.loadFile();

      final file = File(fileLoader.saveToPath);
      await _apkUpdater.installAppFromFile(file);

      emit(AppVersionState.appVersionInstalling(
        currentVersion: currentVersion,
        installingVersion: availableVrsion,
      ));
    } catch (e) {
      emit(AppVersionState.failure(e));
    }
  }

  String _getFileUrlByABIs(List<SupportedABIs> abis) {
    if (abis.isEmpty) {
      return 'app-universal-release.apk';
    }
    return 'app-${abis.first.value}-release.apk';
  }
}
