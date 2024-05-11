import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/updater/data/updater_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NewVersionInformationCubit extends Cubit<bool> {
  NewVersionInformationCubit({
    required Duration checkVersionInterval,
    required IUpdaterRepository updaterRepository,
  })  : _updaterRepository = updaterRepository,
        super(false) {
    _timer = Timer(checkVersionInterval, checkVersion);
  }

  @override
  Future<void> close() async {
    _timer.cancel();
    super.close();
  }

  final IUpdaterRepository _updaterRepository;
  late final Timer _timer;

  void checkVersion() async {
    final platform$ = PackageInfo.fromPlatform();
    final versionMeta$ = _updaterRepository.getVersionMetadata();

    final platform = await platform$;
    final versionMeta = await versionMeta$;

    if (versionMeta.elements.isEmpty) {
      return;
    }

    final currentVersionCode = int.parse(platform.buildNumber);
    final availableVersion = versionMeta.elements.first;
    emit(availableVersion.versionCode > currentVersionCode);
  }
}
