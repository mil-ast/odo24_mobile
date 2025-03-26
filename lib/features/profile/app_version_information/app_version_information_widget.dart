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
        updaterRepository: dependencies.updaterRepository,
      )..checkVersion(),
      child: BlocBuilder<AppVersionInformationBloc, AppVersionState>(
        builder: (context, state) {
          if (state is AppVersionIsActualState) {
            return ListTile(
              title: Text('${state.currentVersion.versionName}+${state.currentVersion.versionCode}'),
              subtitle: const Text('Установлена актуальная версия'),
              trailing: IconButton(
                onPressed: context.read<AppVersionInformationBloc>().checkVersion,
                icon: const Icon(Icons.refresh),
              ),
            );
          } else if (state is AppVersionIsAvailableNewState) {
            return ListTile(
              leading: const Icon(Icons.system_update_outlined),
              title: Text(
                'Доступна новая версия ${state.availableVersion.versionName}',
              ),
              subtitle: const Text('Обновите через магазин приложений'),
              trailing: const Icon(Icons.open_in_browser_outlined),
              onTap: () async {
                dependencies.methodChannel.invokeMethod<List<dynamic>>('launchURL', <String, String>{
                  'url': dependencies.siteURL,
                });
              },
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
