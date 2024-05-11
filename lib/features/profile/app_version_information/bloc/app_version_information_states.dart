import 'package:odo24_mobile/core/file_loader/file_loader.dart';
import 'package:odo24_mobile/core/updater/data/models/apk_version.dart';

sealed class AppVersionState {
  const AppVersionState();

  factory AppVersionState.idle() = AppVersionWaitingState;
  factory AppVersionState.failure(Object message, {String? details}) => AppVersionErrorState(
        message.toString(),
        details: details,
      );
  factory AppVersionState.appVersionIsActual({required APKVersionModel currentVersion}) = AppVersionIsActualState;
  factory AppVersionState.appVersionIsAvailableNew({
    required APKVersionModel currentVersion,
    required APKVersionModel availableVersion,
  }) = AppVersionIsAvailableNewState;
  factory AppVersionState.appVersionDownload({
    required APKVersionModel currentVersion,
    required APKVersionModel downloadableVersion,
    required FileLoader fileLoader,
  }) = AppVersionDownloadState;
  factory AppVersionState.appVersionInstalling({
    required APKVersionModel currentVersion,
    required APKVersionModel installingVersion,
  }) = AppVersionInstallingState;
}

final class AppVersionWaitingState extends AppVersionState {
  const AppVersionWaitingState();
}

final class AppVersionErrorState extends AppVersionState {
  const AppVersionErrorState(this.message, {this.details});
  final String message;
  final String? details;

  @override
  String toString() {
    if (details != null) {
      return '$message ($details)';
    }
    return message.toString();
  }
}

final class AppVersionIsActualState extends AppVersionState {
  const AppVersionIsActualState({
    required this.currentVersion,
  });
  final APKVersionModel currentVersion;
}

final class AppVersionIsAvailableNewState extends AppVersionState {
  const AppVersionIsAvailableNewState({
    required this.currentVersion,
    required this.availableVersion,
  });
  final APKVersionModel currentVersion;
  final APKVersionModel availableVersion;
}

final class AppVersionDownloadState extends AppVersionState {
  const AppVersionDownloadState({
    required this.currentVersion,
    required this.downloadableVersion,
    required this.fileLoader,
  });
  final APKVersionModel currentVersion;
  final APKVersionModel downloadableVersion;
  final FileLoader fileLoader;
}

final class AppVersionInstallingState extends AppVersionState {
  const AppVersionInstallingState({
    required this.currentVersion,
    required this.installingVersion,
  });
  final APKVersionModel currentVersion;
  final APKVersionModel installingVersion;
}
