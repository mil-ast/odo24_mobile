import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/updater/data/models/apk_version.dart';
import 'package:odo24_mobile/core/updater/data/updater_repository.dart';
import 'package:odo24_mobile/features/profile/app_version_information/bloc/app_version_information_states.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionInformationBloc extends Cubit<AppVersionState> {
  AppVersionInformationBloc({
    required IUpdaterRepository updaterRepository,
  })  : _updaterRepository = updaterRepository,
        super(AppVersionState.idle());

  final IUpdaterRepository _updaterRepository;

  void checkVersion() async {
    final platform = await PackageInfo.fromPlatform();
    final currentVersion = APKVersionModel(
      versionCode: int.parse(platform.buildNumber),
      versionName: platform.version,
    );

    if (kIsWeb) {
      emit(AppVersionState.appVersionIsActual(currentVersion: currentVersion));
      return;
    }

    emit(AppVersionState.idle());

    final versionMeta = await _updaterRepository.getVersionMetadata();

    if (versionMeta.elements.isEmpty) {
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
}
