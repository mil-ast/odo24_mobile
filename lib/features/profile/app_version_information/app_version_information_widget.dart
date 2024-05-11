import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/profile/app_version_information/bloc/app_version_information_bloc.dart';
import 'package:odo24_mobile/features/profile/app_version_information/bloc/app_version_information_states.dart';

class AppVersionInformationWidget extends StatelessWidget {
  const AppVersionInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = DependenciesScope.of(context);
    return BlocProvider(
      create: (context) => AppVersionInformationBloc(
        apkUpdater: dependencies.apkUpdater,
        updaterRepository: dependencies.updaterRepository,
      )..checkVersion(),
      child: BlocBuilder<AppVersionInformationBloc, AppVersionState>(
        builder: (context, state) {
          if (state is AppVersionIsActualState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Установлена актуальная версия'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.currentVersion.versionName}+${state.currentVersion.versionCode}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                      onPressed: context.read<AppVersionInformationBloc>().checkVersion,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is AppVersionIsAvailableNewState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Stack(
                  children: [
                    Text('Доступна новая версия'),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.circle,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.availableVersion.versionName}+${state.availableVersion.versionCode}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.read<AppVersionInformationBloc>().clickInstallNewVersion(
                              currentVersion: state.currentVersion,
                              availableVrsion: state.availableVersion,
                            );
                      },
                      icon: const Icon(Icons.download_for_offline_outlined),
                      label: const Text('Обновить'),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is AppVersionDownloadState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Загрузка новой версии...'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.downloadableVersion.versionName}+${state.downloadableVersion.versionCode}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    StreamBuilder(
                      stream: state.fileLoader.loadStream,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          return CircularProgressIndicator(value: snap.data!);
                        }
                        return const CircularProgressIndicator(value: 0);
                      },
                    ),
                  ],
                ),
              ],
            );
          } else if (state is AppVersionInstallingState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Установка'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.installingVersion.versionName}+${state.installingVersion.versionCode}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ],
            );
          } else if (state is AppVersionErrorState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ошибка обновления'),
                Text(state.message),
              ],
            );
          }

          return const Center(
            child: SingleChildScrollView(),
          );
        },
      ),
    );
  }
}
