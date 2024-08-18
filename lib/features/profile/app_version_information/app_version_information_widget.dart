import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/profile/app_version_information/bloc/app_version_information_bloc.dart';
import 'package:odo24_mobile/features/profile/app_version_information/bloc/app_version_information_states.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
          final textTheme = Theme.of(context).textTheme;

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
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Обновите через магазин приложений или на сайте ',
                        style: textTheme.bodyMedium,
                      ),
                      TextSpan(
                        text: 'https://odo24.ru',
                        style: textTheme.bodyMedium?.copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            await launchUrlString('https://odo24.ru');
                          },
                      )
                    ],
                  ),
                ),
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
